import 'order_item_model.dart';

enum OrderStatus {
  all,
  newOrder,
  preparing,
  ready,
  closed,
  delay,
  // queue
}


class OrderProductModel {
  final int id;

  // Customer details
  final String customerName;
  final String phoneNumber;

  // Order details
  final String orderType;        // Dine In / Take Away
  final String tableNumber;      // e.g. T01, T12 (empty for takeaway)
  final String orderNo;          // e.g. ORD-1023

  final DateTime time;           // Order placed time
  final Duration preparingTime; // Estimated preparing time

  OrderStatus status;
  DateTime? queuedAt;

  final List<OrderItems> items;

  OrderProductModel({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.orderType,
    required this.tableNumber,
    required this.orderNo,
    required this.time,
    required this.preparingTime,
    required this.status,
    required this.items,
    this.queuedAt,

  });
}
class OrderModel {
  final String orderId;
  final String table;
  final String status;
  final List<ProductModel> items;

  OrderModel({
    required this.orderId,
    required this.table,
    required this.status,
    required this.items,
  });

  double get subTotal =>
      items.fold(0, (sum, item) => sum + (item.price * item.qty));

  double get gst => subTotal * 0.05;
  double get total => subTotal + gst;
}
class ProductModel {
  final String name;
  final int qty;
  final double price;

  ProductModel({
    required this.name,
    required this.qty,
    required this.price,
  });
}