const default_base_uri = std.Uri.parse("https://api.terminal.shop") catch unreachable;

pub const Options = struct {
    allocator: std.mem.Allocator,
    base_uri: ?std.Uri = null,
    bearer_token: []const u8,
    http_client: ?std.http.Client = null,
};

allocator: std.mem.Allocator,
base_uri: std.Uri,
bearer_token: []const u8,
http_client: std.http.Client,

pub fn init(opts: Options) Client {
    return .{
        .allocator = opts.allocator,
        .base_uri = opts.base_uri orelse default_base_uri,
        .bearer_token = opts.bearer_token,
        .http_client = opts.http_client orelse std.http.Client{ .allocator = opts.allocator },
    };
}

pub fn fetch(self: *Client, comptime T: type, method: std.http.Method, url: []const u8, body: anytype) !Result(T) {
    var uri_buf: [1024]u8 = undefined;
    var remainder: []u8 = &uri_buf;
    const uri = try self.base_uri.resolve_inplace(url, &remainder);

    var auth_header_buf: [256]u8 = undefined;
    const auth_header_value = try std.fmt.bufPrint(&auth_header_buf, "Bearer {s}", .{self.bearer_token});

    var headers_buf: [1024]u8 = undefined;
    var request = try self.http_client.open(method, uri, .{
        .headers = .{
            .accept_encoding = .{ .override = "application/json" },
            .authorization = .{ .override = auth_header_value },
            .content_type = .{ .override = "application/json" },
        },
        .server_header_buffer = &headers_buf,
    });
    defer request.deinit();

    try request.send();

    const BodyType = @TypeOf(body);
    const body_type_info = @typeInfo(BodyType);
    if (body_type_info != .@"struct") {
        @compileError("expected tuple or struct argument, found " ++ @typeName(BodyType));
    }
    if (body_type_info.@"struct".fields.len > 0) {
        request.transfer_encoding = .{ .chunked = {} };
        try std.json.stringify(body, .{}, request.writer());
    }

    try request.finish();
    try request.wait();

    var buf: [65535]u8 = undefined;
    const bytes_read = try request.readAll(&buf);
    const response_body = buf[0..bytes_read];

    return switch (request.response.status) {
        .ok => .{
            .success = try std.json.parseFromSliceLeaky(
                T,
                self.allocator,
                response_body,
                .{ .allocate = .alloc_always, .ignore_unknown_fields = true },
            ),
        },
        else => .{
            .@"error" = try std.json.parseFromSliceLeaky(
                ErrorResponse,
                self.allocator,
                response_body,
                .{ .allocate = .alloc_always, .ignore_unknown_fields = true },
            ),
        },
    };
}

pub fn product(self: *Client) ProductClient {
    return .{ .client = self };
}

pub fn profile(self: *Client) ProfileClient {
    return .{ .client = self };
}

pub fn Result(comptime T: type) type {
    return union(enum) {
        success: T,
        @"error": ErrorResponse,
    };
}

pub const ErrorResponse = struct {
    type: Type,
    code: []const u8,
    message: []const u8,
    param: ?[]const u8 = null,

    pub const Type = enum {
        validation,
        authentication,
        forbidden,
        not_found,
        rate_limit,
        internal,
    };

    pub fn format(self: ErrorResponse, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;
        _ = options;
        try std.json.stringify(self, .{}, writer);
    }
};

const Client = @This();
const std = @import("std");
const ProductClient = @import("product.zig").ProductClient;
const ProfileClient = @import("profile.zig").ProfileClient;
