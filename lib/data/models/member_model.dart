class MemberModel {
  final String id;
  final String name;
  final String code;
  final String phone;
  final String rankName;
  final String rankColor;
  final int currentPoint;

  const MemberModel({
    required this.id,
    required this.name,
    required this.code,
    required this.phone,
    required this.rankName,
    required this.rankColor,
    required this.currentPoint,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'phone': phone,
      'rankName': rankName,
      'rankColor': rankColor,
      'currentPoint': currentPoint,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      phone: map['phone'] as String,
      rankName: map['rankName'] as String,
      rankColor: map['rankColor'] as String,
      currentPoint: map['currentPoint'] as int,
    );
  }
}