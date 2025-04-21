pub const CartClient = struct {
    client: *Client,

    pub fn get(self: CartClient) !Result(GetCartResponse) {
        return try self.client.fetch(GetCartResponse, .GET, "/cart", .{});
    }

    pub fn addItem(self: CartClient, request: CartAddItemRequest) !Result(CartAddItemResponse) {
        return try self.client.fetch(CartAddItemResponse, .PUT, "/cart/item", request);
    }

    pub fn setAddress(self: CartClient, request: CartSetAddressRequest) !Result(CartSetAddressResponse) {
        return try self.client.fetch(CartSetAddressResponse, .PUT, "/cart/address", request);
    }

    pub fn setCard(self: CartClient, request: CartSetCardRequest) !Result(CartSetCardResponse) {
        return try self.client.fetch(CartSetCardResponse, .PUT, "/cart/card", request);
    }

    pub fn convertToOrder(self: CartClient) !Result(CartConvertToOrderResponse) {
        return try self.client.fetch(CartConvertToOrderResponse, .POST, "/cart/convert", .{});
    }

    pub fn clear(self: CartClient) !Result(ClearCartResponse) {
        return try self.client.fetch(ClearCartResponse, .DELETE, "/cart", .{});
    }
};

pub const Cart = struct {
    subtotal: u32,
    items: []Item,
    amount: Amount,
    addressID: ?[]const u8 = null,
    cardID: ?[]const u8 = null,
    shipping: ?Shipping = null,

    pub const Item = struct {
        id: []const u8,
        productVariantID: []const u8,
        quantity: u32,
        subtotal: u32,
    };

    pub const Amount = struct {
        subtotal: u32,
        shipping: ?u32 = null,
    };

    pub const Shipping = struct {
        service: []const u8,
        timeframe: []const u8,
    };
};

pub const GetCartResponse = struct {
    data: Cart,
};

pub const CartAddItemRequest = struct {
    productVariantID: []const u8,
    quantity: u32,
};

pub const CartAddItemResponse = struct {
    data: Cart,
};

pub const CartSetAddressRequest = struct {
    addressID: []const u8,
};

pub const CartSetAddressResponse = struct {
    data: []const u8,
};

pub const CartSetCardRequest = struct {
    cardID: []const u8,
};

pub const CartSetCardResponse = struct {
    data: []const u8,
};

pub const CartConvertToOrderResponse = struct {
    data: Order,
};

pub const ClearCartResponse = struct {
    data: []const u8,
};

const Client = @import("Client.zig");
const Result = Client.Result;
const Order = @import("order.zig").Order;
