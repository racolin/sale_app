import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/data/models/product_model.dart';
import 'package:sale_app/data/models/response_model.dart';

import '../../business_logic/repositories/product_repository.dart';
import '../../business_logic/states/product_state.dart';
import '../../data/models/product_option_model.dart';
import '../../exception/app_message.dart';
import '../blocs/interval/interval_submit.dart';

class ProductCubit extends Cubit<ProductState>
    implements IntervalSubmit<ProductModel> {
  final ProductRepository _repository;

  ProductCubit({
    required ProductRepository repository,
  })  : _repository = repository,
        super(ProductInitial()) {
    _init();
  }

  void _init() async {
    emit(ProductLoading());
    var resOption = await _repository.getOptions();
    if (resOption.type == ResponseModelType.failure) {
      return emit(ProductFailure(message: resOption.message));
    }
    var options = resOption.data;

    var resCategories = await _repository.getCategories();
    if (resCategories.type == ResponseModelType.failure) {
      return emit(ProductFailure(message: resCategories.message));
    }
    var categories = resCategories.data;

    List<List<ProductModel>> lists = [];
    for (var category in categories) {
      var resList = await _repository.gets(categoryId: category.id);
      if (resList.type == ResponseModelType.failure) {
        return emit(ProductFailure(message: resList.message));
      }
      lists.add(resList.data);
    }

    emit(ProductLoaded(
      lists: lists,
      listOption: options,
      listType: categories,
    ));
  }

  Future<AppMessage?> reloadData() async {
    var resListOption = await _repository.getOptions();
    var resList = await _repository.gets();
    var resListType = await _repository.getCategories();
    if (resList.type == ResponseModelType.success) {
      var listOption = resListOption.type == ResponseModelType.success
          ? resListOption.data
          : null;
      var listType = resListType.type == ResponseModelType.success
          ? resListType.data
          : null;
      emit(ProductLoaded(
        lists: [],
        listOption: listOption,
        listType: listType,
      ));
    } else {}
    return null;
  }

  @override
  Future<List<ProductModel>> submit([String? key]) async {
    if (state is ProductLoaded) {
      return (state as ProductLoaded).getSearch(key);
    }
    return <ProductModel>[];
  }

  List<List<ProductModel>> get lists {
    if (this.state is! ProductLoaded) {
      return [];
    }
    var state = this.state as ProductLoaded;
    return state.lists;
  }

  List<ProductOptionModel> get listOption {
    if (this.state is! ProductLoaded) {
      return [];
    }
    var state = this.state as ProductLoaded;
    return state.listOption;
  }

  List<ProductModel> getSearch(String? key) {
    if (this.state is! ProductLoaded) {
      return [];
    }
    var state = this.state as ProductLoaded;
    return state.getSearch(key);
  }

  List<ProductModel> getProductsByCategoryId(String categoryId) {
      return [];
  }

  ProductModel? getProductById(String id) {
    if (this.state is! ProductLoaded) {
      return null;
    }
    var state = this.state as ProductLoaded;
    return state.getProductById(id);
  }

  ProductOptionItemModel? getProductOptionItemById(String id) {
    if (this.state is! ProductLoaded) {
      return null;
    }
    var state = this.state as ProductLoaded;
    return state.getProductOptionItemById(id);
  }

  int? getCostDefaultOptions(List<String> options) {
    if (this.state is! ProductLoaded) {
      return null;
    }
    var state = this.state as ProductLoaded;
    int result = 0;
    for (var id in options) {
      var model = state.getProductOptionById(id);
      if (model != null) {
        for (var itemDefault in model.defaultSelect) {
          var index = model.optionItems.indexWhere((e) => e.id == itemDefault);
          if (index != -1) {
            result += model.optionItems[index].cost;
          }
        }
      }
    }
    return result;
  }

  ProductOptionModel? getProductOptionById(String id) {
    if (this.state is! ProductLoaded) {
      return null;
    }
    var state = this.state as ProductLoaded;
    return state.getProductOptionById(id);
  }

  int? getCostOptionsItem(String productId, List<String> items) {
    if (this.state is! ProductLoaded) {
      return null;
    }
    var state = this.state as ProductLoaded;
    return state.getCostOptionsItem(productId, items);
  }
}
