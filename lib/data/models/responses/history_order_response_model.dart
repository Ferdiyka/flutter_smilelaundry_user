import 'dart:convert';

class HistoryOrderResponseModel {
  final List<OrderElement>? orders;

  HistoryOrderResponseModel({
    this.orders,
  });

  factory HistoryOrderResponseModel.fromJson(String str) =>
      HistoryOrderResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HistoryOrderResponseModel.fromMap(Map<String, dynamic> json) =>
      HistoryOrderResponseModel(
        orders: json["orders"] == null
            ? []
            : List<OrderElement>.from(
                json["orders"]!.map((x) => OrderElement.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "orders": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toMap())),
      };
}

class OrderElement {
  final OrderOrder? order;
  final List<Product>? products;

  OrderElement({
    this.order,
    this.products,
  });

  factory OrderElement.fromJson(String str) =>
      OrderElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderElement.fromMap(Map<String, dynamic> json) => OrderElement(
        order: json["order"] == null ? null : OrderOrder.fromMap(json["order"]),
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "order": order?.toMap(),
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toMap())),
      };
}

class OrderOrder {
  final int? id;
  final int? userId;
  final DateTime? orderDate;
  final String? orderStatus;
  final String? paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderOrder({
    this.id,
    this.userId,
    this.orderDate,
    this.orderStatus,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderOrder.fromJson(String str) =>
      OrderOrder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderOrder.fromMap(Map<String, dynamic> json) => OrderOrder(
        id: json["id"],
        userId: json["user_id"],
        orderDate: json["order_date"] == null
            ? null
            : DateTime.parse(json["order_date"]),
        orderStatus: json["order_status"],
        paymentStatus: json["payment_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "order_date":
            "${orderDate!.year.toString().padLeft(4, '0')}-${orderDate!.month.toString().padLeft(2, '0')}-${orderDate!.day.toString().padLeft(2, '0')}",
        "order_status": orderStatus,
        "payment_status": paymentStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Product {
  final int? id;
  final String? name;
  final int? price;
  final int? quantity;

  Product({
    this.id,
    this.name,
    this.price,
    this.quantity,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "price": price,
        "quantity": quantity,
      };
}
