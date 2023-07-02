class Environment {
  final String _base;
  final String _url;

  Environment._({
    required String base,
    required String url,
  })  : _base = base,
        _url = url
  ;

  String get api => _url + _base;

  static Environment? _devInstance;

  factory Environment.env() {
    return _dev;
  }

  static Environment get _dev {
    _devInstance ??= Environment._(
      base: 'api/v1/',
      url: 'http://127.0.0.1/',
    );
    return _devInstance!;
  }
}

// Config environment
class AppConfig {
  factory AppConfig({Environment? env}) {
    if (env != null) {
      appConfig.env = env;
    }
    return appConfig;
  }

  AppConfig._private();

  static final AppConfig appConfig = AppConfig._private();
  Environment env = Environment.env();
}

class ApiRouter {
  // Auth
  static const String authLogin = '/sale/auth/login';
  static const String authRefresh = '/sale/auth/refresh';

  // Product
  static String productAll(String id) => '/sale/product/$id';
  static const String productCategoryAll = '/sale/category';
  static const String productOptionAll = '/sale/product-option';

  // Cart
  static const String cartStatusAll = '/cart-status';
  static String cartGetStates(String id) => '/sale/cart-status/$id';
  static String cartsByState(String id) => '/sale/cart-status/$id';

  // Order
  static const String cartCreate = '/sale/cart/create';
}
