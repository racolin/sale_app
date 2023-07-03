import 'package:sale_app/data/models/cart_model.dart';

import '../../presentation/res/strings/values.dart';

class PosModel {
  final String? title;
  final String? memberCode;
  final String? voucherId;
  final int payType;
  final List<PosProductModel> products;

  const PosModel({
    this.title,
    this.memberCode,
    this.voucherId,
    this.payType = 0,
    this.products = const [],
  });

  bool isNotEmpty() {
    return payType != null && products != null && products!.isNotEmpty;
  }

  PosModel copyWith({
    String? title,
    String? memberCode,
    String? voucherId,
    int? payType,
    List<PosProductModel>? products,
  }) {
    print(memberCode);
    print(title);
    print(this.memberCode);
    print(this.title);
    return PosModel(
      title: title ?? this.title,
      memberCode: memberCode ?? this.memberCode,
      voucherId: voucherId ?? this.voucherId,
      payType: payType ?? this.payType,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberCode': memberCode,
      'voucherId': voucherId,
      'payType': payType,
      'products': products,
    };
  }

  factory PosModel.fromMap(Map<String, dynamic> map) {
    return PosModel(
      memberCode: map['memberCode'] as String,
      voucherId: map['voucherId'] as String,
      payType: map['payType'] as int,
      products: map['products'] == null
          ? []
          : (map['products'] as List)
              .map(
                (e) => PosProductModel.fromMap(e),
              )
              .toList(),
    );
  }
}

class PosProductModel {
  final String id;
  final String name;
  final List<String> options;
  final int amount;
  final String note;

  const PosProductModel({
    required this.id,
    required this.name,
    required this.options,
    required this.amount,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'options': options,
      'amount': amount,
      'note': note,
    };
  }

  factory PosProductModel.fromMap(Map<String, dynamic> map) {
    return PosProductModel(
      id: map['id']!,
      name: map['name'],
      options: (map['options'] is List)
          ? (map['options'] as List).map<String>((e) => e as String).toList()
          : <String>[],
      amount: map['amount'] ?? 0,
      note: map['note'] ?? txtNone,
    );
  }

  PosProductModel copyWith({
    String? id,
    String? name,
    List<String>? options,
    int? amount,
    String? note,
  }) {
    return PosProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      options: options ?? this.options,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) {
    return (other is PosProductModel &&
        id == other.id &&
        name == other.name &&
        options.length == other.options.length &&
        options.every((e) => other.options.contains(e)) &&
        amount == other.amount &&
        note == other.note);
  }

  @override
  int get hashCode => Object.hash(id, amount);
}
