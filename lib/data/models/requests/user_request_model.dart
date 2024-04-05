// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserRequestModel {
  final String? name;
  final String? address;
  final String? noteAddress;
  final String? phone;
  final double? radius;
  final double? latitudeUser;
  final double? longitudeUser;

  UserRequestModel({
    this.name,
    this.address,
    this.noteAddress,
    this.phone,
    this.radius,
    this.latitudeUser,
    this.longitudeUser,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'note_address': noteAddress,
      'phone': phone,
      'radius': radius,
      'latitude_user': latitudeUser,
      'longitude_user': longitudeUser,
    };
  }

  factory UserRequestModel.fromMap(Map<String, dynamic> map) {
    return UserRequestModel(
      name: map['name'] != null ? map['name'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      noteAddress:
          map['noteAddress'] != null ? map['noteAddress'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      radius: map['radius'] != null ? map['radius'] as double : null,
      latitudeUser:
          map['latitudeUser'] != null ? map['latitudeUser'] as double : null,
      longitudeUser:
          map['longitudeUser'] != null ? map['longitudeUser'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRequestModel.fromJson(String source) =>
      UserRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
