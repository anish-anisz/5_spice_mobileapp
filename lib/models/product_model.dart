
import '../providers/menu_provider.dart';

class MenuProduct {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String description;
  final double price;
  final bool available;
  final bool isVeg;
  final List<String>? comboImages;

  bool requestSent;
  final OfferType offerType;

  MenuProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.available,
    this.requestSent = false,
    this.comboImages,
    this.isVeg = true,
    this.offerType = OfferType.none,
  });
}


