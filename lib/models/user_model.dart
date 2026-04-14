class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? phone;
  final int? age;
  final double? height;
  final double? weight;
  final String? goal;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.age,
    this.height,
    this.weight,
    this.goal,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      age: map['age'],
      height: map['height'],
      weight: map['weight'],
      goal: map['goal'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'height': height,
      'weight': weight,
      'goal': goal,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    int? age,
    double? height,
    double? weight,
    String? goal,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      goal: goal ?? this.goal,
    );
  }
}
