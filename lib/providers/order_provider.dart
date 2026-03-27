import 'package:flutter/material.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';
import '../models/time_slot_model.dart';

class OrderProvider extends ChangeNotifier {
  String? selectedPackedBy;
  final List<String> packers = ['Priya', 'Rahul', 'Anita', 'John'];
  void setPackedBy(String? name) {
    selectedPackedBy = name;
    notifyListeners();
  }

  OrderStatus selectedStatus = OrderStatus.all;


  final List<OrderProductModel> _orders = [
    OrderProductModel(
      id: 1,
      orderNo: "ORD-1001",
      customerName: "Jacob Dinesh Kumar",
      phoneNumber: "9876543210",
      orderType: "Dine In",
      tableNumber: "T01",
      time: DateTime.now(),
      preparingTime: const Duration(minutes: 15),
      status: OrderStatus.newOrder,
      items: [
        OrderItems(name: "Sandwich", qty: 1, size: "Large"),
        OrderItems(name: "French Fries", qty: 2, size: "Medium"),
      ],
    ),
    OrderProductModel(
      id: 2,
      orderNo: "ORD-1002",
      customerName: "Karthik",
      phoneNumber: "9123456789",
      orderType: "Take Away",
      tableNumber: "-",
      time: DateTime.now(),
      preparingTime: const Duration(minutes: 10),
      status: OrderStatus.preparing,
      items: [
        OrderItems(name: "Chicken Wings", qty: 1, size: "Medium"),
      ],
    ),
    OrderProductModel(
      id: 3,
      orderNo: "ORD-1003",
      customerName: "Divya",
      phoneNumber: "9012345678",
      orderType: "Dine In",
      tableNumber: "T05",
      time: DateTime.now(),
      preparingTime: const Duration(minutes: 20),
      status: OrderStatus.ready,
      items: [
        OrderItems(name: "Burger Combo", qty: 1, size: "Large"),
      ],
    ),
    OrderProductModel(
      id: 4,
      orderNo: "ORD-1004",
      customerName: "Ravi",
      phoneNumber: "9988776655",
      orderType: "Dine In",
      tableNumber: "T09",
      time: DateTime.now(),
      preparingTime: const Duration(minutes: 25),
      status: OrderStatus.delay,
      items: [
        OrderItems(name: "Pasta", qty: 2, size: "Medium"),
      ],
    ),
    // OrderProductModel(
    //   id: 5,
    //   orderNo: "ORD-1005",
    //   customerName: "Ravi",
    //   phoneNumber: "9988776655",
    //   orderType: "Dine In",
    //   tableNumber: "T09",
    //   time: DateTime.now(),
    //   preparingTime: const Duration(minutes: 25),
    //   // status: OrderStatus.queue,
    //   items: [
    //     OrderItems(name: "Pizza", qty: 2, size: "Medium"),
    //   ],
    // ),
  ];

  late OrderModel order;

  OrderProvider() {
    order = OrderModel(
      orderId: '#9307544',
      table: 'Table 5',
      status: 'Paid',
      items: [
        ProductModel(name: 'Beef onion pizza', qty: 2, price: 80),
        ProductModel(name: 'Cheese pizza', qty: 1, price: 40),
        ProductModel(name: 'Cheese pizza', qty: 1, price: 50),
      ],
    );
  }

  /// FILTER LOGIC
  List<OrderProductModel> get filteredOrders {
    if (selectedStatus == OrderStatus.all) {
      return _orders;
    }
    return _orders.where((o) => o.status == selectedStatus).toList();
  }

  /// TAB CHANGE
  void changeTab(OrderStatus status) {
    selectedStatus = status;
    notifyListeners();
  }


  void updateStatus(int id, OrderStatus status) {
    final index = _orders.indexWhere((e) => e.id == id);
    if (index != -1) {
      _orders[index].status = status;
      notifyListeners();
    }
  }

  void toggleItemCheck(OrderProductModel order, int index, bool value) {
    order.items[index].isChecked = value;
    notifyListeners();
  }

  bool allItemsChecked(OrderProductModel order) {
    return order.items.every((item) => item.isChecked);
  }

  Future<bool> updateOrderStatusWithValidation(
      BuildContext context,
      OrderProductModel order,
      OrderStatus status,
      ) async {
    // Check items selection
    if (status != OrderStatus.preparing && !allItemsChecked(order)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select all items before proceeding"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    if (status == OrderStatus.ready && selectedPackedBy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select who packed the order"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    updateStatus(order.id, status);

    return true; // ✅ validation success
  }


  int count(OrderStatus status) {
    if (status == OrderStatus.all) return _orders.length;
    return _orders.where((e) => e.status == status).length;
  }

  int selectedTimeIndex = 0;
  bool isCurrentTimeSlot(String slotTime) {
    final now = TimeOfDay.now();

    // Convert slotTime string → TimeOfDay
    final format = DateFormat.jm(); // "10:30 AM"
    final dateTime = format.parse(slotTime);
    final slot = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

    return now.hour == slot.hour;
  }

  final List<TimeSlot> timeSlots = [
    TimeSlot(time: "8:00 AM\n09:00 AM", count: 15),
    TimeSlot(time: "09:00 AM\n10:00 PM", count: 20),
    TimeSlot(time: "10:00 AM\n11:00 AM", count: 15),
    TimeSlot(time: "11:00 AM\n12:00 PM", count: 20),
    TimeSlot(time: "12:00 PM\n01:00 PM", count: 24),
    TimeSlot(time: "01:00 PM\n02:00 PM", count: 30),
    TimeSlot(time: "02:00 PM\n03:00 PM", count: 13),

    TimeSlot(time: "03:00 PM\n04:00 PM", count: 10),
    TimeSlot(time: "04:00 PM\n05:00 PM", count: 35),
    TimeSlot(time: "05:00 PM\n06:00 PM", count: 23),
    TimeSlot(time: "06:00 PM\n07:00 PM", count: 18),
    TimeSlot(time: "07:00 PM\n08:00 PM", count: 20),
    TimeSlot(time: "08:00 PM\n09:00 PM", count: 25),
    TimeSlot(time: "09:00 PM\n10:00 PM", count: 13),
    TimeSlot(time: "10:00 PM\n11:00 PM", count: 10),
  ];


  void selectTimeSlot(int index) {
    selectedTimeIndex = index;
    notifyListeners();
  }
  // List<TimeSlot> timeSlots = [];
  // int selectedTimeIndex = -1;


  void selectCurrentTimeSlot() {
    final now = DateTime.now();
    final format = DateFormat('hh:mm a');

    for (int i = 0; i < timeSlots.length; i++) {
      final parts = timeSlots[i].time.split('\n');

      if (parts.length != 2) continue;

      DateTime start = format.parse(parts[0]);
      DateTime end = format.parse(parts[1]);

      // Adjust date to today
      start = DateTime(
        now.year, now.month, now.day,
        start.hour, start.minute,
      );
      end = DateTime(
        now.year, now.month, now.day,
        end.hour, end.minute,
      );

      // Handle PM → AM crossing (safety)
      if (end.isBefore(start)) {
        end = end.add(const Duration(days: 1));
      }

      if (now.isAfter(start) && now.isBefore(end)) {
        selectedTimeIndex = i;
        notifyListeners();
        return;
      }
    }

    // fallback → first slot
    selectedTimeIndex = 0;
    notifyListeners();
  }
  bool isUpcomingSlot(TimeSlot slot) {
    final now = DateTime.now();

    // Example slot.time = "14:30"
    final parts = slot.time.split(':');
    final slotTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    // Disable ONLY future slots
    return slotTime.isAfter(now);
  }

  // void selectTimeSlot(int index) {
  //   selectedTimeIndex = index;
  //   notifyListeners();
  // }
}


