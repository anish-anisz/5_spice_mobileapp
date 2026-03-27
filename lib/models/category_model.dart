class MenuCategory {
  final String id;
  final String name;
  final bool isSelected;

  MenuCategory({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  MenuCategory copyWith({
    bool? isSelected,
  }) {
    return MenuCategory(
      id: id,
      name: name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
