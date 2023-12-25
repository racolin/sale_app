import 'package:sale_app/data/models/product_discount_model.dart';

class CheckVoucherModel {
  final String? voucherId;
  final int cost;
  final String voucherDiscount;
  final List<ProductDiscountModel> products;

  const CheckVoucherModel({
    this.voucherId,
    required this.cost,
    required this.voucherDiscount,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return {
      'voucherId': voucherId,
      'cost': cost,
      'voucherDiscount': voucherDiscount,
      'products': products.map((e) => e.toMap()),
    };
  }

  factory CheckVoucherModel.fromMap(Map<String, dynamic> map) {
    return CheckVoucherModel(
      voucherId: map['voucherId'] as String,
      cost: map['cost'] as int,
      voucherDiscount: map['voucherDiscount'] as String,
      products: map['products'] is! List
          ? []
          : (map['products'] as List)
              .map((e) => ProductDiscountModel.fromMap(e))
              .toList(),
    );
  }
}
