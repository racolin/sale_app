import 'package:flutter/foundation.dart';

import '../../data/models/product_category_model.dart';
import '../../data/models/product_option_model.dart';
import '../../data/models/product_model.dart';
import '../../exception/app_message.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {
  ProductInitial() {
    print(runtimeType);
  }
}

class ProductLoading extends ProductState {
  ProductLoading() {
    print(runtimeType);
  }
}

class ProductLoaded extends ProductState {
  final List<List<ProductModel>> _lists;
  final List<ProductCategoryModel> _listType;
  final List<ProductOptionModel> _listOption;

  List<ProductOptionModel> get listOption => _listOption;
  List<ProductCategoryModel> get listType => _listType;
  List<List<ProductModel>> get lists => _lists;

  ProductLoaded({
    List<List<ProductModel>>? lists,
    List<ProductCategoryModel>? listType,
    List<ProductOptionModel>? listOption,
  })  : _lists = lists ?? [],
        _listType = listType ?? [],
        _listOption = listOption ?? [] {
    print(runtimeType);
  }

  ProductModel? getProductById(String id) {
    for (var list in _lists) {
      var index = list.indexWhere((e) => e.id == id);
      if (index != -1) {
        return list[index];
      }
    }
    return null;
  }

  ProductOptionItemModel? getProductOptionItemById(String id) {
    for (var i in _listOption) {
      int index = i.optionItems.indexWhere((e) => e.id == id);
      if (index != -1) {
        return i.optionItems[index];
      }
    }
    return null;
  }

  ProductOptionModel? getProductOptionById(String id) {
    int index = _listOption.indexWhere((e) => e.id == id);
    if (index != -1) {
      return _listOption[index];
    }
    return null;
  }

  List<ProductModel> getSearch(String? key) {
    return _lists
        .map(
          (list) => list.where(
            (e) => e.name.contains(key ?? ''),
          ),
        )
        .expand((e) => e)
        .toList();
  }

  List<ProductModel> getProductsByCategoryId(String? type) {
    var index = _listType.indexWhere((e) => e.id == type);

    if (index == -1) {
      return [];
    }

    return _lists[0];
  }

  ProductLoaded copyWith({
    List<List<ProductModel>>? lists,
    List<ProductCategoryModel>? listType,
    List<ProductOptionModel>? listOption,
  }) {
    return ProductLoaded(
      lists: lists ?? _lists,
      listType: listType ?? _listType,
      listOption: listOption ?? _listOption,
    );
  }
}

class ProductFailure extends ProductState {
  final AppMessage message;

  ProductFailure({required this.message}) {
    print(runtimeType);
  }
}
