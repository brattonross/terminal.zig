pub const Order = struct {
    id: []const u8,
    index: ?u32 = null,
    shipping: Shipping,
    created: []const u8,
    amount: Amount,
    tracking: Tracking,
    items: []Item,

    pub const Shipping = struct {
        name: []const u8,
        street1: []const u8,
        street2: ?[]const u8 = null,
        city: []const u8,
        province: ?[]const u8 = null,
        country: []const u8,
        zip: []const u8,
        phone: ?[]const u8 = null,
    };

    pub const Amount = struct {
        shipping: u32,
        subtotal: u32,
    };

    pub const Tracking = struct {
        service: []const u8,
        number: []const u8,
        url: []const u8,
        status: []const u8,
        statusDetails: []const u8,
        statusUpdatedAt: []const u8,
    };

    pub const Item = struct {
        id: []const u8,
        description: ?[]const u8 = null,
        amount: u32,
        quantity: u32,
        productVariantID: ?[]const u8 = null,
    };
};
