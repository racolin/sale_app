import 'package:sale_app/data/models/product_option_model.dart';

import '../../data/models/product_model.dart';
import '../../data/models/product_category_model.dart';
import '../../data/models/response_model.dart';

abstract class ProductRepository {

  Future<ResponseModel<List<ProductModel>>> gets({String? categoryId});

  Future<ResponseModel<List<ProductCategoryModel>>> getCategories();

  Future<ResponseModel<List<ProductOptionModel>>> getOptions();
}
