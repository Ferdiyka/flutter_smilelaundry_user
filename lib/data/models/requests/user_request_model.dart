// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserRequestModel {
  final String? name;
  final String? address;
  final String? noteAddress;
  final String? phone;

  UserRequestModel({
    this.name,
    this.address,
    this.noteAddress,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'noteAddress': noteAddress,
      'phone': phone,
    };
  }

  factory UserRequestModel.fromMap(Map<String, dynamic> map) {
    return UserRequestModel(
      name: map['name'] != null ? map['name'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      noteAddress:
          map['noteAddress'] != null ? map['noteAddress'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRequestModel.fromJson(String source) =>
      UserRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
