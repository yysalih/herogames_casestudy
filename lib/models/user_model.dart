import 'package:flutter/material.dart';
import 'base_model.dart';

@immutable
class UserModel implements BaseModel<UserModel> {

  final String? uid;
  final String? name;
  final String? email;
  final String? birthdate;
  final List? hobbies;

  const UserModel({this.uid, this.name, this.birthdate, this.hobbies, this.email,});

  @override
  UserModel fromJson(Map<String, dynamic> json) => UserModel(
    uid: json["uid"] as String?,
    name: json["name"] as String?,
    email: json["email"] as String?,
    birthdate: json["birthdate"] as String?,
    hobbies: json["hobbies"] as List?,
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "uid": uid,
    "name": name,
    "email": email,
    "birthdate": birthdate,
    "hobbies": hobbies,
  };

}