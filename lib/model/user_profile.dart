import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserProfile {
  String? uid;
  String? name;
  UserProfile({
    required this.uid,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);
}
