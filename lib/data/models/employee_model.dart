class EmployeeModel {
  final String id;
  final String name;
  final String avatar;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
    );
  }
}