pub const TokenClient = struct {
    client: *Client,

    /// List the current user's personal access tokens.
    pub fn list(self: TokenClient) !Result(ListTokensResponse) {
        return try self.client.fetch(ListTokensResponse, .GET, "/token", .{});
    }

    /// Get the personal access token with the given id.
    pub fn getById(self: TokenClient, id: []const u8) !Result(GetTokenByIdResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/token/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(GetTokenByIdResponse, .GET, url, .{});
    }

    /// Create a personal access token.
    pub fn create(self: TokenClient) !Result(CreateTokenResponse) {
        return try self.client.fetch(CreateTokenResponse, .POST, "/token", .{});
    }

    /// Delete the personal access token with the given id.
    pub fn delete(self: TokenClient, id: []const u8) !Result(DeleteTokenResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/token/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(DeleteTokenResponse, .DELETE, url, .{});
    }
};

pub const Token = struct {
    id: []const u8,
    token: []const u8,
    created: []const u8,
};

pub const ListTokensResponse = struct {
    data: []Token,
};

pub const GetTokenByIdResponse = struct {
    data: Token,
};

pub const CreateTokenResponse = struct {
    data: Data,

    pub const Data = struct {
        id: []const u8,
        token: []const u8,
    };
};

pub const DeleteTokenResponse = struct {
    data: []const u8,
};

const std = @import("std");
const Client = @import("Client.zig");
const Result = Client.Result;
