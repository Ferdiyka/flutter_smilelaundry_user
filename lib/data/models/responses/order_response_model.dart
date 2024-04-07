import 'dart:convert';

class OrderResponseModel {
  final String? message;
  final Order? order;

  OrderResponseModel({
    this.message,
    this.order,
  });

  factory OrderResponseModel.fromJson(String str) =>
      OrderResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderResponseModel.fromMap(Map<String, dynamic> json) =>
      OrderResponseModel(
        message: json["message"],
        order: json["order"] == null ? null : Order.fromMap(json["order"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "order": order?.toMap(),
      };
}

class Order {
  final int? userId;
  final DateTime? orderDate;
  final String? orderStatus;
  final String? paymentStatus;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  Order({
    this.userId,
    this.orderDate,
    this.orderStatus,
    this.paymentStatus,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        userId: json["user_id"],
        orderDate: json["order_date"] == null
            ? null
            : DateTime.parse(json["order_date"]),
        orderStatus: json["order_status"],
        paymentStatus: json["payment_status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "order_date":
            "${orderDate!.year.toString().padLeft(4, '0')}-${orderDate!.month.toString().padLeft(2, '0')}-${orderDate!.day.toString().padLeft(2, '0')}",
        "order_status": orderStatus,
        "payment_status": paymentStatus,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
