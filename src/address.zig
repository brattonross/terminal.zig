pub const AddressClient = struct {
    client: *Client,

    /// Get the shipping addresses associated with the current user.
    pub fn list(self: AddressClient) !Result(ListAddressesResponse) {
        return try self.client.fetch(ListAddressesResponse, .GET, "/address", .{});
    }

    /// Get the shipping address with the given id.
    pub fn getById(self: AddressClient, id: []const u8) !Result(GetAddressByIdResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/address/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(GetAddressByIdResponse, .GET, url, .{});
    }

    /// Create and add a shipping address to the current user.
    pub fn create(self: AddressClient, request: CreateAddressRequest) !Result(CreateAddressResponse) {
        return try self.client.fetch(CreateAddressResponse, .POST, "/address", request);
    }

    /// Delete a shipping address from the current user.
    pub fn delete(self: AddressClient, id: []const u8) !Result(DeleteAddressResponse) {
        const url = try std.fmt.allocPrint(self.client.allocator, "/address/{s}", .{id});
        defer self.client.allocator.free(url);
        return try self.client.fetch(DeleteAddressResponse, .DELETE, url, .{});
    }
};

pub const Address = struct {
    id: []const u8,
    name: []const u8,
    street1: []const u8,
    street2: []const u8,
    city: []const u8,
    province: []const u8,
    country: []const u8,
    zip: []const u8,
    phone: []const u8,
    created: []const u8,
};

pub const ListAddressesResponse = struct {
    data: []Address,
};

pub const GetAddressByIdResponse = struct {
    data: Address,
};

pub const CreateAddressRequest = struct {
    name: []const u8,
    street1: []const u8,
    street2: []const u8,
    city: []const u8,
    province: []const u8,
    zip: []const u8,
    country: []const u8,
    phone: []const u8,
};

pub const CreateAddressResponse = struct {
    data: []const u8,
};

pub const DeleteAddressResponse = struct {
    data: []const u8,
};

const std = @import("std");
const Client = @import("Client.zig");
const Result = Client.Result;
