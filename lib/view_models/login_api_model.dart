class AccountModel {
  final int id;
  final DateTime createdAt;
  final String name;
  final String email;
  final String uid;

  AccountModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.email,
    required this.uid,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      uid: json['uid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created_at": createdAt.toIso8601String(),
      "name": name,
      "email": email,
      "uid": uid,
    };
  }
}
