import 'package:sale_app/data/models/cart_model.dart';

import '../../presentation/res/strings/values.dart';

class PosModel {
  final String? memberCode;
  final String? voucherId;
  final int? payType;
  final List<PosProductModel>? products;

  const PosModel({
    this.memberCode,
    this.voucherId,
    this.payType,
    this.products,
  });

  bool isEmpty() {
    return payType != null && products != null && products!.isNotEmpty;
  }

  PosModel copyWith({
    String? memberCode,
    String? voucherId,
    int? payType,
    List<PosProductModel>? products,
  }) {
    return PosModel(
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
      products: map['products'] == null ? [] :(map['products'] as List)
          .map(
            (e) => PosProductModel.fromMap(e),
          )
          .toList(),
    );
  }
}

class PosProductModel {
  final String id;
  final List<String> options;
  final int amount;
  final String note;

  const PosProductModel({
    required this.id,
    required this.options,
    required this.amount,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'options': options,
      'amount': amount,
      'note': note,
    };
  }

  factory PosProductModel.fromMap(Map<String, dynamic> map) {
    return PosProductModel(
      id: map['id']!,
      options: (map['options'] is List)
          ? (map['options'] as List).map<String>((e) => e as String).toList()
          : <String>[],
      amount: map['amount'] ?? 0,
      note: map['note'] ?? txtNone,
    );
  }

  PosProductModel copyWith({
    String? id,
    List<String>? options,
    int? amount,
    String? note,
  }) {
    return PosProductModel(
      id: id ?? this.id,
      options: options ?? this.options,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }
}
