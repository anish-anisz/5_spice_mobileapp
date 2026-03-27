class SalesItemReportModel {
  final int sno;
  final String itemName;
  final String category;
  final int quantitySold;
  final double avgPrepTime; // minutes
  final double maxPrepTime; // minutes
  final int delayCount;

  SalesItemReportModel({
    required this.sno,
    required this.itemName,
    required this.category,
    required this.quantitySold,
    required this.avgPrepTime,
    required this.maxPrepTime,
    required this.delayCount,
  });
}
