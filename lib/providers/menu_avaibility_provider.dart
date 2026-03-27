import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../cors/app_colors.dart';
import '../models/item_request_model.dart';
enum AvailabilityStatus { available, unavailable }
enum ApprovalStatus { pending, approved, rejected }
enum MenuFilter {
  all,
  available,
  unavailable,
  pending,
  approved,
}
enum MenuSort {
  none,
  available,
  unavailable,
  pending,
  approved,
}


class MenuAvailabilityProvider extends ChangeNotifier {
  DateTime? fromDate;
  DateTime? toDate;

  int availableMenu = 650;
  int unavailableMenu = 300;
  int pendingRequest = 350;
  int approveRequest = 500;

  MenuSort _selectedSort = MenuSort.none;

  MenuSort get selectedSort => _selectedSort;

  void setSort(MenuSort sort) {
    // If same option clicked again → clear it
    if (_selectedSort == sort) {
      _selectedSort = MenuSort.none;
    } else {
      _selectedSort = sort;
    }

    notifyListeners();
  }
  List<ItemRequestModel> get items => _items;
  MenuFilter _selectedFilter = MenuFilter.all;
  DateTime? _parseRequestTime(String? requestTime) {
    if (requestTime == null || requestTime.isEmpty) return null;

    final currentYear = DateTime.now().year;

    try {
      final fullDate = "$requestTime $currentYear";
      return DateFormat("dd MMM, hh:mm a yyyy").parse(fullDate);
    } catch (e) {
      return null;
    }
  }
  MenuFilter get selectedFilter => _selectedFilter;

  void setFilter(MenuFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
  final List<ItemRequestModel> _items = [
    ItemRequestModel(
      sno: 1,
      itemName: "Chicken Burger",
      category: "Burgers",
      availability: "Available",
    ),
    ItemRequestModel(
      sno: 2,
      itemName: "French Fries",
      category: "Fries",
      availability: "Unavailable",
      requestTime: "12 Sep, 11:45 AM",
      approvalStatus: "Pending",
    ),
    ItemRequestModel(
      sno: 3,
      itemName: "Grilled Chicken",
      category: "Chicken",
      availability: "Available",
    ),
    ItemRequestModel(
      sno: 5,
      itemName: "Chicken Lollipop",
      category: "Chicken",
      availability: "Unavailable",
      requestTime: "12 Sep, 11:45 AM",
      approvalStatus: "Approved",
      approvedBy: "Priya",
      actionTime: "12 Sep, 10:50 AM",
      tat: "15 min",
    ),
  ];

  String _searchQuery = '';
  Future<void> selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: fromDate != null && toDate != null
          ? DateTimeRange(start: fromDate!, end: toDate!)
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
                        fromDate = null;
                        toDate = null;
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
      fromDate = picked.start;
      toDate = picked.end;
      notifyListeners();
    }
  }


  /// 🔹 Filtered List
  List<ItemRequestModel> get rows {
    List<ItemRequestModel> list = [..._items];


    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((item) {
        return item.itemName.toLowerCase().contains(q) ||
            item.category.toLowerCase().contains(q) ||
            item.availability.toLowerCase().contains(q) ||
            (item.approvalStatus?.toLowerCase().contains(q) ?? false) ||
            item.sno.toString().contains(q);
      }).toList();
    }


    switch (_selectedFilter) {
      case MenuFilter.available:
        list = list
            .where((item) => item.availability.toLowerCase() == "available")
            .toList();
        break;

      case MenuFilter.unavailable:
        list = list
            .where((item) => item.availability.toLowerCase() == "unavailable")
            .toList();
        break;

      case MenuFilter.pending:
        list = list
            .where((item) =>
        item.approvalStatus?.toLowerCase() == "pending")
            .toList();
        break;

      case MenuFilter.approved:
        list = list
            .where((item) =>
        item.approvalStatus?.toLowerCase() == "approved")
            .toList();
        break;

      case MenuFilter.all:
        break;
    }

    switch (_selectedSort) {
      case MenuSort.available:
        list = list
            .where((item) =>
        item.availability.toLowerCase() == "available")
            .toList();
        break;

      case MenuSort.unavailable:
        list = list
            .where((item) =>
        item.availability.toLowerCase() == "unavailable")
            .toList();
        break;

      case MenuSort.pending:
        list = list
            .where((item) =>
        item.approvalStatus?.toLowerCase() == "pending")
            .toList();
        break;

      case MenuSort.approved:
        list = list
            .where((item) =>
        item.approvalStatus?.toLowerCase() == "approved")
            .toList();
        break;

      case MenuSort.none:
        break;
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();

      list = list.where((item) {
        final itemName = item.itemName.toLowerCase();
        final category = item.category.toLowerCase();
        final availability = item.availability.toLowerCase();
        final approvalStatus = item.approvalStatus?.toLowerCase() ?? "";
        final slNo = item.sno.toString();

        return itemName.contains(q) ||
            category.contains(q) ||
            availability.contains(q) ||
            approvalStatus.contains(q) ||
            slNo.contains(q);
      }).toList();
    }

    if (fromDate != null && toDate != null) {
      list = list.where((item) {
        final requestDate = _parseRequestTime(item.requestTime);
        if (requestDate == null) return false;

        return requestDate.isAfter(
            fromDate!.subtract(const Duration(days: 1))) &&
            requestDate.isBefore(
                toDate!.add(const Duration(days: 1)));
      }).toList();
    }



    return list;
  }

  void clearDateRange() {
    fromDate = null;
    toDate = null;
    notifyListeners();
  }

  void setSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }
}
