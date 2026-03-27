import 'package:flutter/cupertino.dart';
import '../models/sales_report_model.dart';

enum SalesSortType {
  none,
  quantityHighToLow,
  avgPrepFastToSlow,
  delayHighToLow,
}


class SalesReportProvider extends ChangeNotifier {
  int totalItems = 650;
  int soldItem = 300;
  int slowestItem = 350;
  int itemsCausingDelay = 500;

  SalesSortType _sortType = SalesSortType.none;


  List<SalesItemReportModel> get items => _items;
  final List<SalesItemReportModel> _items = [
    SalesItemReportModel(
      sno: 1,
      itemName: "Chicken Burger",
      category: "Burgers",
      quantitySold: 245,
      avgPrepTime: 12.5,
      maxPrepTime: 25,
      delayCount: 16,
    ),
    SalesItemReportModel(
      sno: 2,
      itemName: "French Fries",
      category: "Fries",
      quantitySold: 245,
      avgPrepTime: 9.8,
      maxPrepTime: 25,
      delayCount: 20,
    ),
    SalesItemReportModel(
      sno: 3,
      itemName: "Grilled Chicken",
      category: "Chicken",
      quantitySold: 245,
      avgPrepTime: 12.5,
      maxPrepTime: 25,
      delayCount: 2,
    ),
    SalesItemReportModel(
      sno: 4,
      itemName: "Chicken Wings",
      category: "Chicken",
      quantitySold: 320,
      avgPrepTime: 6.2,
      maxPrepTime: 25,
      delayCount: 2,
    ),
    SalesItemReportModel(
      sno: 5,
      itemName: "Chicken Lollipop",
      category: "Chicken",
      quantitySold: 110,
      avgPrepTime: 6.2,
      maxPrepTime: 25,
      delayCount: 2,
    ),
    SalesItemReportModel(
      sno: 6,
      itemName: "Peri Peri Fries",
      category: "Fries",
      quantitySold: 110,
      avgPrepTime: 6.2,
      maxPrepTime: 25,
      delayCount: 2,
    ),
    SalesItemReportModel(
      sno: 7,
      itemName: "BBQ Chicken Pizza",
      category: "Chicken",
      quantitySold: 150,
      avgPrepTime: 9.8,
      maxPrepTime: 25,
      delayCount: 3,
    ),
    SalesItemReportModel(
      sno: 8,
      itemName: "Alfredo Pasta",
      category: "Pasta",
      quantitySold: 150,
      avgPrepTime: 9.8,
      maxPrepTime: 25,
      delayCount: 3,
    ),
    SalesItemReportModel(
      sno: 9,
      itemName: "Alfredo Pasta",
      category: "Pasta",
      quantitySold: 200,
      avgPrepTime: 9.8,
      maxPrepTime: 25,
      delayCount: 3,
    ),
    SalesItemReportModel(
      sno: 10,
      itemName: "Alfredo Pasta",
      category: "Pasta",
      quantitySold: 200,
      avgPrepTime: 6.2,
      maxPrepTime: 25,
      delayCount: 3,
    ),
    SalesItemReportModel(
      sno: 11,
      itemName: "Alfredo Pasta",
      category: "Pasta",
      quantitySold: 200,
      avgPrepTime: 6.2,
      maxPrepTime: 25,
      delayCount: 25,
    ),
    SalesItemReportModel(
      sno: 12,
      itemName: "Alfredo Pasta",
      category: "Pasta",
      quantitySold: 200,
      avgPrepTime: 6.2,
      maxPrepTime: 25,
      delayCount: 25,
    ),
  ];

  String _searchQuery = '';

  /// 🔹 Public filtered list
  List<SalesItemReportModel> get rows {
    List<SalesItemReportModel> list = [..._items];

    // 🔍 SEARCH FILTER
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((item) {
        return item.itemName.toLowerCase().contains(q) ||
            item.category.toLowerCase().contains(q) ||
            item.sno.toString().contains(q);
      }).toList();
    }


    switch (_sortType) {
      case SalesSortType.quantityHighToLow:
        list.sort((a, b) => b.quantitySold.compareTo(a.quantitySold));
        break;

      case SalesSortType.avgPrepFastToSlow:
        list.sort((a, b) => a.avgPrepTime.compareTo(b.avgPrepTime));
        break;

      case SalesSortType.delayHighToLow:
        list.sort((a, b) => b.delayCount.compareTo(a.delayCount));
        break;

      case SalesSortType.none:
      // No sorting → original order
        break;
    }

    return list;
  }

  void setSort(SalesSortType type) {
    _sortType = type;
    notifyListeners();
  }



  void clearSort() {
    _sortType = SalesSortType.none;
    notifyListeners();
  }

  void setSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }
}