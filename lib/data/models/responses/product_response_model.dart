import 'dart:convert';

class ProductResponseModel {
  final String? message;
  final List<Product>? data;

  ProductResponseModel({
    this.message,
    this.data,
  });

  factory ProductResponseModel.fromJson(String str) =>
      ProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponseModel.fromMap(Map<String, dynamic> json) =>
      ProductResponseModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Product>.from(json["data"]!.map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Product {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? name;
  final int? price;
  final int? duration;
  final String? description;
  final String? note;
  final String? picture;
  // ignore: non_constant_identifier_names
  final String? picture_url;

  Product({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.price,
    this.duration,
    this.description,
    this.note,
    this.picture,
    this.picture_url,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        name: json["name"],
        price: json["price"],
        duration: json["duration"],
        description: json["description"],
        note: json["note"],
        picture: json["picture"],
        picture_url: json["picture_url"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "name": name,
        "price": price,
        "duration": duration,
        "description": description,
        "note": note,
        "picture": picture,
        "picture_url": picture_url,
      };
}
