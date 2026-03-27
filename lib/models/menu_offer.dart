class MenuOffer {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isCombo; // false = BOGO, true = Combo

  MenuOffer({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.isCombo = false,
  });
}
