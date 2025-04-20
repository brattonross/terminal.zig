pub const Client = @import("Client.zig");

// product
pub const Product = @import("product.zig").Product;
pub const ListProductsResponse = @import("product.zig").ListProductsResponse;
pub const GetProductByIdResponse = @import("product.zig").GetProductByIdResponse;

// profile
pub const Profile = @import("profile.zig").Profile;
pub const GetProfileResponse = @import("profile.zig").GetProfileResponse;
pub const UpdateProfileRequest = @import("profile.zig").UpdateProfileRequest;
pub const UpdateProfileResponse = @import("profile.zig").UpdateProfileResponse;
