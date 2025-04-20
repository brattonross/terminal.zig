pub const ProductClient = struct {
    client: *Client,

    pub fn list(self: ProductClient) !Result(ListProductsResponse) {
        return try self.client.fetch(ListProductsResponse, .GET, "/product", .{});
    }

    pub fn getById(self: ProductClient, id: []const u8) !Result(GetProductByIdResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/product/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(GetProductByIdResponse, .GET, url, .{});
    }
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
const Client = @import("Client.zig");
const Result = Client.Result;
