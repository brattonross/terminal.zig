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
            var name: ?[]const u8 = null;
            var email: ?[]const u8 = null;
            while (args.next()) |arg| {
                if (std.mem.eql(u8, "--email", arg)) {
                    email = args.next() orelse fatal("Missing value for flag --email", .{});
                } else if (std.mem.eql(u8, "--name", arg)) {
                    name = args.next() orelse fatal("Missing value for flag --name", .{});
                } else fatal("Unknown argument: {s}", .{arg});
            }
            const request = terminal.UpdateProfileRequest{
                .name = name orelse fatal("Missing required parameter: name", .{}),
                .email = email orelse fatal("Missing required parameter: email", .{}),
            };
            switch (try profile_client.update(request)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        }
    }
}

fn fatal(comptime fmt: []const u8, args: anytype) noreturn {
    std.log.err(fmt, args);
    std.process.exit(1);
}

const std = @import("std");
const terminal = @import("terminal");
const Result = terminal.Client.Result;
