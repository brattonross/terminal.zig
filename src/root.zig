const default_base_uri = std.Uri.parse("https://api.terminal.shop") catch unreachable;

pub const ClientOptions = struct {
    allocator: std.mem.Allocator,
    base_uri: ?std.Uri = null,
    http_client: ?std.http.Client = null,
};

pub const Client = struct {
    allocator: std.mem.Allocator,
    base_uri: std.Uri,
    http_client: std.http.Client,

    pub fn init(opts: ClientOptions) Client {
        return .{
            .allocator = opts.allocator,
            .base_uri = opts.base_uri orelse default_base_uri,
            .http_client = opts.http_client orelse std.http.Client{ .allocator = opts.allocator },
        };
    }

    pub fn fetch(self: *Client, comptime T: type, method: std.http.Method, url: []const u8) !Result(T) {
        var uri_buf: [1024]u8 = undefined;
        var remainder: []u8 = &uri_buf;
        const uri = try self.base_uri.resolve_inplace(url, &remainder);

        var headers_buf: [1024]u8 = undefined;
        var request = try self.http_client.open(method, uri, .{ .server_header_buffer = &headers_buf });
        defer request.deinit();

        try request.send();
        try request.finish();
        try request.wait();

        var buf: [65535]u8 = undefined;
        const bytes_read = try request.readAll(&buf);
        const body = buf[0..bytes_read];

        return switch (request.response.status) {
            .ok => .{
                .success = try std.json.parseFromSliceLeaky(T, self.allocator, body, .{ .allocate = .alloc_always, .ignore_unknown_fields = true }),
            },
            else => .{
                .@"error" = try std.json.parseFromSliceLeaky(ErrorResponse, self.allocator, body, .{ .allocate = .alloc_always, .ignore_unknown_fields = true }),
            },
        };
    }

    pub fn products(self: *Client) ProductsClient {
        return .{ .client = self };
    }

    pub const ProductsClient = struct {
        client: *Client,

        pub fn list(self: ProductsClient) !Result(ListProductsResponse) {
            return try self.client.fetch(ListProductsResponse, .GET, "/product");
        }

        pub fn getById(self: ProductsClient, id: []const u8) !Result(GetProductByIdResponse) {
            const url = try std.fmt.allocPrint(self.client.allocator, "/product/{s}", .{id});
            defer self.client.allocator.free(url);
            return try self.client.fetch(GetProductByIdResponse, .GET, url);
        }
    };
};

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
};

pub const Product = struct {
    id: []const u8,
    name: []const u8,
    description: []const u8,
    variants: []Variant,
    order: ?u32 = null,
    subscription: ?Subscription = null,
    tags: ?Tags = null,

    pub const Variant = struct {
        id: []const u8,
        name: []const u8,
        price: u32,
    };

    pub const Subscription = enum {
        allowed,
        required,
    };

    pub const Tags = struct {
        app: ?[]const u8 = null,
        color: ?[]const u8 = null,
        featured: ?bool = null,
        market_eu: ?bool = null,
        market_na: ?bool = null,
    };
};

pub const ListProductsResponse = struct {
    data: []Product,
};

pub const GetProductByIdResponse = struct {
    data: Product,
};

const std = @import("std");
