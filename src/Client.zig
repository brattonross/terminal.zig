const default_base_uri = std.Uri.parse("https://api.terminal.shop") catch unreachable;

/// Options for the Terminal API client.
pub const Options = struct {
    /// The allocator to use when allocating response structs, etc.
    allocator: std.mem.Allocator,
    /// The base URI of the API. Defaults to `https://api.terminal.shop`.
    base_uri: ?std.Uri = null,
    /// Your Terminal bearer token to send with requests.
    bearer_token: []const u8,
    /// Custom http client implementation.
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

pub fn product(self: *Client) ProductClient {
    return .{ .client = self };
}

pub fn profile(self: *Client) ProfileClient {
    return .{ .client = self };
}

pub fn address(self: *Client) AddressClient {
    return .{ .client = self };
}

pub fn card(self: *Client) CardClient {
    return .{ .client = self };
}

pub fn cart(self: *Client) CartClient {
    return .{ .client = self };
}

pub fn order(self: *Client) OrderClient {
    return .{ .client = self };
}

pub fn subscription(self: *Client) SubscriptionClient {
    return .{ .client = self };
}

pub fn token(self: *Client) TokenClient {
    return .{ .client = self };
}

pub fn app(self: *Client) AppClient {
    return .{ .client = self };
}

pub fn view(self: *Client) ViewClient {
    return .{ .client = self };
}

pub fn email(self: *Client) EmailClient {
    return .{ .client = self };
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
            .authorization = .{ .override = auth_header_value },
            .content_type = .{ .override = "application/json" },
        },
        .server_header_buffer = &headers_buf,
    });
    defer request.deinit();

    const BodyType = @TypeOf(body);
    const body_type_info = @typeInfo(BodyType);
    if (body_type_info != .@"struct") {
        @compileError("expected tuple or struct argument, found " ++ @typeName(BodyType));
    }

    if (body_type_info.@"struct".fields.len > 0) {
        request.transfer_encoding = .{ .chunked = {} };
        try request.send();
        try std.json.stringify(body, .{}, request.writer());
        try request.finish();
    } else {
        try request.send();
    }

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
const AddressClient = @import("address.zig").AddressClient;
const CardClient = @import("card.zig").CardClient;
const CartClient = @import("cart.zig").CartClient;
const OrderClient = @import("order.zig").OrderClient;
const SubscriptionClient = @import("subscription.zig").SubscriptionClient;
const TokenClient = @import("token.zig").TokenClient;
const AppClient = @import("app.zig").AppClient;
const ViewClient = @import("view.zig").ViewClient;
const EmailClient = @import("email.zig").EmailClient;
