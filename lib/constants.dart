// ignore: todo
// TODO: REMOVE API KEY BEFORE COMMITING TO GITHUB!
// API key for backend server.
const _API_KEY = 'ADD_API_KEY_HERE';

// ignore: todo
// TODO: REMOVE ENDPOINT URL BEFORE COMMITING TO GITHUB!
const _ENDPOINT_URL = 'ADD_ENDPOINT_URL_HERE';

// Fetch all products URL.
String allProductsUrl({String token}) =>
    '$_ENDPOINT_URL/products.json?auth=$token';

// Fetch product with id URL.
String productWithIdUrl({String token, String productId}) =>
    '$_ENDPOINT_URL/products/$productId.json?auth=$token';

// Fetch URL that filters products by currently logged in user.
String productFilterByUserUrl(
    {String token, String userId, bool filterByUser}) {
  if (filterByUser) {
    return '$_ENDPOINT_URL/products.json?auth=$token&orderBy="creatorId"&equalTo="$userId"';
  }

  return '$_ENDPOINT_URL/products.json?auth=$token';
}

// Fetch orders URL.
String ordersUrl({String token, String userId}) =>
    '$_ENDPOINT_URL/orders/$userId.json?auth=$token';

// Fetch user favorites URL.
String userFavoritesUrl({String token, String userId, String productsId}) {
  if (productsId != null) {
    return '$_ENDPOINT_URL/userFavorites/$userId/$productsId.json?auth=$token';
  }

  return '$_ENDPOINT_URL/userFavorites/$userId.json?auth=$token';
}

// Fetch authentication URL.
String fetchAuthUrl(String withSegmentUrl) =>
    'https://identitytoolkit.googleapis.com/v1/accounts:$withSegmentUrl?key=$_API_KEY';
