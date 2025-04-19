pub fn main() !void {
    var debug_allocator = std.heap.DebugAllocator(.{}).init;
    defer std.debug.assert(debug_allocator.deinit() == .ok);

    var arena_allocator = std.heap.ArenaAllocator.init(debug_allocator.allocator());
    defer arena_allocator.deinit();

    var client = terminal.Client.init(.{
        .allocator = arena_allocator.allocator(),
        .base_uri = std.Uri.parse("https://api.dev.terminal.shop") catch unreachable,
    });
    const products_client = client.products();

    const first_product = switch (try products_client.list()) {
        .success => |products| blk: {
            std.debug.print("there are {d} products\n", .{products.data.len});
            for (products.data) |product| {
                std.debug.print("\t{s}\n", .{product.id});
            }
            break :blk products.data[0];
        },
        .@"error" => |err| {
            std.debug.print("failed to fetch products: {}\n", .{err});
            std.process.exit(1);
        },
    };
    switch (try products_client.getById(first_product.id)) {
        .success => |product| {
            std.debug.print("{}\n", .{product});
        },
        .@"error" => |err| {
            std.debug.print("failed to fetch product: {}\n", .{err});
            std.process.exit(1);
        },
    }
}

const std = @import("std");
const terminal = @import("terminal");
