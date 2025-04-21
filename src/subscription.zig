pub const SubscriptionClient = struct {
    client: *Client,

    pub fn list(self: SubscriptionClient) !Result(ListSubscriptionsResponse) {
        return try self.client.fetch(ListSubscriptionsResponse, .GET, "/subscription", .{});
    }

    pub fn getById(self: SubscriptionClient, id: []const u8) !Result(GetSubscriptionByIdResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/subscription/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(GetSubscriptionByIdResponse, .GET, url, .{});
    }

    pub fn update(self: SubscriptionClient, id: []const u8, request: UpdateSubscriptionRequest) !Result(UpdateSubscriptionResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/subscription/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(UpdateSubscriptionResponse, .PUT, url, request);
    }

    pub fn subscribe(self: SubscriptionClient, request: SubscribeRequest) !Result(SubscribeResponse) {
        return try self.client.fetch(SubscribeResponse, .POST, "/subscription", request);
    }

    pub fn cancel(self: SubscriptionClient, id: []const u8) !Result(CancelSubscriptionResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/subscription/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(CancelSubscriptionResponse, .DELETE, url, .{});
    }
};

pub const Subscription = struct {
    id: []const u8,
    productVariantID: []const u8,
    quantity: u32,
    addressID: []const u8,
    cardID: []const u8,
    schedule: ?Schedule = null,
    next: ?[]const u8 = null,
    created: []const u8,

    pub const Schedule = union(enum) {
        fixed: Fixed,
        weekly: Weekly,

        pub const Fixed = struct {
            type: []const u8,
        };

        pub const Weekly = struct {
            type: []const u8,
            interval: u32,
        };
    };
};

pub const ListSubscriptionsResponse = struct {
    data: []Subscription,
};

pub const GetSubscriptionByIdResponse = struct {
    data: Subscription,
};

pub const UpdateSubscriptionRequest = struct {
    cardID: []const u8,
    addressID: []const u8,
    schedule: Subscription.Schedule,
};

pub const UpdateSubscriptionResponse = struct {
    data: Subscription,
};

pub const SubscribeRequest = struct {
    productVariantID: []const u8,
    quantity: u32,
    addressID: []const u8,
    cardID: []const u8,
    schedule: Subscription.Schedule,
};

pub const SubscribeResponse = struct {
    data: []const u8,
};

pub const CancelSubscriptionResponse = struct {
    data: []const u8,
};

const std = @import("std");
const Client = @import("Client.zig");
const Result = Client.Result;
