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
    } else if (std.mem.eql(u8, "cart", command)) {
        const subcommand = args.next() orelse fatal("Usage: terminal cart <command>", .{});
        const cart_client = client.cart();
        if (std.mem.eql(u8, "get", subcommand)) {
            switch (try cart_client.get()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "add-item", subcommand)) {
            const json = args.next() orelse fatal("Usage: terminal cart add-item <json>", .{});
            const request = try std.json.parseFromSliceLeaky(terminal.CartAddItemRequest, allocator, json, .{});
            switch (try cart_client.addItem(request)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "set-address", subcommand)) {
            const json = args.next() orelse fatal("Usage: terminal cart set-address <json>", .{});
            const request = try std.json.parseFromSliceLeaky(terminal.CartSetAddressRequest, allocator, json, .{});
            switch (try cart_client.setAddress(request)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "set-card", subcommand)) {
            const json = args.next() orelse fatal("Usage: terminal cart set-card <json>", .{});
            const request = try std.json.parseFromSliceLeaky(terminal.CartSetCardRequest, allocator, json, .{});
            switch (try cart_client.setCard(request)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "convert", subcommand)) {
            switch (try cart_client.convertToOrder()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "clear", subcommand)) {
            switch (try cart_client.clear()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        }
    } else if (std.mem.eql(u8, "order", command)) {
        const subcommand = args.next() orelse fatal("Usage: terminal order <command>", .{});
        const order_client = client.order();
        if (std.mem.eql(u8, "list", subcommand)) {
            switch (try order_client.list()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "get", subcommand)) {
            const id = args.next() orelse fatal("Usage: terminal order get <id>", .{});
            switch (try order_client.getById(id)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "create", subcommand)) {
            const json = args.next() orelse fatal("Usage: terminal order create <json>", .{});
            const request = try std.json.parseFromSliceLeaky(terminal.CreateOrderRequest, allocator, json, .{});
            switch (try order_client.create(request)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        }
    } else if (std.mem.eql(u8, "subscription", command)) {
        const subcommand = args.next() orelse fatal("Usage: terminal subscription <command>", .{});
        const subscription_client = client.subscription();
        if (std.mem.eql(u8, "list", subcommand)) {
            switch (try subscription_client.list()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "get", subcommand)) {
            const id = args.next() orelse fatal("Usage: terminal subscription get <id>", .{});
            switch (try subscription_client.getById(id)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "update", subcommand)) {
            const id = args.next() orelse fatal("Usage: terminal subscription update <id> <json>", .{});
            const json = args.next() orelse fatal("Usage: terminal subscription update <id> <json>", .{});
            const request = try std.json.parseFromSliceLeaky(terminal.UpdateSubscriptionRequest, allocator, json, .{});
            switch (try subscription_client.update(id, request)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "subscribe", subcommand)) {
            const json = args.next() orelse fatal("Usage: terminal subscription subscribe <json>", .{});
            const request = try std.json.parseFromSliceLeaky(terminal.SubscribeRequest, allocator, json, .{});
            switch (try subscription_client.subscribe(request)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "cancel", subcommand)) {
            const id = args.next() orelse fatal("Usage: terminal subscription cancel <id>", .{});
            switch (try subscription_client.cancel(id)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        }
    } else if (std.mem.eql(u8, "token", command)) {
        const subcommand = args.next() orelse fatal("Usage: terminal token <command>", .{});
        const token_client = client.token();
        if (std.mem.eql(u8, "list", subcommand)) {
            switch (try token_client.list()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "get", subcommand)) {
            const id = args.next() orelse fatal("Usage: terminal token get <id>", .{});
            switch (try token_client.getById(id)) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "create", subcommand)) {
            switch (try token_client.create()) {
                .success => |value| try std.json.stringify(value, .{}, stdout),
                .@"error" => |value| fatal("{}", .{value}),
            }
        } else if (std.mem.eql(u8, "delete", subcommand)) {
            const id = args.next() orelse fatal("Usage: terminal token delete <id>", .{});
            switch (try token_client.delete(id)) {
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
