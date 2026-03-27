import 'order_model.dart';

class ReportRowModel {
  final String orderNo;      // NEW
  final DateTime orderDate;  // NEW
  final String orderId;
  final String customerName;
  final String phone;
  final String items;
  final String amount;
  final String orderType;
  final String payment;
  final OrderStatus status;
  final String packedBy;
  final OrderProductModel? order;

  ReportRowModel({
    required this.orderNo,
    required this.orderDate,
    required this.orderId,
    required this.customerName,
    required this.phone,
    required this.items,
    required this.amount,
    required this.orderType,
    required this.payment,
    required this.status,
    required this.packedBy,
     this.order,
  });
}
