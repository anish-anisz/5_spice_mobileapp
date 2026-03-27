import 'package:cravia_kitchen/screens/dash_board/report_dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../cors/app_colors.dart';
import '../../cors/app_image.dart';
import '../../cors/app_text_style.dart';
import '../../cors/resonsiveness.dart';
import '../../models/sales_report_model.dart';
import '../../providers/report_provider.dart';
import '../../providers/sales_report_provider.dart';

class SalesReportScreen extends StatefulWidget {
  final bool showStats;
  final VoidCallback onToggleStats;
  const SalesReportScreen({super.key,required this.showStats,   required this.onToggleStats,});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  int? expandedIndex;
  @override

  Widget build(BuildContext context) {

    final responsive = Responsiveness(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_) => SalesReportProvider(),
      child: Scaffold(
        body: Consumer<SalesReportProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [
                Container(
                  color: Colors.white,
                ),
             SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: widget.showStats ? null : 0,
                      child: widget.showStats
                          ? Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _statCard("Total Items Prepared","",  "${provider.totalItems} items",0),
                          _statCard("Top Sold Item","Chicken Burger", "${provider.soldItem}",1),
                          _statCard("Slowest Item","Mutton Pizza", "${provider.slowestItem} Sold",2),
                          _statCard("Items Causing Delays", "", "${provider.itemsCausingDelay} Sold",3),
                        ],
                      ) : const SizedBox(),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: SearchBar(),
                        ),
                        const SizedBox(width: 12),

                        InkWell(
                          onTap: () {
                            context.read<ReportProvider>().selectDateRange(context);
                          },
                          onLongPress: () {
                            context.read<ReportProvider>().clearDateRange();
                          },
                          child: _iconButton(
                            AppImage.calender,
                            context.watch<ReportProvider>().fromDate == null
                                ? "Select Date"
                                : "${DateFormat('dd MMM').format(context.watch<ReportProvider>().fromDate!)}"
                                " - "
                                "${DateFormat('dd MMM yyyy').format(context.watch<ReportProvider>().toDate!)}",
                            color: Colors.black
                          ),
                        ),



                        const SizedBox(width: 8),
                        PopupMenuButton<SalesSortType>(
                          color: AppColors.white,
                          onSelected: (value) {
                            context.read<SalesReportProvider>().setSort(value);
                          },
                          itemBuilder: (_) =>  [
                            PopupMenuItem(
                              value: SalesSortType.quantityHighToLow,
                              child: Text("Quantity Sold (High → Low),",style: AppTextStyle.medium(15)),
                            ),
                            PopupMenuItem(
                              value: SalesSortType.avgPrepFastToSlow,
                              child: Text("Avg Prep Time (Fast → Slow)",style: AppTextStyle.medium(15)),
                            ),
                            PopupMenuItem(
                              value: SalesSortType.delayHighToLow,
                              child: Text("Delay Count (High → Low)",style: AppTextStyle.medium(15)),
                            ),
                          ],
                          child: _iconButton(AppImage.sort, "Sort By", color: AppColors.grey700),
                        ),

                        const SizedBox(width: 8),
                        _iconButton(AppImage.export, "Export",color: AppColors.primaryColor),

                      ],
                    ),
                    const SizedBox(height: 12),
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
                          width: responsive.isTablet ? 1200 : screenWidth * 0.68,
                          child: Column(
                            children: [
                              _tableHeader(),

                              Expanded(
                                child: provider.rows.isEmpty
                                    ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.inbox_outlined,
                                          size: 48, color: Colors.grey.shade400),
                                      const SizedBox(height: 8),
                                      Text(
                                        "No data found",
                                        style: AppTextStyle.poppinsMedium(
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
                                     // onRowTap: onRowTap,
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
                if (expandedIndex == 3)
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
                                width: 300,
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
            ]
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpandedContent(int index) {
    final bool isUnavailable = index == 1;

    final List<String> items =
       [
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
               AppImage.delay,
                width: 18,
                height: 18,

              ),
              const SizedBox(width: 8),
              Text("Items Causing Delays",

                style: AppTextStyle.poppinsSemiBold(
                    15,
                    color:AppColors.grey400
                ),
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
                      padding:
                      const EdgeInsets.symmetric(vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "${entry.key + 1}. ${entry.value}",
                          style: AppTextStyle.poppinsMedium(15,color: AppColors.textDark),

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
  Widget _tableRow(
      BuildContext context,
      SalesItemReportModel row,
      int index, {
        VoidCallback? onRowTap,
      }) {
    return Container(
      padding:  const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _Cell(index.toString(), flex: _columnFlex[0]),
          _Cell(row.itemName, flex: _columnFlex[1]),
          _Cell(row.category, flex: _columnFlex[1]),
          _Cell(row.quantitySold.toStringAsFixed(0), flex: _columnFlex[1]),
          _Cell('${row.avgPrepTime.toStringAsFixed(1)} mins',
              flex: _columnFlex[1],indicatorValue: row.avgPrepTime,),

          _Cell('${row.maxPrepTime.toStringAsFixed(0)} mins',
              flex: _columnFlex[1], svgAsset: AppImage.clock, // SVG path
            svgColor: Colors.green,),

          _Cell(row.delayCount.toString(),
              flex: _columnFlex[1],indicatorValue:  row.delayCount.toDouble(),),


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
      decoration: BoxDecoration(
        color: AppColors.tableHeader,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          _Header("S.No", flex: _columnFlex[0]),
          _Header("Item Name", flex: _columnFlex[1]),
          _Header("Category", flex: _columnFlex[1]),
          _Header("Quantity Sold", flex: _columnFlex[1]),
          _Header("Avg Prep Time", flex: _columnFlex[1]),
          _Header("Max Prep Time", flex: _columnFlex[1], align: TextAlign.center),
          _Header("Delay Count", flex: _columnFlex[1]),
        ],
      ),
    );
  }


  Widget _statCard(String title,String subTitle, String value,int index,
      ) {
    final statConfigs = {
      "Total Items Prepared": StatCardConfig(Color(0xFFFF8A00), AppImage.itemPrepared),
      "Top Sold Item": StatCardConfig(Color(0xFF2979FF), AppImage.soldItem),
      "Slowest Item": StatCardConfig(Color(0xFFFFB300),AppImage.slowestItem),
      "Items Causing Delays": StatCardConfig(AppColors.delay, AppImage.causingDelay),
    };

    final config = statConfigs[title]!;
    final bool isExpanded = expandedIndex == index;
    return SizedBox(
      width: 250,
      child: GestureDetector(
        onTap: () {
          if (index == 3) {
            setState(() {
              expandedIndex = expandedIndex == index ? null : index;
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grey300),
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
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
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
                          const SizedBox(height: 3),
                          Text(
                            subTitle,
                            style: AppTextStyle.poppinsMedium(
                              10,
                              color:AppColors.grey
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            value.toString(),
                            style: AppTextStyle.poppinsSemiBold(
                              20,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),


                    Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: SvgPicture.asset(
                          config.icon,
                          height: 50,
                          width: 50,

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

  /// SVG
  final String? svgAsset;
  final Color? svgColor;
  final double svgSize;

  /// Circle indicator
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
        this.indicatorSize = 15,
      });

  Color? _getIndicatorColor() {
    if (indicatorValue == null) return null;

    if (indicatorValue! < 5) {
      return Colors.green;
    } else if (indicatorValue! <= 10) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final indicatorColor = _getIndicatorColor();

    Widget content = Row(
      mainAxisAlignment: align == TextAlign.center
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        if (indicatorColor != null) ...[
          Container(
            width: indicatorSize,
            height: indicatorSize,
            decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: indicatorColor,
                width: 1,
              ),
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
            color: AppColors.grey700,
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
        alignment: Alignment.center,
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
          context.read<SalesReportProvider>().setSearch(value);

        },
        decoration: InputDecoration(
          hintText: 'Search by Item name, Category name...',
          hintStyle: AppTextStyle.poppinsRegular(10)
              .copyWith(color: Colors.grey),
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