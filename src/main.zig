const bearer_token_key = "TERMINAL_BEARER_TOKEN";

pub fn main() !void {
    var debug_allocator = std.heap.DebugAllocator(.{}).init;
    defer std.debug.assert(debug_allocator.deinit() == .ok);

    var arena_allocator = std.heap.ArenaAllocator.init(debug_allocator.allocator());
    defer arena_allocator.deinit();

    const allocator = arena_allocator.allocator();

    const stdout = std.io.getStdOut().writer();

    var args = try std.process.argsWithAllocator(allocator);
    _ = args.next();

    const command = args.next() orelse fatal("Usage: terminal <command>", .{});

    const bearer_token = std.process.getEnvVarOwned(allocator, bearer_token_key) catch |err| switch (err) {
        error.EnvironmentVariableNotFound => fatal("Missing required environment variable: {s}", .{bearer_token_key}),
        else => fatal("Failed to get bearer token environment variable: {}", .{err}),
    };
    var client = terminal.Client.init(.{
        .allocator = allocator,
        .base_uri = std.Uri.parse("https://api.dev.terminal.shop") catch unreachable,
        .bearer_token = bearer_token,
    });

    if (std.mem.eql(u8, "product", command)) {
        const subcommand = args.next() orelse fatal("Usage: terminal product <command>", .{});
        const product_client = client.product();
        if (std.mem.eql(u8, "list", subcommand)) {
            switch (try product_client.list()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "get", subcommand)) {
            const id = args.next() orelse fatal("Usage: terminal product get <id>", .{});
            switch (try product_client.getById(id)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        }
    } else if (std.mem.eql(u8, "profile", command)) {
        const subcommand = args.next() orelse fatal("Usage: terminal profile <command>", .{});
        const profile_client = client.profile();
        if (std.mem.eql(u8, "get", subcommand)) {
            switch (try profile_client.get()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "update", subcommand)) {
            const json = args.next() orelse fatal("Usage: terminal profile update <json>", .{});
            const request = try std.json.parseFromSliceLeaky(terminal.UpdateProfileRequest, allocator, json, .{});
            switch (try profile_client.update(request)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        }
    } else if (std.mem.eql(u8, "address", command)) {
        const subcommand = args.next() orelse fatal("Usage: terminal address <command>", .{});
        const address_client = client.address();
        if (std.mem.eql(u8, "list", subcommand)) {
            switch (try address_client.list()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "get", subcommand)) {
            const id = args.next() orelse fatal("Usage: terminal address get <id>", .{});
            switch (try address_client.getById(id)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "create", subcommand)) {
            const json = args.next() orelse fatal("Usage: terminal address create <json>", .{});
            const request = try std.json.parseFromSliceLeaky(terminal.CreateAddressRequest, allocator, json, .{});
            switch (try address_client.create(request)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "delete", subcommand)) {
            const id = args.next() orelse fatal("Usage: terminal address delete <id>", .{});
            switch (try address_client.delete(id)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        }
    } else if (std.mem.eql(u8, "card", command)) {
        const subcommand = args.next() orelse fatal("Usage: terminal card <command>", .{});
        const card_client = client.card();
        if (std.mem.eql(u8, "list", subcommand)) {
            switch (try card_client.list()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "get", subcommand)) {
            const id = args.next() orelse fatal("Usage: terminal card get <id>", .{});
            switch (try card_client.getById(id)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "create", subcommand)) {
            const json = args.next() orelse fatal("Usage: terminal card create <json>", .{});
            const request = try std.json.parseFromSliceLeaky(terminal.CreateCardRequest, allocator, json, .{});
            switch (try card_client.create(request)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "collect", subcommand)) {
            switch (try card_client.collect()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "collect", subcommand)) {
            const id = args.next() orelse fatal("Usage: terminal card delete <id>", .{});
            switch (try card_client.delete(id)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        }
    }
}

fn fatal(comptime fmt: []const u8, args: anytype) noreturn {
    std.io.getStdErr().writer().print(fmt, args) catch @panic("failed to write to stderr");
    std.process.exit(1);
}

const std = @import("std");
const terminal = @import("terminal");
const Result = terminal.Client.Result;
