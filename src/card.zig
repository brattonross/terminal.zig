pub const CardClient = struct {
    client: *Client,

    pub fn list(self: CardClient) !Result(ListCardsResponse) {
        return try self.client.fetch(ListCardsResponse, .GET, "/card", .{});
    }

    pub fn getById(self: CardClient, id: []const u8) !Result(GetCardByIdResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/card/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(GetCardByIdResponse, .GET, url, .{});
    }

    pub fn create(self: CardClient, request: CreateCardRequest) !Result(CreateCardResponse) {
        return try self.client.fetch(CreateCardResponse, .POST, "/card", request);
    }

    pub fn collect(self: CardClient) !Result(CollectCardResponse) {
        return try self.client.fetch(CollectCardResponse, .POST, "/card/collect", .{});
    }

    pub fn delete(self: CardClient, id: []const u8) !Result(DeleteCardResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/card/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(DeleteCardResponse, .DELETE, url, .{});
    }
};

pub const Card = struct {
    id: []const u8,
    brand: []const u8,
    expiration: Expiration,
    last4: []const u8,
    created: []const u8,

    pub const Expiration = struct {
        month: u4,
        year: u16,
    };
};

pub const ListCardsResponse = struct {
    data: []Card,
};

pub const GetCardByIdResponse = struct {
    data: Card,
};

pub const CreateCardRequest = struct {
    token: []const u8,
};

pub const CreateCardResponse = struct {
    data: []const u8,
};

pub const CollectCardResponse = struct {
    data: Data,

    pub const Data = struct {
        url: []const u8,
    };
};

pub const DeleteCardResponse = struct {
    data: []const u8,
};

const std = @import("std");
const Client = @import("Client.zig");
const Result = Client.Result;
