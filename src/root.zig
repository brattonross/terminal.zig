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

// address
pub const Address = @import("address.zig").Address;
pub const ListAddressesResponse = @import("address.zig").ListAddressesResponse;
pub const GetAddressByIdResponse = @import("address.zig").GetAddressByIdResponse;
pub const CreateAddressRequest = @import("address.zig").CreateAddressRequest;
pub const CreateAddressResponse = @import("address.zig").CreateAddressResponse;
pub const DeleteAddressResponse = @import("address.zig").DeleteAddressResponse;
