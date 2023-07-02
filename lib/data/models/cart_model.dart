import 'package:sale_app/presentation/res/strings/values.dart';

enum DeliveryType {
  inStore(txtInStore, txtInStoreDetail, 'assets/images/image_in_store.png'),
  takeOut(txtTake, txtTakeDetail, 'assets/images/image_take_away.png'),
  delivery(txtDelivery, txtDeliveryDetail, 'assets/images/image_delivery.jpeg');

  final String name;
  final String description;
  final String image;

  const DeliveryType(this.name, this.description, this.image);
}

class CartModel {
  final String id;
  final String name;
  final int payType;
  final int? given;
  final int cost;
  final int? rate;
  final String? phone;
  final String? voucherName;
  final String? username;
  final List<CartProductModel> products;

  const CartModel({
    required this.id,
    required this.name,
    required this.payType,
    this.given,
    required this.cost,
    this.rate,
    this.phone,
    this.voucherName,
    this.username,
    required this.products,
  });

  CartModel copyWith({
    String? id,
    String? name,
    int? payType,
    int? given,
    int? cost,
    int? rate,
    String? phone,
    String? voucherName,
    String? username,
    List<CartProductModel>? products,
  }) {
    return CartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      payType: payType ?? this.payType,
      given: given ?? this.given,
      cost: cost ?? this.cost,
      rate: rate ?? this.rate,
      phone: phone ?? this.phone,
      voucherName: voucherName ?? this.voucherName,
      username: username ?? this.username,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'payType': payType,
      'given': given,
      'cost': cost,
      'rate': rate,
      'phone': phone,
      'voucherName': voucherName,
      'username': username,
      'products': products,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] as String,
      name: map['name'] as String,
      payType: map['payType'] as int,
      given: map['given'] as int,
      cost: map['cost'] as int,
      rate: map['rate'] as int,
      phone: map['phone'] as String,
      voucherName: map['voucherName'] as String,
      username: map['username'] as String,
      products: (map['products'] as List)
          .map(
            (e) => CartProductModel.fromMap(e),
          )
          .toList(),
    );
  }
}

class CartProductModel {
  final String id;
  final String name;
  final int cost;
  final List<String> options;
  final int amount;
  final String note;

  const CartProductModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.options,
    required this.amount,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'options': options,
      'amount': amount,
      'note': note,
    };
  }

  factory CartProductModel.fromMap(Map<String, dynamic> map) {
    return CartProductModel(
      id: map['id']!,
      name: map['name'] ?? txtUnknown,
      cost: map['cost'] ?? 0,
      options: (map['options'] is List)
          ? (map['options'] as List).map<String>((e) => e as String).toList()
          : <String>[],
      amount: map['amount'] ?? 0,
      note: map['note'] ?? txtNone,
    );
  }

  CartProductModel copyWith({
    String? id,
    String? name,
    int? cost,
    List<String>? options,
    int? amount,
    String? note,
  }) {
    return CartProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      options: options ?? this.options,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object? other) {
    if (other is! CartProductModel) {
      return false;
    }

    if (other.id == id &&
        other.note == note &&
        other.options.length == options.length) {
      for (var e in other.options) {
        if (!options.contains(e)) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(id, options);
}
