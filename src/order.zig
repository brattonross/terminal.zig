pub const OrderClient = struct {
    client: *Client,

    /// List the orders associated with the current user.
    pub fn list(self: OrderClient) !Result(ListOrdersResponse) {
        return try self.client.fetch(ListOrdersResponse, .GET, "/order", .{});
    }

    /// Get the order with the given id.
    pub fn getById(self: OrderClient, id: []const u8) !Result(GetOrderByIdResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/order/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(GetOrderByIdResponse, .GET, url, .{});
    }

    /// Create an order without a cart. The order will be placed immediately.
    pub fn create(self: OrderClient, request: CreateOrderRequest) !Result(CreateOrderResponse) {
        return try self.client.fetch(CreateOrderResponse, .POST, "/order", request);
    }
};

pub const Order = struct {
    id: []const u8,
    index: ?u32 = null,
    shipping: Shipping,
    created: []const u8,
    amount: Amount,
    tracking: Tracking,
    items: []Item,

    pub const Shipping = struct {
        name: []const u8,
        street1: []const u8,
        street2: ?[]const u8 = null,
        city: []const u8,
        province: ?[]const u8 = null,
        country: []const u8,
        zip: []const u8,
        phone: ?[]const u8 = null,
    };

    pub const Amount = struct {
        shipping: u32,
        subtotal: u32,
    };

    pub const Tracking = struct {
        service: []const u8,
        number: []const u8,
        url: []const u8,
        status: []const u8,
        statusDetails: []const u8,
        statusUpdatedAt: []const u8,
    };

    pub const Item = struct {
        id: []const u8,
        description: ?[]const u8 = null,
        amount: u32,
        quantity: u32,
        productVariantID: ?[]const u8 = null,
    };
};

pub const ListOrdersResponse = struct {
    data: []Order,
};

pub const GetOrderByIdResponse = struct {
    data: Order,
};

pub const CreateOrderRequest = struct {
    cardID: []const u8,
    addressID: []const u8,
    variants: std.json.ArrayHashMap(u32),
};

pub const CreateOrderResponse = struct {
    data: []const u8,
};

const std = @import("std");
const Client = @import("Client.zig");
const Result = Client.Result;
