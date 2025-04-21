pub const AppClient = struct {
    client: *Client,

    pub fn list(self: AppClient) !Result(ListAppsResponse) {
        return try self.client.fetch(ListAppsResponse, .GET, "/app", .{});
    }

    pub fn getById(self: AppClient, id: []const u8) !Result(GetAppByIdResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/app/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(GetAppByIdResponse, .GET, url, .{});
    }

    pub fn create(self: AppClient, request: CreateAppRequest) !Result(CreateAppResponse) {
        return try self.client.fetch(CreateAppResponse, .POST, "/app", request);
    }

    pub fn delete(self: AppClient, id: []const u8) !Result(DeleteAppResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/app/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(DeleteAppResponse, .DELETE, url, .{});
    }
};

pub const App = struct {
    id: []const u8,
    secret: []const u8,
    name: []const u8,
    redirectURI: []const u8,
};

pub const ListAppsResponse = struct {
    data: []App,
};

pub const GetAppByIdResponse = struct {
    data: App,
};

pub const CreateAppRequest = struct {
    name: []const u8,
    redirectURI: []const u8,
};

pub const CreateAppResponse = struct {
    data: Data,

    pub const Data = struct {
        id: []const u8,
        secret: []const u8,
    };
};

pub const DeleteAppResponse = struct {
    data: []const u8,
};

const std = @import("std");
const Client = @import("Client.zig");
const Result = Client.Result;
