const bearer_token_key = "TERMINAL_BEARER_TOKEN";

pub fn main() !void {
    var debug_allocator = std.heap.DebugAllocator(.{}).init;
    defer std.debug.assert(debug_allocator.deinit() == .ok);

    var arena_allocator = std.heap.ArenaAllocator.init(debug_allocator.allocator());
    defer arena_allocator.deinit();

    const allocator = arena_allocator.allocator();

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
        try handleProductCommand(allocator, &client, &args);
    } else if (std.mem.eql(u8, "profile", command)) {
        try handleProfileCommand(allocator, &client, &args);
    } else if (std.mem.eql(u8, "address", command)) {
        try handleAddressCommand(allocator, &client, &args);
    } else if (std.mem.eql(u8, "card", command)) {
        try handleCardCommand(allocator, &client, &args);
    } else if (std.mem.eql(u8, "cart", command)) {
        try handleCartCommand(allocator, &client, &args);
    } else if (std.mem.eql(u8, "order", command)) {
        try handleOrderCommand(allocator, &client, &args);
    } else if (std.mem.eql(u8, "subscription", command)) {
        try handleSubscriptionCommand(allocator, &client, &args);
    } else if (std.mem.eql(u8, "token", command)) {
        try handleTokenCommand(allocator, &client, &args);
    } else if (std.mem.eql(u8, "app", command)) {
        try handleAppCommand(allocator, &client, &args);
    } else if (std.mem.eql(u8, "view", command)) {
        try handleViewCommand(allocator, &client, &args);
    } else if (std.mem.eql(u8, "email", command)) {
        try handleEmailCommand(allocator, &client, &args);
    }
}

fn handleProductCommand(_: Allocator, client: *terminal.Client, args: *ArgIterator) !void {
    const subcommand = args.next() orelse fatal("Usage: terminal product <command>", .{});
    const product_client = client.product();
    if (std.mem.eql(u8, "list", subcommand)) {
        try handleResult(terminal.ListProductsResponse, try product_client.list());
    } else if (std.mem.eql(u8, "get", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal product get <id>", .{});
        try handleResult(terminal.GetProductByIdResponse, try product_client.getById(id));
    }
}

fn handleProfileCommand(allocator: Allocator, client: *terminal.Client, args: *ArgIterator) !void {
    const subcommand = args.next() orelse fatal("Usage: terminal profile <command>", .{});
    const profile_client = client.profile();
    if (std.mem.eql(u8, "get", subcommand)) {
        try handleResult(terminal.GetProfileResponse, try profile_client.get());
    } else if (std.mem.eql(u8, "update", subcommand)) {
        const json = args.next() orelse fatal("Usage: terminal profile update <json>", .{});
        const request = try std.json.parseFromSliceLeaky(terminal.UpdateProfileRequest, allocator, json, .{});
        try handleResult(terminal.UpdateProfileResponse, try profile_client.update(request));
    }
}

fn handleAddressCommand(allocator: Allocator, client: *terminal.Client, args: *ArgIterator) !void {
    const subcommand = args.next() orelse fatal("Usage: terminal address <command>", .{});
    const address_client = client.address();
    if (std.mem.eql(u8, "list", subcommand)) {
        try handleResult(terminal.ListAddressesResponse, try address_client.list());
    } else if (std.mem.eql(u8, "get", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal address get <id>", .{});
        try handleResult(terminal.GetAddressByIdResponse, try address_client.getById(id));
    } else if (std.mem.eql(u8, "create", subcommand)) {
        const json = args.next() orelse fatal("Usage: terminal address create <json>", .{});
        const request = try std.json.parseFromSliceLeaky(terminal.CreateAddressRequest, allocator, json, .{});
        try handleResult(terminal.CreateAddressResponse, try address_client.create(request));
    } else if (std.mem.eql(u8, "delete", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal address delete <id>", .{});
        try handleResult(terminal.DeleteAddressResponse, try address_client.delete(id));
    }
}

fn handleCardCommand(allocator: Allocator, client: *terminal.Client, args: *ArgIterator) !void {
    const subcommand = args.next() orelse fatal("Usage: terminal card <command>", .{});
    const card_client = client.card();
    if (std.mem.eql(u8, "list", subcommand)) {
        try handleResult(terminal.ListCardsResponse, try card_client.list());
    } else if (std.mem.eql(u8, "get", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal card get <id>", .{});
        try handleResult(terminal.GetCardByIdResponse, try card_client.getById(id));
    } else if (std.mem.eql(u8, "create", subcommand)) {
        const json = args.next() orelse fatal("Usage: terminal card create <json>", .{});
        const request = try std.json.parseFromSliceLeaky(terminal.CreateCardRequest, allocator, json, .{});
        try handleResult(terminal.CreateCardResponse, try card_client.create(request));
    } else if (std.mem.eql(u8, "collect", subcommand)) {
        try handleResult(terminal.CollectCardResponse, try card_client.collect());
    } else if (std.mem.eql(u8, "collect", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal card delete <id>", .{});
        try handleResult(terminal.DeleteCardResponse, try card_client.delete(id));
    }
}

fn handleCartCommand(allocator: Allocator, client: *terminal.Client, args: *ArgIterator) !void {
    const subcommand = args.next() orelse fatal("Usage: terminal cart <command>", .{});
    const cart_client = client.cart();
    if (std.mem.eql(u8, "get", subcommand)) {
        try handleResult(terminal.GetCartResponse, try cart_client.get());
    } else if (std.mem.eql(u8, "add-item", subcommand)) {
        const json = args.next() orelse fatal("Usage: terminal cart add-item <json>", .{});
        const request = try std.json.parseFromSliceLeaky(terminal.CartAddItemRequest, allocator, json, .{});
        try handleResult(terminal.CartAddItemResponse, try cart_client.addItem(request));
    } else if (std.mem.eql(u8, "set-address", subcommand)) {
        const json = args.next() orelse fatal("Usage: terminal cart set-address <json>", .{});
        const request = try std.json.parseFromSliceLeaky(terminal.CartSetAddressRequest, allocator, json, .{});
        try handleResult(terminal.CartSetAddressResponse, try cart_client.setAddress(request));
    } else if (std.mem.eql(u8, "set-card", subcommand)) {
        const json = args.next() orelse fatal("Usage: terminal cart set-card <json>", .{});
        const request = try std.json.parseFromSliceLeaky(terminal.CartSetCardRequest, allocator, json, .{});
        try handleResult(terminal.CartSetCardResponse, try cart_client.setCard(request));
    } else if (std.mem.eql(u8, "convert", subcommand)) {
        try handleResult(terminal.CartConvertToOrderResponse, try cart_client.convertToOrder());
    } else if (std.mem.eql(u8, "clear", subcommand)) {
        try handleResult(terminal.ClearCartResponse, try cart_client.clear());
    }
}

fn handleOrderCommand(allocator: Allocator, client: *terminal.Client, args: *ArgIterator) !void {
    const subcommand = args.next() orelse fatal("Usage: terminal order <command>", .{});
    const order_client = client.order();
    if (std.mem.eql(u8, "list", subcommand)) {
        try handleResult(terminal.ListOrdersResponse, try order_client.list());
    } else if (std.mem.eql(u8, "get", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal order get <id>", .{});
        try handleResult(terminal.GetOrderByIdResponse, try order_client.getById(id));
    } else if (std.mem.eql(u8, "create", subcommand)) {
        const json = args.next() orelse fatal("Usage: terminal order create <json>", .{});
        const request = try std.json.parseFromSliceLeaky(terminal.CreateOrderRequest, allocator, json, .{});
        try handleResult(terminal.CreateOrderResponse, try order_client.create(request));
    }
}

fn handleSubscriptionCommand(allocator: Allocator, client: *terminal.Client, args: *ArgIterator) !void {
    const subcommand = args.next() orelse fatal("Usage: terminal subscription <command>", .{});
    const subscription_client = client.subscription();
    if (std.mem.eql(u8, "list", subcommand)) {
        try handleResult(terminal.ListSubscriptionsResponse, try subscription_client.list());
    } else if (std.mem.eql(u8, "get", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal subscription get <id>", .{});
        try handleResult(terminal.GetSubscriptionByIdResponse, try subscription_client.getById(id));
    } else if (std.mem.eql(u8, "update", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal subscription update <id> <json>", .{});
        const json = args.next() orelse fatal("Usage: terminal subscription update <id> <json>", .{});
        const request = try std.json.parseFromSliceLeaky(terminal.UpdateSubscriptionRequest, allocator, json, .{});
        try handleResult(terminal.UpdateSubscriptionResponse, try subscription_client.update(id, request));
    } else if (std.mem.eql(u8, "subscribe", subcommand)) {
        const json = args.next() orelse fatal("Usage: terminal subscription subscribe <json>", .{});
        const request = try std.json.parseFromSliceLeaky(terminal.SubscribeRequest, allocator, json, .{});
        try handleResult(terminal.SubscribeResponse, try subscription_client.subscribe(request));
    } else if (std.mem.eql(u8, "cancel", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal subscription cancel <id>", .{});
        try handleResult(terminal.CancelSubscriptionResponse, try subscription_client.cancel(id));
    }
}

fn handleTokenCommand(_: Allocator, client: *terminal.Client, args: *ArgIterator) !void {
    const subcommand = args.next() orelse fatal("Usage: terminal token <command>", .{});
    const token_client = client.token();
    if (std.mem.eql(u8, "list", subcommand)) {
        try handleResult(terminal.ListTokensResponse, try token_client.list());
    } else if (std.mem.eql(u8, "get", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal token get <id>", .{});
        try handleResult(terminal.GetTokenByIdResponse, try token_client.getById(id));
    } else if (std.mem.eql(u8, "create", subcommand)) {
        try handleResult(terminal.CreateTokenResponse, try token_client.create());
    } else if (std.mem.eql(u8, "delete", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal token delete <id>", .{});
        try handleResult(terminal.DeleteTokenResponse, try token_client.delete(id));
    }
}

fn handleAppCommand(allocator: Allocator, client: *terminal.Client, args: *ArgIterator) !void {
    const subcommand = args.next() orelse fatal("Usage: terminal app <command>", .{});
    const app_client = client.app();
    if (std.mem.eql(u8, "list", subcommand)) {
        try handleResult(terminal.ListAppsResponse, try app_client.list());
    } else if (std.mem.eql(u8, "get", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal app get <id>", .{});
        try handleResult(terminal.GetAppByIdResponse, try app_client.getById(id));
    } else if (std.mem.eql(u8, "create", subcommand)) {
        const json = args.next() orelse fatal("Usage: terminal app create <json>", .{});
        const request = try std.json.parseFromSliceLeaky(terminal.CreateAppRequest, allocator, json, .{});
        try handleResult(terminal.CreateAppResponse, try app_client.create(request));
    } else if (std.mem.eql(u8, "delete", subcommand)) {
        const id = args.next() orelse fatal("Usage: terminal app delete <id>", .{});
        try handleResult(terminal.DeleteAppResponse, try app_client.delete(id));
    }
}

fn handleViewCommand(_: Allocator, client: *terminal.Client, args: *ArgIterator) !void {
    const subcommand = args.next() orelse fatal("Usage: terminal view <command>", .{});
    const view_client = client.view();
    if (std.mem.eql(u8, "init", subcommand)) {
        try handleResult(terminal.InitViewResponse, try view_client.init());
    }
}

fn handleEmailCommand(allocator: Allocator, client: *terminal.Client, args: *ArgIterator) !void {
    const subcommand = args.next() orelse fatal("Usage: terminal email <command>", .{});
    const email_client = client.email();
    if (std.mem.eql(u8, "subscribe", subcommand)) {
        const json = args.next() orelse fatal("Usage: terminal email subscribe <json>", .{});
        const request = try std.json.parseFromSliceLeaky(terminal.EmailSubscribeRequest, allocator, json, .{});
        try handleResult(terminal.EmailSubscribeResponse, try email_client.subscribe(request));
    }
}

fn handleResult(comptime T: type, result: Result(T)) !void {
    const stdout = std.io.getStdOut().writer();
    switch (result) {
        .success => |value| try std.json.stringify(value, .{}, stdout),
        .@"error" => |value| fatal("{}", .{value}),
    }
}

fn fatal(comptime fmt: []const u8, args: anytype) noreturn {
    std.io.getStdErr().writer().print(fmt, args) catch @panic("failed to write to stderr");
    std.process.exit(1);
}

const std = @import("std");
const Allocator = std.mem.Allocator;
const ArgIterator = std.process.ArgIterator;
const terminal = @import("terminal");
const Result = terminal.Client.Result;
