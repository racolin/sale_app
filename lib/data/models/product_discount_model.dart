import 'package:sale_app/data/models/pos_model.dart';
import 'package:sale_app/presentation/res/strings/values.dart';

class ProductDiscountModel {
  final String id;
  final int cost;
  final int discount;

  const ProductDiscountModel({
    required this.id,
    required this.cost,
    required this.discount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cost': cost,
      'discount': discount,
    };
  }

  factory ProductDiscountModel.fromMap(Map<String, dynamic> map) {
    return ProductDiscountModel(
      id: map['id'] as String,
      cost: map['cost'] as int,
      discount: map['discount'] as int,
    );
  }
}
