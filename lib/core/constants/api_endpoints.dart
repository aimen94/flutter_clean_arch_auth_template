class ApiEndpoints {
  ApiEndpoints._();

  static const String login = "https://dummyjson.com/auth/login";
  static const String register = "https://dummyjson.com/users/add";
  static const String getProfile = "https://dummyjson.com/auth/me";
  static const String refreshToken = "https://dummyjson.com/auth/refresh";
  static const String updateProfile = "https://dummyjson.com/users/";
  static const String products = "https://dummyjson.com/products";
  static const String categories = "https://dummyjson.com/products/categories";
  static const String categoryProducts =
      "https://dummyjson.com/products/category";
  static const String searchProducts = "https://dummyjson.com/products/search";
  static const String allCategories =
      'https://dummyjson.com/products/category-list';
  //static String searchProducts(String query) => "https://dummyjson.com/products?q=$query";
}

class AppStrings {
  static const String networkError = 'No internet connection';
  static const String serverError = 'Server error occurred';
  static const String unauthorized = 'Unauthorized access';
  static const String sessionExpired = 'Session expired, please login again';
  static const String unknownError = 'Unknown error occurred';
  static const String timeoutError = 'Request timeout';
  static const String badRequest = 'Bad request';
  static const String notFound = 'Resource not found';
}
