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

// subscription
pub const Subscription = @import("subscription.zig").Subscription;
pub const ListSubscriptionsResponse = @import("subscription.zig").ListSubscriptionsResponse;
pub const GetSubscriptionByIdResponse = @import("subscription.zig").GetSubscriptionByIdResponse;
pub const UpdateSubscriptionRequest = @import("subscription.zig").UpdateSubscriptionRequest;
pub const UpdateSubscriptionResponse = @import("subscription.zig").UpdateSubscriptionResponse;
pub const SubscribeRequest = @import("subscription.zig").SubscribeRequest;
pub const SubscribeResponse = @import("subscription.zig").SubscribeResponse;
pub const CancelSubscriptionResponse = @import("subscription.zig").CancelSubscriptionResponse;

// token
pub const Token = @import("token.zig").Token;
pub const ListTokensResponse = @import("token.zig").ListTokensResponse;
pub const GetTokenByIdResponse = @import("token.zig").GetTokenByIdResponse;
pub const CreateTokenResponse = @import("token.zig").CreateTokenResponse;
pub const DeleteTokenResponse = @import("token.zig").DeleteTokenResponse;

// app
pub const App = @import("app.zig").App;
pub const ListAppsResponse = @import("app.zig").ListAppsResponse;
pub const GetAppByIdResponse = @import("app.zig").GetAppByIdResponse;
pub const CreateAppRequest = @import("app.zig").CreateAppRequest;
pub const CreateAppResponse = @import("app.zig").CreateAppResponse;
pub const DeleteAppResponse = @import("app.zig").DeleteAppResponse;

// view
pub const InitViewResponse = @import("view.zig").InitViewResponse;

// email
pub const EmailSubscribeRequest = @import("email.zig").EmailSubscribeRequest;
pub const EmailSubscribeResponse = @import("email.zig").EmailSubscribeResponse;
