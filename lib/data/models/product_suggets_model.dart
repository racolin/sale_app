class ProductSuggestModel {
  final String id;
  final List<String> options;
  final int amount;

  const ProductSuggestModel({
    required this.id,
    required this.options,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'options': options,
      'amount': amount,
    };
  }

  factory ProductSuggestModel.fromMap(Map<String, dynamic> map) {
    return ProductSuggestModel(
      id: map['id']!,
      options: (map['options'] is List)
          ? (map['options'] as List).map<String>((e) => e as String).toList()
          : <String>[],
      amount: map['amount'] ?? 0,
    );
  }

  ProductSuggestModel copyWith({
    String? id,
    List<String>? options,
    int? amount,
  }) {
    return ProductSuggestModel(
      id: id ?? this.id,
      options: options ?? this.options,
      amount: amount ?? this.amount,
    );
  }

  @override
  bool operator ==(Object? other) {
    if (other is! ProductSuggestModel) {
      return false;
    }

    if (other.id == id &&
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
