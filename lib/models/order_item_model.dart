class OrderItems {
  final String name;
  final int qty;
  final String size;
  bool isChecked;

  OrderItems({
    required this.name,
    required this.qty,
    required this.size,
    this.isChecked = false,
  });
}


