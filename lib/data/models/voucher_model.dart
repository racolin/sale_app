class VoucherModel {
  final String id;
  final String code;
  final String name;
  final String image;
  final DateTime from;
  final DateTime to;
  final String description;

  const VoucherModel({
    required this.id,
    required this.code,
    required this.name,
    required this.image,
    required this.from,
    required this.to,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'image': image,
      'from': from.millisecondsSinceEpoch,
      'to': to.millisecondsSinceEpoch,
      'description': description,
    };
  }

  factory VoucherModel.fromMap(Map<String, dynamic> map) {
    return VoucherModel(
      id: map['id'] as String,
      code: map['code'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      from: map['from'] == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(map['from']),
      to: map['to'] == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(map['to']),
      description: map['description'] as String,
    );
  }
}
