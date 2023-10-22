// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Usermodel {
  final String name;
  final String email;
  final String password;
  final String id;
  final String profilePic;
  Usermodel(
      {required this.name,
      required this.email,
      required this.password,
      required this.id,
      required this.profilePic});

  Usermodel copyWith(
      {String? name,
      String? email,
      String? password,
      String? id,
      String? profilePic}) {
    return Usermodel(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        id: id ?? this.id,
        profilePic: profilePic ?? this.profilePic);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'profilePic': profilePic
    };
  }

  factory Usermodel.fromMap(Map<String, dynamic> map) {
    return Usermodel(
        name: map['name'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        id: map['\$id'] as String,
        profilePic: map['profilePic'] as String);
  }

  // String toJson() => json.encode(toMap());

  // factory Usermodel.fromJson(String source) => Usermodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Usermodel(name: $name, email: $email, password: $password, id: $id, profilePic: $profilePic)';
  }

  @override
  bool operator ==(covariant Usermodel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.password == password &&
        other.id == id &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        id.hashCode ^
        profilePic.hashCode;
  }
}
