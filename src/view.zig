pub const ViewClient = struct {
    client: *Client,

    pub fn init(self: ViewClient) !Result(InitViewResponse) {
        return try self.client.fetch(InitViewResponse, .GET, "/view/init", .{});
    }
};

pub const InitViewResponse = struct {
    data: Data,

    pub const Data = struct {
        profile: Profile,
        products: []Product,
        cart: Cart,
        addresses: []Address,
        cards: []Card,
        subscriptions: []Subscription,
        orders: []Order,
        tokens: []Token,
        apps: []App,
        region: []const u8,
    };
};

const std = @import("std");
const Client = @import("Client.zig");
const Result = Client.Result;
const Profile = @import("profile.zig").Profile;
const Product = @import("product.zig").Product;
const Cart = @import("cart.zig").Cart;
const Address = @import("address.zig").Address;
const Card = @import("card.zig").Card;
const Subscription = @import("subscription.zig").Subscription;
const Order = @import("order.zig").Order;
const Token = @import("token.zig").Token;
const App = @import("app.zig").App;
