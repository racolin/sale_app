import 'dart:io';

class Environment {
  final String _base;
  final String _url;

  Environment._({
    required String base,
    required String url,
  })  : _base = base,
        _url = url;

  String get api => _url + _base;

  static Environment? _devInstance;

  factory Environment.env() {
    return _dev;
  }

  static Environment get _dev {
    _devInstance ??= Environment._(
      base: 'api/v2/',
      // url: 'http://127.0.0.1/',
      url: Platform.isAndroid ? 'http://10.0.2.2/' : 'http://127.0.0.1/',
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
  static const String authLogin = 'sale/auth/login';
  static const String authRefresh = 'sale/auth/refresh';

  // Product
  static String productAll(String id) => 'sale/product/$id';
  static const String productCategoryAll = 'sale/category';
  static const String productOptionAll = 'sale/product-option';

  // Cart
  static const String cartStatus = 'sale/cart-status';
  static const String cartEditStatus = 'sale/cart/status';

  static String cartGetStates(String id) => 'sale/cart-status/$id';

  static String cartsByState(String id) => 'sale/cart-status/$id';
  static String getDetailCard(String id) => 'sale/cart/$id';

  // Order
  static const String cartCreate = 'sale/cart/create';

  // Employee
  static const String getEmployees = 'sale/employee';

  // Voucher
  static const String checkVoucher = 'sale/cart/check-voucher';
  static const String suggestVoucher = 'sale/cart/suggest-voucher';
  static const String getAvailableVoucher = 'sale/voucher/available';

  // member
  static const String searchMember = 'sale/member/search';
}
