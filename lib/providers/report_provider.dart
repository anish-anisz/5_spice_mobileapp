import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../cors/app_colors.dart';
import '../models/order_model.dart';
import '../models/report_row_model.dart';
enum OrderFilter { all, dineIn, takeAway,queue}
enum PaymentSort {
  none,
  paid,
  pending,
  dineIn,
  takeaway,
}

enum OrderViewType {
  list,
  details,
}

class ReportProvider extends ChangeNotifier {
  OrderViewType viewType = OrderViewType.list;

  OrderProductModel? selectedOrder;

  void openOrderDetails() {
    viewType = OrderViewType.details;
    notifyListeners();
  }

  void backToList() {
    viewType = OrderViewType.list;
    selectedOrder = null;
    notifyListeners();
  }
  int totalOrders = 650;
  int dineIn = 300;
  int takeAway = 350;
  int closed = 500;
  int queue = 650;
  int waitingCus = 300;
  int totalQueue = 350;

  OrderFilter _selectedFilter = OrderFilter.all;
  String _searchText = "";

  /// 🔹 NEW: Payment Sort
  PaymentSort _paymentSort = PaymentSort.none;

  OrderFilter get selectedFilter => _selectedFilter;
  PaymentSort get paymentSort => _paymentSort;

  void setFilter(OrderFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
  Future<void> selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _fromDate != null && _toDate != null
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : null,

      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              maxHeight: 600,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryColor,
                  onPrimary: Colors.black,
                  onSurface: AppColors.grey700,
                ),
                datePickerTheme: DatePickerThemeData(
                  rangeSelectionBackgroundColor:
                  AppColors.primaryColor.withOpacity(0.15),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  /// 🔹 ORIGINAL DATE PICKER
                  child!,

                  /// 🔹 RESET — SAME ROW AS CANCEL / OK
                  Positioned(
                    bottom: 8, // aligns with action buttons
                    left: 8,
                    child: TextButton(
                      onPressed: () {
                        _fromDate = null;
                        _toDate = null;
                        notifyListeners();
                        Navigator.pop(context);
                      },
                      child: const Text("Reset"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    /// OK pressed
    if (picked != null) {
      _fromDate = picked.start;
      _toDate = picked.end;
      notifyListeners();
    }
  }





  void clearDateRange() {
    _fromDate = null;
    _toDate = null;
    notifyListeners();
  }

  void setSearch(String value) {
    _searchText = value.toLowerCase();
    notifyListeners();
  }

  /// 🔹 SET SORT
  void setPaymentSort(PaymentSort sort) {
    _paymentSort = sort;
    notifyListeners();
  }

  final List<ReportRowModel> _allRows = List.generate(12, (i) {
    return ReportRowModel(
      orderNo: "${11 + i}", // NEW
      orderDate: DateTime.now().subtract(Duration(days: i)), // NEW

      orderId: "ORD-${1000 + i}",
      customerName: "Customer ${i + 1}",
      phone: "91234567${i}4",
      items: "10 Items",
      amount: "₹85000",
      orderType: i % 3 == 0
          ? "Dine In"
          : i % 3 == 1
          ? "Take Away"
          : "In Queue",

      // orderType: i % 2 == 0 ? "Dine In" : "Take Away",
      payment: i % 2 == 0 ? "Paid" : "Unpaid",
      status: i % 5 == 0
          ? OrderStatus.newOrder
          : i % 5 == 1
          ? OrderStatus.preparing
          : i % 5 == 2
          ? OrderStatus.ready
          : i % 5 == 3
          ? OrderStatus.delay
          : OrderStatus.closed,

      packedBy: "Priya",
    );
  }); /// MOCK DATA (unchanged)


  /// 🔹 FILTER + SEARCH + SORT
  List<ReportRowModel> get rows {
    return _allRows.where((row) {
      /// Order Type Filter
      bool matchesFilter =
          _selectedFilter == OrderFilter.all ||
              (_selectedFilter == OrderFilter.dineIn &&
                  row.orderType == "Dine In") ||
              (_selectedFilter == OrderFilter.takeAway &&
                  row.orderType == "Take Away")||
      (_selectedFilter == OrderFilter.queue &&
          row.orderType == "In Queue");

      /// Search Filter
      bool matchesSearch =
          row.customerName.toLowerCase().contains(_searchText) ||
              row.orderId.toLowerCase().contains(_searchText);

      /// 🔹 Payment Sort Filter
      bool matchesPayment =
          _paymentSort == PaymentSort.none ||
              (_paymentSort == PaymentSort.paid &&
                  row.payment == "Paid") ||
              (_paymentSort == PaymentSort.pending &&
                  row.payment == "Unpaid") ||
              (_paymentSort == PaymentSort.dineIn &&
              row.orderType == "Dine In") ||
              (_paymentSort == PaymentSort.takeaway &&
                  row.orderType == "Take Away");
      bool matchesDate = true;

      if (_fromDate != null && _toDate != null) {
        final rowDate = DateTime(
          row.orderDate.year,
          row.orderDate.month,
          row.orderDate.day,
        );

        matchesDate =
            !rowDate.isBefore(
              DateTime(_fromDate!.year, _fromDate!.month, _fromDate!.day),
            ) &&
                !rowDate.isAfter(
                  DateTime(_toDate!.year, _toDate!.month, _toDate!.day),
                );
      }


      return matchesFilter && matchesSearch && matchesPayment && matchesDate;
    }).toList();
  }

  DateTime? _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime? _fromDate;
  DateTime? _toDate;

  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

  DateTime? get selectedDate => _selectedDate;
  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }
  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,     // Header & OK button
              onPrimary: Colors.black,            // Header text
              onSurface: AppColors.grey700,   // CANCEL button text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor, // OK & CANCEL text
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) {
      _selectedDate = null; // User clicked CANCEL
    } else {
      _selectedDate = picked;
    }

    notifyListeners();
  }


  void clearDateFilter() {
    _selectedDate = null;
    notifyListeners();
  }
  String get selectedDateLabel {
    if (_selectedDate == null) return "Date";

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected =
    DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);

    if (selected == today) return "Today";

    return DateFormat('dd MMM yyyy').format(_selectedDate!);
  }

}



