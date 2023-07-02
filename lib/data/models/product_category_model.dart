import 'package:sale_app/presentation/res/strings/values.dart';

class ProductCategoryModel {
  final String id;
  final String name;
  final String? image;

  ProductCategoryModel({
    required this.id,
    required this.name,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory ProductCategoryModel.fromMap(Map<String, dynamic> map) {
    return ProductCategoryModel(
      id: map['id']!,
      name: map['name'] ?? txtUnknown,
      image: map['image'],
    );
  }
}