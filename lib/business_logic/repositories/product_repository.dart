import 'package:sale_app/data/models/check_voucher_model.dart';
import 'package:sale_app/data/models/product_option_model.dart';
import 'package:sale_app/data/models/product_suggets_model.dart';
import 'package:sale_app/data/models/voucher_model.dart';

import '../../data/models/product_model.dart';
import '../../data/models/product_category_model.dart';
import '../../data/models/response_model.dart';

abstract class ProductRepository {
  Future<ResponseModel<List<ProductModel>>> gets({String? categoryId});

  Future<ResponseModel<List<ProductCategoryModel>>> getCategories();

  Future<ResponseModel<List<ProductOptionModel>>> getOptions();

  ///
  /// Gửi nếu là guest1, không gửi nếu là guest2
  ///
  Future<ResponseModel<List<VoucherModel>>> getAvailableVoucher({
    String? userId,
  });

  Future<ResponseModel<List<CheckVoucherModel>>> getSuggestVoucher({
    String? userId,
    required List<ProductSuggestModel> products,
  });

  Future<ResponseModel<List<CheckVoucherModel>>> checkVoucher({
    String? userId,
    required String voucherId,
    required List<ProductSuggestModel> products,
  });
}
