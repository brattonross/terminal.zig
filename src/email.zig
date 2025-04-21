pub const EmailClient = struct {
    client: *Client,

    /// Subscribe to email updates from terminal.
    pub fn subscribe(self: EmailClient, request: EmailSubscribeRequest) !Result(EmailSubscribeResponse) {
        return try self.client.fetch(EmailSubscribeResponse, .POST, "/email", request);
    }
};

pub const EmailSubscribeRequest = struct {
    email: []const u8,
};

pub const EmailSubscribeResponse = struct {
    data: []const u8,
};

const std = @import("std");
const Client = @import("Client.zig");
const Result = Client.Result;
