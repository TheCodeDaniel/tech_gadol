class AppRoutes {
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String showcase = '/showcase';

  static String productById(int id) => '/products/$id';
}
