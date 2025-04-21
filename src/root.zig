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

// card
pub const Card = @import("card.zig").Card;
pub const ListCardsResponse = @import("card.zig").ListCardsResponse;
pub const GetCardByIdResponse = @import("card.zig").GetCardByIdResponse;
pub const CreateCardRequest = @import("card.zig").CreateCardRequest;
pub const CreateCardResponse = @import("card.zig").CreateCardResponse;
pub const CollectCardResponse = @import("card.zig").CollectCardResponse;
pub const DeleteCardResponse = @import("card.zig").DeleteCardResponse;

// cart
pub const Cart = @import("cart.zig").Cart;
pub const GetCartResponse = @import("cart.zig").GetCartResponse;
pub const CartAddItemRequest = @import("./cart.zig").CartAddItemRequest;
pub const CartAddItemResponse = @import("./cart.zig").CartAddItemResponse;
pub const CartSetAddressRequest = @import("./cart.zig").CartSetAddressRequest;
pub const CartSetAddressResponse = @import("./cart.zig").CartSetAddressResponse;
pub const CartSetCardRequest = @import("./cart.zig").CartSetCardRequest;
pub const CartSetCardResponse = @import("./cart.zig").CartSetCardResponse;
pub const CartConvertToOrderResponse = @import("cart.zig").CartConvertToOrderResponse;
pub const ClearCartResponse = @import("cart.zig").ClearCartResponse;

// order
pub const Order = @import("order.zig").Order;
pub const ListOrdersResponse = @import("order.zig").ListOrdersResponse;
pub const GetOrderByIdResponse = @import("order.zig").GetOrderByIdResponse;
pub const CreateOrderRequest = @import("order.zig").CreateOrderRequest;
pub const CreateOrderResponse = @import("order.zig").CreateOrderResponse;
