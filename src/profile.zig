pub const ProfileClient = struct {
    client: *Client,

    pub fn get(self: ProfileClient) !Result(GetProfileResponse) {
        return try self.client.fetch(GetProfileResponse, .GET, "/profile", .{});
    }

    pub fn update(self: ProfileClient, request: UpdateProfileRequest) !Result(UpdateProfileResponse) {
        return try self.client.fetch(UpdateProfileResponse, .PUT, "/profile", request);
    }
};

pub const Profile = struct {
    user: User,

    pub const User = struct {
        id: []const u8,
        name: ?[]const u8 = null,
        email: ?[]const u8 = null,
        fingerprint: ?[]const u8 = null,
        stripeCustomerID: []const u8,
    };
};

pub const GetProfileResponse = struct {
    data: Profile,
};

pub const UpdateProfileRequest = struct {
    name: []const u8,
    email: []const u8,
};

pub const UpdateProfileResponse = struct {
    data: Profile,
};

const Client = @import("Client.zig");
const Result = Client.Result;
