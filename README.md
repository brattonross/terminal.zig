# terminal.zig

A client library and CLI for [terminal.shop](https://terminal.shop/api)

## Usage

```zig
const terminal = @import("terminal");

var client = terminal.Client.init(.{
    .allocator = allocator, // this should be a `std.heap.ArenaAllocator` or similar
    .bearer_token = terminal_bearer_token,
});

const product_client = client.product();
const result = try product_client.list();

switch (result) {
    .success => |products| std.debug.print("Success: {}\n", .{products}),
    .@"error" => |err| std.debug.print("Error: {}\n", .{err}),
}
```

> [!IMPORTANT]
> Currently the client assumes use of an arena allocator.
> API response structs are parsed using `std.json.parseFromSliceLeaky` and so can't be freed without use of an arena.

## Making custom requests

The `Client` struct exposes a `fetch` function which can be used to make requests for any custom or undocumented endpoints:

```zig
try client.fetch(MyResponseType, .GET, "/example/path", .{});
```

## CLI

The CLI will call the API, parse the response, and then json stringify the data to stdout/stderr as appropriate. This is more of a testing tool than a feature.
