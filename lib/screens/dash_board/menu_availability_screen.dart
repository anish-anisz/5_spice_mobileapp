import 'package:cravia_kitchen/models/item_request_model.dart';
import 'package:cravia_kitchen/screens/dash_board/report_dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cors/app_colors.dart';
import '../../cors/app_image.dart';
import '../../cors/app_text_style.dart';
import '../../cors/resonsiveness.dart';
import '../../providers/menu_avaibility_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class MenuAvailabilityScreen extends StatefulWidget {
  final bool showStats;
  final VoidCallback onToggleStats;
  const MenuAvailabilityScreen({
    super.key,
    required this.showStats,
    required this.onToggleStats,
  });

  @override
  State<MenuAvailabilityScreen> createState() => _MenuAvailabilityScreenState();
}

class _MenuAvailabilityScreenState extends State<MenuAvailabilityScreen> {
  int? expandedIndex;

  @override
  @override
  Widget build(BuildContext context) {
    final responsive = Responsiveness(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => MenuAvailabilityProvider(),
             child: Scaffold(
          body: Consumer<MenuAvailabilityProvider>(
            builder: (context, provider, _) {
              return Stack(children: [
                Container(
                  color: Colors.white,
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 Stats Section + Arrow
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: widget.showStats ? null : 0,
                              child: widget.showStats
                                  ? Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: [
                                        _statCard(
                                            "Available Menu Items",
                                            "",
                                            "${provider.availableMenu} items",
                                            0),
                                        _statCard(
                                            "Unavailable Menu Items",
                                            "",
                                            "${provider.unavailableMenu} Request",
                                            1),
                                        _statCard(
                                            "Pending Request",
                                            "",
                                            "${provider.pendingRequest} Request",
                                            2),
                                        _statCard(
                                            "Approved Requests",
                                            "",
                                            "${provider.approveRequest} Approved",
                                            3),
                                      ],
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Filter Section
                      Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1.5,
                              color: AppColors.grey300,
                            ),
                          ),
                          Row(
                            children: [
                              _filterChip(
                                context,
                                "All",
                                provider.selectedFilter == MenuFilter.all,
                                () => provider.setFilter(MenuFilter.all),
                              ),
                              const SizedBox(width: 20),
                              _filterChip(
                                context,
                                "Available",
                                provider.selectedFilter == MenuFilter.available,
                                () => provider.setFilter(MenuFilter.available),
                              ),
                              const SizedBox(width: 20),
                              _filterChip(
                                context,
                                "Unavailable",
                                provider.selectedFilter ==
                                    MenuFilter.unavailable,
                                () =>
                                    provider.setFilter(MenuFilter.unavailable),
                              ),
                              const SizedBox(width: 20),
                              _filterChip(
                                context,
                                "Pending Requests",
                                provider.selectedFilter == MenuFilter.pending,
                                () => provider.setFilter(MenuFilter.pending),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Search + Export
                      Row(
                        children: [
                          Expanded(
                            child: SearchBar(),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              context
                                  .read<MenuAvailabilityProvider>()
                                  .selectDateRange(context);
                            },
                            onLongPress: () {
                              context
                                  .read<MenuAvailabilityProvider>()
                                  .clearDateRange();
                            },
                            child: _iconButton(
                              AppImage.calender,
                              context
                                          .watch<MenuAvailabilityProvider>()
                                          .fromDate ==
                                      null
                                  ? "Select Date"
                                  : "${DateFormat('dd MMM').format(context.watch<MenuAvailabilityProvider>().fromDate!)}"
                                      " - "
                                      "${DateFormat('dd MMM yyyy').format(context.watch<MenuAvailabilityProvider>().toDate!)}",
                              color: Colors.black
                            ),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<MenuSort>(
                            color: AppColors.white,
                            onSelected: (value) {
                              context
                                  .read<MenuAvailabilityProvider>()
                                  .setSort(value);
                            },
                            itemBuilder: (_) {
                              final provider =
                                  context.read<MenuAvailabilityProvider>();

                              return [
                                PopupMenuItem(
                                  value: MenuSort.available,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Available",
                                          style: AppTextStyle.medium(15)),
                                      if (provider.selectedSort ==
                                          MenuSort.available)
                                        const Icon(Icons.check, size: 18),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: MenuSort.unavailable,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Unavailable",
                                          style: AppTextStyle.medium(15)),
                                      if (provider.selectedSort ==
                                          MenuSort.unavailable)
                                        const Icon(Icons.check, size: 18),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: MenuSort.pending,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Pending",
                                          style: AppTextStyle.medium(15)),
                                      if (provider.selectedSort ==
                                          MenuSort.pending)
                                        const Icon(Icons.check, size: 18),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: MenuSort.approved,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Approved",
                                          style: AppTextStyle.medium(15)),
                                      if (provider.selectedSort ==
                                          MenuSort.approved)
                                        const Icon(Icons.check, size: 18),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            child: _iconButton(
                              AppImage.sort,
                              "Sort By",
                              color: AppColors.grey700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _iconButton(
                            AppImage.export,
                            "Export",
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// 🔹 Table Section
                      Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey300),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width:
                                responsive.isTablet ? 1200 : screenWidth * 0.8,
                            child: Column(
                              children: [
                                _tableHeader(),
                                Expanded(
                                  child: provider.rows.isEmpty
                                      ? Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.inbox_outlined,
                                                size: 48,
                                                color: Colors.grey.shade400,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "No data found",
                                                style:
                                                    AppTextStyle.poppinsMedium(
                                                  14,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: provider.rows.length,
                                          itemBuilder: (_, i) {
                                            return _tableRow(
                                              context,
                                              provider.rows[i],
                                              i + 1,
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (expandedIndex == 1 || expandedIndex == 2)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          expandedIndex = null;
                        });
                      },
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {},
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              elevation: 10,
                              child: Container(
                                width: 280,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: _buildExpandedContent(expandedIndex!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ]);
            },
          ),
        ),
    );
  }

  Widget _filterChip(
    BuildContext context,
    String title,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? AppColors.primaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: AppTextStyle.poppinsMedium(
            14,
            color: selected ? AppColors.primaryColor : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _tableRow(
    BuildContext context,
    ItemRequestModel row,
    int index, {
    VoidCallback? onRowTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _Cell(index.toString(), flex: _columnFlex[0]),
          _Cell(row.itemName, flex: _columnFlex[1]),
          _Cell(row.category, flex: _columnFlex[1]),
          _Cell(
            row.availability,
            flex: _columnFlex[1],
            align: TextAlign.center,
          ),
          _Cell(
            row.requestTime ?? "-",
            flex: _columnFlex[1],
          ),
          _Cell(
            row.approvalStatus ?? "-",
            flex: _columnFlex[1],
            align: TextAlign.center,
          ),
          _Cell(
            row.approvedBy ?? "-",
            flex: _columnFlex[1],
          ),
          _Cell(row.actionTime ?? "-", flex: _columnFlex[1]),
          _Cell(row.tat ?? "-", flex: _columnFlex[1]),
        ],
      ),
    );
  }

  Widget _iconButton(
    String assetPath,
    String label, {
    double iconSize = 16,
    Color color = AppColors.blue,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            assetPath,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyle.poppinsMedium(
              12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<int> _columnFlex = [
    1, // S.No
    2, // KOT No
    2, // Date
    2, // Customer
    2, // Order Type
    2, // Table No
    2, // Items
    2, // Amount
    2, // Payment Status
    2, // Order Status
    2, // Action
  ];

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: const BoxDecoration(
        color: AppColors.tableHeader,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          _Header("S.No", flex: _columnFlex[0]),
          _Header("Item Name", flex: _columnFlex[1]),
          _Header("Category", flex: _columnFlex[1]),
          _Header("Availability", flex: _columnFlex[1]),
          _Header("Request Time", flex: _columnFlex[1]),
          _Header("Approval Status",
              flex: _columnFlex[1], align: TextAlign.center),
          _Header("Approved By", flex: _columnFlex[1]),
          _Header("Action Time", flex: _columnFlex[1]),
          _Header("TAT", flex: _columnFlex[1]),
        ],
      ),
    );
  }

  Widget _statCard(
    String title,
    String subTitle,
    String value,
    int index,
  ) {
    final statConfigs = {
      "Available Menu Items":
          const StatCardConfig(AppColors.primaryColor, AppImage.available),
      "Unavailable Menu Items":
          const StatCardConfig(AppColors.delay, AppImage.unavailable),
      "Pending Request":
          const StatCardConfig(AppColors.preparing, AppImage.pending),
      "Approved Requests":
          const StatCardConfig(AppColors.ready, AppImage.approve_request),
    };

    final config = statConfigs[title]!;

    final bool isExpanded = expandedIndex == index;

    return SizedBox(
      width: 250,
      child: InkWell(
        onTap: () {
          if (index == 1 || index == 2) {
            setState(() {
              expandedIndex = expandedIndex == index ? null : index;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isExpanded ? config.color : AppColors.grey300,
              width: isExpanded ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Top colored line
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: config.color,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyle.poppinsSemiBold(
                              13,
                              color: config.color,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            value,
                            style: AppTextStyle.poppinsSemiBold(
                              15,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: SvgPicture.asset(
                          config.icon,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(int index) {
    final bool isUnavailable = index == 1;

    final List<String> items = isUnavailable
        ? [
            "Chicken Burger",
            "Veg Pizza",
            "Lime Juice",
            "Chicken Wings",
          ]
        : [
            "Chicken Burger - 12 Sep",
            "Veg Pizza - 12 Sep",
            "Lime Juice - 12 Sep",
            "Chicken Wings - 12 Sep",
          ];

    return Container(
      width: 280,
      constraints: const BoxConstraints(
        maxHeight: 200,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                isUnavailable
                    ? AppImage.unavailable // SVG for unavailable
                    : AppImage.pendingReq,
                width: 18, // same as your icon size
                height: 18,
                color: isUnavailable
                    ? Colors.red
                    : Colors.orange, // optional color
              ),
              const SizedBox(width: 8),
              Text(
                isUnavailable ? "Unavailable Items" : "Pending Request",
                style:
                    AppTextStyle.poppinsSemiBold(15, color: AppColors.grey400),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔹 Scrollable List
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.asMap().entries.map(
                  (entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "${entry.key + 1}. ${entry.value}",
                          style: AppTextStyle.poppinsMedium(15,
                              color: AppColors.textDark),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  final int flex;
  final TextAlign align;

  const _Header(
    this.text, {
    required this.flex,
    this.align = TextAlign.center, // default center
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: align,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.poppinsSemiBold(11),
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final int flex;
  final TextAlign align;
  final VoidCallback? onTap;

  final String? svgAsset;
  final Color? svgColor;
  final double svgSize;

  final double? indicatorValue;
  final double indicatorSize;

  const _Cell(
    this.text, {
    required this.flex,
    this.align = TextAlign.center,
    this.onTap,
    this.svgAsset,
    this.svgColor,
    this.svgSize = 14,
    this.indicatorValue,
    this.indicatorSize = 10,
  });

  Color? getStatusColor(String? status) {
    if (status == null) return null;

    switch (status.toLowerCase()) {
      case "available":
      case "approved":
        return Colors.green;

      case "pending":
      case "unavailable":
        return Colors.orange;

      default:
        return null; // no indicator for other text
    }
  }

  @override
  Widget build(BuildContext context) {
    final indicatorColor = getStatusColor(text);

    Widget content = Row(
      mainAxisAlignment: align == TextAlign.center
          ? MainAxisAlignment.center
          : align == TextAlign.end
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (indicatorColor != null) ...[
          Container(
            width: indicatorSize,
            height: indicatorSize,
            decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
        ],

        /// 🖼 SVG icon
        if (svgAsset != null) ...[
          SvgPicture.asset(
            svgAsset!,
            width: svgSize,
            height: svgSize,
            color: svgColor ?? AppColors.grey700,
          ),
          const SizedBox(width: 6),
        ],

        Flexible(
          child: Text(
            text,
            textAlign: align,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.poppinsRegular(11),
          ),
        ),
      ],
    );

    if (onTap != null) {
      content = InkWell(onTap: onTap, child: content);
    }

    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        alignment: align == TextAlign.start
            ? Alignment.centerLeft
            : align == TextAlign.end
                ? Alignment.centerRight
                : Alignment.center,
        child: content,
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
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
      child: TextField(
        onChanged: (value) {
          context.read<MenuAvailabilityProvider>().setSearch(value);
        },
        decoration: InputDecoration(
          hintText: 'Search by Item name, category name...',
          hintStyle:
              AppTextStyle.poppinsRegular(10).copyWith(color: Colors.grey),
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
