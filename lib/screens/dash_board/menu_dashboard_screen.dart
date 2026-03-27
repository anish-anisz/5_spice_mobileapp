import 'package:cravia_kitchen/cors/app_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../cors/app_colors.dart';
import '../../cors/app_text_style.dart';
import '../../models/menu_offer.dart';
import '../../models/product_model.dart';
import '../../providers/menu_provider.dart';
import 'package:provider/provider.dart';

class MenuDashboardScreen extends StatelessWidget {
  const MenuDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuProvider(),
      child: Consumer<MenuProvider>(
        builder: (context, provider, _) {
          return Row(
            children: [
              CategorySidebar(provider),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.selectedTitle.toUpperCase(),
                        style: AppTextStyle.poppinsBold(
                          color: AppColors.textDark,
                          18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SearchBar(),
                      const SizedBox(height: 16),
                      Expanded(child: _ProductGrid(provider)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategorySidebar extends StatelessWidget {
  final MenuProvider provider;

  const CategorySidebar(this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            color: AppColors.grey300, // your border color
            width: 2,           // border thickness
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(3, 0),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          Text(
            "Categories",
            textAlign: TextAlign.center,
            style: AppTextStyle.poppinsSemiBold(
              18,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ...provider.categories.map((category) {
            final isSelected = category.isSelected;

            return GestureDetector(
              onTap: () => provider.selectCategory(category),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(

                  color:
                      isSelected ? AppColors.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        categoryImage(category.name),
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 42,
                            height: 42,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        category.name,
                        style: AppTextStyle.poppinsMedium(
                          14,
                          color:
                              isSelected ? AppColors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
          Text(
            "Offers",
            textAlign: TextAlign.center,
            style: AppTextStyle.poppinsSemiBold(
              18,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          _OfferFilterButton(
            title: "Buy 1 Get 1",
            isSelected: provider.selectedOffer == SelectedOffer.bogo,
            color: AppColors.preparing,
            assetPath: AppImage.bug,
            onTap: () => provider.selectOffer(SelectedOffer.bogo),
          ),
          const SizedBox(height: 10),
          _OfferFilterButton(
            title: "Combo Offer",
            isSelected: provider.selectedOffer == SelectedOffer.combo,
            color: AppColors.ready,
            assetPath: AppImage.combo,
            onTap: () => provider.selectOffer(SelectedOffer.combo),
          ),
        ],
      ),
    );
  }
}

class _OfferFilterButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;
  final String assetPath;

  const _OfferFilterButton({
    required this.title,
    required this.isSelected,
    required this.color,
    required this.onTap,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                assetPath,
                width: 42,
                height: 42,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.poppinsMedium(
                  14,
                  color: isSelected ? AppColors.white : AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String categoryImage(String name) {
  switch (name.toLowerCase()) {
    case 'burger':
      return 'https://png.pngtree.com/png-clipart/20250424/original/pngtree-delicious-burger-image-burgur-fast-food-junk-png-image_20784667.png';
    case 'pizza':
      return 'https://static.vecteezy.com/system/resources/previews/026/723/980/non_2x/foodgraphy-of-pizza-isolated-on-white-background-generative-ai-photo.jpg';
    case 'dessert':
      return 'https://t3.ftcdn.net/jpg/03/01/97/86/360_F_301978652_O0aPwap1JaEVaAhj3mIlbqNnJGmRyCzC.jpg';
    case 'drinks':
      return 'https://hips.hearstapps.com/hmg-prod/images/close-up-of-cranberry-lemonade-on-blue-background-royalty-free-image-1681503457.jpg?crop=0.835xw:1.00xh;0.0561xw,0';
    case 'biriyani':
      return 'https://i.imgur.com/Y9xTtYJ.png';
    case 'french fries':
      return 'https://i.imgur.com/0mKZbQf.png';
    case 'sandwich': // new category
      return 'https://i.imgur.com/abcd123.png'; // replace with your desired image URL
    default:
      return 'https://via.placeholder.com/150';
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child:TextField(
        onChanged: (value) {
          context.read<MenuProvider>().setSearchText(value);
        },
        decoration: InputDecoration(
          hintText: 'Search items',
          hintStyle: AppTextStyle.poppinsRegular(10)
              .copyWith(color: Colors.grey),
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: AppColors.white,
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              showFoodFilterDialog(context);
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),

    );
  }

  void showFoodFilterDialog(BuildContext context) {
    // Use outer context for provider
    final provider = context.read<MenuProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 24), // Reduced width
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            // Set narrower width
            width: 350,
            constraints: const BoxConstraints(
              maxHeight: 300,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Text(
                  "Sort By",
                  style:AppTextStyle.poppinsMedium(20)
                ),
                const SizedBox(height: 20),

                _filterOption(
                  context,
                  title: "All",
                  color: Colors.grey,
                  selected: provider.foodFilter == FoodFilter.all,
                  onTap: () {
                    provider.setFoodFilter(FoodFilter.all);
                    Navigator.pop(dialogContext);
                  },
                ),
                const SizedBox(height: 16),

                _filterOption(
                  context,
                  title: "Veg",

                  color: Colors.green,
                  selected: provider.foodFilter == FoodFilter.veg,
                  onTap: () {
                    provider.setFoodFilter(FoodFilter.veg);
                    Navigator.pop(dialogContext);
                  },
                ),
                const SizedBox(height: 16),

                _filterOption(
                  context,
                  title: "Non-Veg",

                  color: Colors.red,
                  selected: provider.foodFilter == FoodFilter.nonVeg,
                  onTap: () {
                    provider.setFoodFilter(FoodFilter.nonVeg);
                    Navigator.pop(dialogContext);
                  },
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filterOption(
      BuildContext context, {
        required String title,

        required Color color,
        required bool selected,
        required VoidCallback onTap,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          color: selected ? color.withOpacity(0.1) : Colors.transparent,
          boxShadow: selected
              ? [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            //Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: selected
                    ? AppTextStyle.poppinsMedium(16, color: Colors.black87)
                    : AppTextStyle.poppinsRegular(16, color: Colors.black54),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: color, size: 22),
          ],
        ),
      ),
    );
  }





}

class _ProductGrid extends StatelessWidget {
  final MenuProvider provider;

  const _ProductGrid(this.provider);

  @override
  Widget build(BuildContext context) {
    final filteredProducts = provider.filteredProducts; // <- use filtered list
    if (filteredProducts.isEmpty) {
      return const Center(
        child: Text(
          "No Data Found",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double screenWidth = constraints.maxWidth;

        if (screenWidth >= 1200) {
          crossAxisCount = 5;
        } else if (screenWidth >= 900) {
          crossAxisCount = 4;
        } else if (screenWidth >= 600) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        return MasonryGridView.builder(
          itemCount: filteredProducts.length,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
          ),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemBuilder: (_, index) {
            final product = filteredProducts[index];

            return Stack(children: [
              SizedBox(
                  child: _ProductCard(product)),
              if (!product.available)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),

                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              if (!product.available)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Unavailable',
                      style: AppTextStyle.poppinsRegular(
                        12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ]);
          },
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final MenuProduct product;

  const _ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MenuProvider>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.grey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE + UNAVAILABLE BADGE
          Stack(
            children: [
              SizedBox(
                height: 140,
                child: _buildProductImage(product),
              ),

            ],
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PRODUCT NAME
                SizedBox(
                  height: product.offerType == OfferType.combo ? 40 : 20,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: product.name,
                          style: AppTextStyle.poppinsSemiBold(
                            14,
                            color: AppColors.textDark,
                          ),
                        ),
                        if (product.offerType == OfferType.bogo)
                          TextSpan(
                            text: '(Buy One Get One)',
                            style: AppTextStyle.poppinsRegular(
                              9,
                              color: AppColors.delay,
                            ),
                          ),
                      ],
                    ),
                    maxLines: product.offerType == OfferType.combo ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 4),

                // DESCRIPTION
                SizedBox(
                  height: 30,
                  child: Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.regular(
                      color: AppColors.grey,
                      12,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // PRICE
                Text(
                  '₹ ${product.price.toStringAsFixed(0)}',
                  style: AppTextStyle.poppinsSemiBold(
                    color: AppColors.textDark,
                    14,
                  ),
                ),

                const SizedBox(height: 10),
                Divider(color: AppColors.grey300),

                Row(
                  children: [
                   // if (product.requestSent)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Visibility(
                          visible: product.requestSent,
                          child: OutlinedButton(
                            onPressed: product.available && product.requestSent
                                ? () {
                              provider.disableRequest(product);
                            }
                                : null,
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              side: BorderSide(
                                color: product.available && product.requestSent
                                    ? AppColors.grey
                                    : AppColors.grey, // border color
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Disable Request',
                                style: AppTextStyle.regular(
                                  color: product.available && product.requestSent
                                      ? AppColors.grey
                                      : AppColors.grey,
                                  10,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: product.available && !product.requestSent
                              ? () {
                                  provider.sendRequest(product);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: product.requestSent
                                ? AppColors.ready
                                : AppColors.newOrder,
                            disabledBackgroundColor: product.requestSent
                                ? AppColors.ready
                                : AppColors.grey400,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!product.available) ...[
                                SvgPicture.asset(
                                 AppImage.request,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: 6),
                              ] else if (product.requestSent) ...[
                                SvgPicture.asset(
                                AppImage.disable,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: 6),
                              ],

                              Flexible(
                                child: Text(
                                  !product.available
                                      ? 'Disabled'
                                      : product.requestSent
                                      ? 'Request Sent'
                                      : 'Send Request',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: AppTextStyle.poppinsMedium(
                                    color: product.available
                                        ? AppColors.white
                                        : AppColors.white, // disabled look
                                    11,
                                  ),
                                ),

                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _comboImageRow(MenuProduct product) {
    final images = product.comboImages ?? [];

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text("Combo offer",
                style: AppTextStyle.poppinsBold(
                  15,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _comboImage(images[0]),
              _plusIcon(),
              _comboImage(images[1]),
              _plusIcon(),
              _comboImage(images[2]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _plusIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        "+",
        style: AppTextStyle.poppinsBold(
          18,
          color: AppColors.preparing,
        ),
      ),
    );
  }

  Widget _comboImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        width: 55,
        height: 70,
        imageUrl: imageUrl,
        fit: BoxFit.cover,

        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 55,
            height: 70,
            color: Colors.white,
          ),
        ),

        // ERROR / EMPTY IMAGE
        errorWidget: (context, url, error) => Container(
          width: 55,
          height: 70,
          alignment: Alignment.center,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.image,
            size: 40,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(MenuProduct product) {
    return Stack(
      children: [
        /// 🔹 PRODUCT IMAGE / COMBO STACK
        if (product.offerType == OfferType.combo &&
            product.comboImages != null &&
            product.comboImages!.length >= 3)
          _comboImageRow(product)
        else
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,

              // ✨ SHIMMER LOADING
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),

              // ❌ ERROR IMAGE
              errorWidget: (context, url, error) => Container(
                height: 140,
                width: double.infinity,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ),

        /// 🔹 COMBO BADGE
        if (product.offerType == OfferType.combo)
          Positioned(
            top: -7,
            left: 2,
            child: Image.asset(
              AppImage.comboBadge, // combo badge image
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),

        if (product.offerType == OfferType.bogo)
          Positioned(
            top: -15,
            left: 8,
            child: Image.asset(
              AppImage.bugOneBanner,
              width: 75,
              height: 75,
              fit: BoxFit.contain,
            ),
          ),
      ],
    );
  }
}
