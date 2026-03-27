import 'package:flutter/cupertino.dart';

import '../models/category_model.dart';
import '../models/menu_offer.dart';
import '../models/product_model.dart';
enum OfferType { none, bogo, combo }
enum SelectedOffer { none, bogo, combo }
enum FoodFilter { all, veg, nonVeg }

class MenuProvider extends ChangeNotifier {
  FoodFilter foodFilter = FoodFilter.all;
  void setFoodFilter(FoodFilter filter) {
    foodFilter = filter;
    notifyListeners();
  }

  String get selectedTitle {
    if (selectedOffer == SelectedOffer.bogo) {
      return "Buy 1 Get 1";
    }
    if (selectedOffer == SelectedOffer.combo) {
      return "Combo Offer";
    }
    return selectedCategory;
  }
  List<MenuCategory> categories = [
    MenuCategory(id: '1', name: 'Burger', isSelected: true),
    MenuCategory(id: '2', name: 'Pizza'),
    MenuCategory(id: '3', name: 'Dessert'),
    MenuCategory(id: '4', name: 'Drinks'),
  ];


  List<MenuProduct> products = [
    MenuProduct(
      id: '1',
      name: 'Chicken Burger',
      category: 'burger',
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349',
      description: 'Juicy chicken patty coated in crispy crumbs',
      price: 200,
      available: true,
      offerType: OfferType.bogo,
      isVeg: false,
    ),
    MenuProduct(
      id: '2',
      name: 'Cheese Burger',
      category: 'burger',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
      description: 'Loaded with melted cheese and soft buns',
      price: 220,
      available: false,
      offerType: OfferType.none,
      isVeg: true,
    ),
    MenuProduct(
      id: '3',
      name: 'Veg Pizza + Garlic Bread + French Fries + Coke',
      category: 'burger',
      imageUrl: 'https://images.unsplash.com/photo-1550317138-10000687a72b',
      description: 'Double grilled patties with extra cheese',
      price: 280,
      available: true,
      isVeg: false,
      comboImages: [
        'https://images.unsplash.com/photo-1550317138-10000687a72b',
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
        'https://images.unsplash.com/photo-1550547660-d9450f859349',
      ],
      offerType: OfferType.combo,
    ),
    MenuProduct(
      id: '4',
      name: 'Crispy Veg Burger',
      category: 'burger',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
      description: 'Crunchy veg patty with fresh lettuce',
      price: 180,
      available: true,
      isVeg: false,
      offerType: OfferType.bogo,
    ),


    MenuProduct(
      id: '5',
      name: 'Veg Pizza + Garlic Bread + French Fries + Coke',
      category: 'pizza',
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3',
      description: 'Loaded with fresh veggies and mozzarella',
      price: 250,
      available: true,
      isVeg: false,
      comboImages: [
        'https://images.unsplash.com/photo-1550317138-10000687a72b',
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
        'https://images.unsplash.com/photo-1550547660-d9450f859349',
      ],
      offerType: OfferType.combo,
    ),
    MenuProduct(
      id: '6',
      name: 'Pepperoni Pizza',
      category: 'pizza',
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3',
      description: 'Classic pepperoni with cheesy goodness',
      price: 320,
      available: true,
      isVeg: true,
      offerType: OfferType.none,
    ),
    MenuProduct(
      id: '7',
      name: 'Cheese Burst Pizza + Garlic Bread + Coke',
      category: 'pizza',
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3',
      description: 'Extra cheese inside and out',
      price: 350,
      available: true,
      isVeg: false,
      comboImages: [
        'https://images.unsplash.com/photo-1550317138-10000687a72b',
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
        'https://images.unsplash.com/photo-1550547660-d9450f859349',
      ],
      offerType: OfferType.combo,
    ),

    // ================= DESSERT =================
    MenuProduct(
      id: '8',
      name: 'Chocolate Brownie',
      category: 'dessert',
      imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c',
      description: 'Rich chocolate brownie served warm',
      price: 150,
      available: true,
      isVeg: true,
      offerType: OfferType.none,
    ),
    MenuProduct(
      id: '9',
      name: 'Ice Cream Sundae',
      category: 'dessert',
      imageUrl: 'https://images.unsplash.com/photo-1497051788611-2c64812349fa',
      description: 'Vanilla ice cream topped with chocolate syrup',
      price: 180,
      available: true,
      isVeg: false,
      offerType: OfferType.none,
    ),
    MenuProduct(
      id: '10',
      name: 'Cheese Cake',
      category: 'dessert',
      imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c',
      description: 'Creamy cheesecake with biscuit base',
      price: 220,
      available: false,
      isVeg: false,
      offerType: OfferType.none,
    ),

    // ================= DRINKS =================
    MenuProduct(
      id: '11',
      name: 'Cold Coffee',
      category: 'drinks',
      imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348',
      description: 'Chilled coffee blended with milk',
      price: 120,
      available: true,
      isVeg: false,
      offerType: OfferType.none,
    ),
    MenuProduct(
      id: '12',
      name: 'Fresh Lime Soda',
      category: 'drinks',
      imageUrl: 'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62',
      description: 'Refreshing lime with sparkling soda',
      price: 90,
      available: true,
      isVeg: false,
      offerType: OfferType.none,

    ),
    MenuProduct(
      id: '13',
      name: 'Chocolate Milkshake',
      category: 'drinks',
      imageUrl: 'https://images.unsplash.com/photo-1577805947697-89e18249d767',
      description: 'Thick chocolate shake topped with cream',
      price: 160,
      available: false,
      isVeg: false,
      offerType: OfferType.none,
    ),
  ];

  String selectedCategory = 'burger';
  SelectedOffer selectedOffer = SelectedOffer.none;


  void selectCategory(MenuCategory category) {
    categories = categories
        .map((c) => c.copyWith(isSelected: c.id == category.id))
        .toList();

    selectedCategory = category.name.toLowerCase();

    // reset offer filter
    selectedOffer = SelectedOffer.none;

    notifyListeners();
  }


  void selectOffer(SelectedOffer offer) {
    selectedOffer = offer;

    categories = categories
        .map((c) => c.copyWith(isSelected: false))
        .toList();

    notifyListeners();
  }
  String _searchText = '';
  String get searchText => _searchText;

  void setSearchText(String value) {
    _searchText = value.toLowerCase();
    notifyListeners();
  }
  List<MenuProduct> get filteredProducts {
    return products.where((product) {
      if (_searchText.isNotEmpty) {
        final name = product.name.toLowerCase();
        final desc = product.description.toLowerCase();

        if (!name.contains(_searchText) &&
            !desc.contains(_searchText)) {
          return false;
        }
      }

      // CATEGORY FILTER
      if (product.category != selectedCategory) return false;

      // VEG / NON-VEG FILTER
      if (foodFilter == FoodFilter.veg && !product.isVeg) return false;
      if (foodFilter == FoodFilter.nonVeg && product.isVeg) return false;

      // OFFER FILTER
      if (selectedOffer != SelectedOffer.none) {
        if (selectedOffer == SelectedOffer.bogo) {
          return product.offerType == OfferType.bogo;
        }
        if (selectedOffer == SelectedOffer.combo) {
          return product.offerType == OfferType.combo;
        }
      }


      return product.offerType == OfferType.none;

    }).toList();
  }




  void sendRequest(MenuProduct product) {
    if (!product.available) return;
    product.requestSent = true;
    notifyListeners();
  }

  void disableRequest(MenuProduct product) {
    if (!product.available) return;
    product.requestSent = false;
    notifyListeners();
  }
}


