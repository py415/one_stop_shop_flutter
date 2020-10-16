class Constants {
  // ignore: todo
  // TODO: REMOVE HTTP ENDPOINT URL BEFORE COMMITING TO GITHUB!
  // Http endpoint url to backend database for list of products.
  static final productsUrl = 'ADD_ENDPOINT_URL_HERE';

  // ignore: todo
  // TODO: REMOVE HTTP ENDPOINT URL BEFORE COMMITING TO GITHUB!
  // Http endpoint url to backend database for list of products.
  static final ordersUrl = 'ADD_ENDPOINT_URL_HERE';

  // ignore: todo
  // TODO: REMOVE HTTP ENDPOINT URL BEFORE COMMITING TO GITHUB!
  // Http endpoint url to backend database for specific product.
  static final productUrl = 'ADD_ENDPOINT_URL_HERE';

  static String fetchProduct(String withId) {
    return productUrl + '$withId.json';
  }
}
