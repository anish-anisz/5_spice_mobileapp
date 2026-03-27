import 'package:cravia_kitchen/cors/app_image.dart';
import 'package:cravia_kitchen/cors/resonsiveness.dart';
import 'package:cravia_kitchen/screens/dash_board/dash_board_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../cors/app_colors.dart';
import '../../cors/app_text_style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/order_model.dart';
import '../../models/report_row_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/report_provider.dart';
import 'order_details_screen.dart';

class ReportDashboardScreen extends StatefulWidget {
  final bool showStats;
  final VoidCallback onToggleStats;
  final VoidCallback? onRowTap;
  ReportDashboardScreen(
      {super.key,
      this.onRowTap,
      required this.showStats,
      required this.onToggleStats});

  @override
  State<ReportDashboardScreen> createState() => _ReportDashboardScreenState();
}

class _ReportDashboardScreenState extends State<ReportDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsiveness(context);

    double screenWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_) => ReportProvider(),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<ReportProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: widget.showStats ? null : 0,
                      child: widget.showStats
                          ? Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                // _statCard("Total Orders", provider.totalOrders),
                                _statCard("Dine In", provider.dineIn),
                                _statCard("Take Away", provider.takeAway),
                                _statCard("Closed", provider.closed),
                                // _statCard("Customers in Queue", provider.queue),
                                _statCard(
                                    "Waiting Customers", provider.waitingCus),
                                _statCard(
                                    "Total Queue Closed", provider.totalQueue),
                                const SizedBox(height: 25),
                              ],
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(height: 10),

                    /// FILTER BAR
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
                              provider.selectedFilter == OrderFilter.all,
                              () => provider.setFilter(OrderFilter.all),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            _filterChip(
                              context,
                              "Dine In",
                              provider.selectedFilter == OrderFilter.dineIn,
                              () => provider.setFilter(OrderFilter.dineIn),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            _filterChip(
                              context,
                              "Take Away",
                              provider.selectedFilter == OrderFilter.takeAway,
                              () => provider.setFilter(OrderFilter.takeAway),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            _filterChip(
                              context,
                              "Queue",
                              provider.selectedFilter == OrderFilter.queue,
                              () => provider.setFilter(OrderFilter.queue),
                            ),
                            // const Spacer(),
                            // _iconButton(AppImage.calender, "Today"),
                            // const SizedBox(width: 8),
                            // _iconButton(AppImage.sort, "Sort By"),
                            // const SizedBox(width: 8),
                            // _iconButton(AppImage.export, "Export"),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SearchBar(),
                        ),
                        const SizedBox(width: 12),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            context
                                .read<ReportProvider>()
                                .selectDateRange(context);
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
                        PopupMenuButton<PaymentSort>(
                          color: AppColors.white,
                          onSelected: (value) {
                            context
                                .read<ReportProvider>()
                                .setPaymentSort(value);
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: PaymentSort.none,
                              child: Text(
                                "All Payments",
                                style: AppTextStyle.medium(15),
                              ),
                            ),
                            PopupMenuItem(
                              value: PaymentSort.paid,
                              child:
                                  Text("Paid", style: AppTextStyle.medium(15)),
                            ),
                            PopupMenuItem(
                              value: PaymentSort.pending,
                              child: Text("Pending",
                                  style: AppTextStyle.medium(15)),
                            ),
                            PopupMenuItem(
                              value: PaymentSort.dineIn,
                              child: Text("Dine In",
                                  style: AppTextStyle.medium(15)),
                            ),
                            PopupMenuItem(
                              value: PaymentSort.takeaway,
                              child: Text("Take Away",
                                  style: AppTextStyle.medium(15)),
                            ),
                          ],
                          child: _iconButton(AppImage.sort, "Sort By",
                              color: AppColors.grey700),
                        ),
                        const SizedBox(width: 8),
                        _iconButton(AppImage.export, "Export",
                            color: AppColors.primaryColor),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// TABLE HEADER
                    /// TABLE (HORIZONTAL SCROLL)
                    /* Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width:responsive.isTablet?1200:screenWidth * 0.85,
                        child: Column(
                          children: [
                            _tableHeader(),
                            const SizedBox(height: 6),

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
                                  return _tableRow(context,provider.rows[i], i + 1, onRowTap: onRowTap,);
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),*/
                    /// TABLE SECTION (OWN SCROLL)
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
                              responsive.isTablet ? 1200 : screenWidth * 0.85,
                          child: Column(
                            children: [
                              _tableHeader(),
                              const Divider(height: 1),

                              /// TABLE ROWS (vertical scroll)
                              Expanded(
                                child: provider.rows.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.inbox_outlined,
                                                size: 48,
                                                color: Colors.grey.shade400),
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
                                            onRowTap: widget.onRowTap,
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // const SizedBox(height: 6),
                    //
                    // /// TABLE BODY
                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: provider.rows.length,
                    //     itemBuilder: (_, i) {
                    //       return _tableRow(provider.rows[i], i + 1);
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

String orderStatusToText(OrderStatus status) {
  switch (status) {
    case OrderStatus.all:
      return 'All';

    case OrderStatus.newOrder:
      return 'New Order';

    case OrderStatus.preparing:
      return 'Preparing';

    case OrderStatus.ready:
      return 'Ready';

    case OrderStatus.delay:
      return 'Delayed';

    case OrderStatus.closed:
      return 'Cancelled';

    // case OrderStatus.queue:
    //   return 'Queue';
  }
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

Widget _statCard(String title, int value) {
  final statConfigs = {
    "Total Orders": StatCardConfig(Color(0xFFFF8A00), AppImage.totalOrder),
    "Dine In": StatCardConfig(Color(0xFFFFB300), AppImage.dineIn),
    "Take Away": StatCardConfig(Color(0xFF2979FF), AppImage.takeAway),
    "Closed": StatCardConfig(Color(0xFF00C853), AppImage.closed),
    "Customers in Queue":
        StatCardConfig(Color(0xFF7C4DFF), AppImage.customerInQueue),
    "Waiting Customers":
        StatCardConfig(Color(0xFFFF5252), AppImage.waitingCustomer),
    "Total Queue Closed":
        StatCardConfig(Color(0xFF00C853), AppImage.totalQueueClosed),
  };

  final config = statConfigs[title]!;

  return SizedBox(
    width: 250,
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
                      const SizedBox(height: 6),
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
  );
}

const List<int> _columnFlex = [
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
        _Header("KOT No", flex: _columnFlex[1]),
        _Header("Date", flex: _columnFlex[2]),
        _Header("Customer", flex: _columnFlex[2]),
        _Header("Order Type", flex: _columnFlex[9], align: TextAlign.center),
        _Header("Table No", flex: _columnFlex[5]),
        _Header("Items", flex: _columnFlex[6]),
        _Header("Amount", flex: _columnFlex[7]),
        _Header("Preparing Status",
            flex: _columnFlex[8], align: TextAlign.center),
        _Header("Payment Status",
            flex: _columnFlex[8], align: TextAlign.center),
        _Header("Order Status", flex: _columnFlex[9], align: TextAlign.center),
        _Header("Action", flex: _columnFlex[10], align: TextAlign.center),
      ],
    ),
  );
}

///
Widget _tableRow(
  BuildContext context,
  ReportRowModel row,
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
        _Cell(row.orderNo, flex: _columnFlex[1]),
        _Cell(DateFormat('dd-MM-yyyy').format(row.orderDate),
            flex: _columnFlex[2]),
        _Cell(row.customerName, flex: _columnFlex[1]),
        _badge(row.orderType, _orderTypeColor(row.orderType),
            flex: _columnFlex[9]),
        _Cell(
          row.orderType == "Take Away" ? "-----" : "Table 12",
          flex: _columnFlex[5],
        ),
        _Cell(row.items, flex: _columnFlex[6]),
        _Cell(row.amount, flex: _columnFlex[7]),
        _Cell(orderStatusToText(row.status), flex: _columnFlex[8]),
        _badge(row.payment, _paymentColor(row.payment), flex: _columnFlex[8]),
        _badge(
          "Active",
          AppColors.ready,
          flex: _columnFlex[9],
          iconWidget:
              SvgPicture.asset(AppImage.downArrow, color: AppColors.white),
          iconFirst: false,
        ),
        _badge("View", AppColors.background,
            flex: _columnFlex[10],
            borderColor: AppColors.primaryColor,
            onTap: onRowTap,
            iconColor: AppColors.primaryColor,
            iconSize: 20,
            iconWidget:
                SvgPicture.asset(AppImage.eye, color: AppColors.primaryColor))
      ],
    ),
  );
}

Color _paymentColor(String payment) {
  switch (payment.toLowerCase()) {
    case 'paid':
      return Colors.green;
    case 'unpaid':
      return AppColors.delay;
    default:
      return Colors.green;
  }
}

Color _orderTypeColor(String orderType) {
  switch (orderType.toLowerCase()) {
    case 'dine in':
    case 'dinein':
      return AppColors.preparing;
    case 'take away':
    case 'takeaway':
      return Colors.blue;
    default:
      return Colors.deepPurpleAccent;
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
  final IconData? icon;
  final Color? iconColor;
  final double iconSize;

  const _Cell(
    this.text, {
    required this.flex,
    this.align = TextAlign.center, // default center
    this.onTap,
    this.icon,
    this.iconColor,
    this.iconSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisAlignment: align == TextAlign.center
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: iconSize, color: iconColor),
          const SizedBox(width: 4),
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

Widget _badge(
  String text,
  Color color, {
  required int flex,
  Color? borderColor,
  double borderWidth = 1,
  VoidCallback? onTap,
  Widget? iconWidget, // icon or image widget
  bool iconFirst = true, // controls order
  Color iconColor = Colors.white,
  double iconSize = 10, // size for icon
  double width = 70, // optional fixed width
  double height = 22,
}) {
  Widget content = Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          border: borderColor != null
              ? Border.all(color: borderColor, width: borderWidth)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center, // ensures vertical centering
          children: iconFirst
              ? [
                  if (iconWidget != null) ...[
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child:
                          Center(child: iconWidget), // ensures icon is centered
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.poppinsSemiBold(8, color: iconColor),
                    ),
                  ),
                ]
              : [
                  Flexible(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.poppinsSemiBold(8, color: iconColor),
                    ),
                  ),
                  if (iconWidget != null) ...[
                    const SizedBox(width: 4),
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: Center(child: iconWidget),
                    ),
                  ],
                ],
        ),
      ),
    ),
  );

  return Expanded(
    flex: flex,
    child: Center(
      child: content,
    ),
  );
}

// Widget _badge(
//     String text,
//     Color color, {
//       required int flex,
//       Color? borderColor,
//       double borderWidth = 1,
//       VoidCallback? onTap,
//       IconData? icon,
//       Color iconColor = Colors.white,
//       double iconSize = 10,
//       double width = 70, // fixed width
//       double height = 20, // fixed height
//     }) {
//   Widget content = Container(
//     width: width,
//     height: height,
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     decoration: BoxDecoration(
//       color: color,
//       borderRadius: BorderRadius.circular(5),
//       border: borderColor != null
//           ? Border.all(color: borderColor, width: borderWidth)
//           : null,
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center, // center vertically
//       children: [
//         if (icon != null) ...[
//           Center(child: Icon(icon, size: iconSize, color: iconColor)),
//           const SizedBox(width: 4),
//         ],
//         Flexible(
//           child: Text(
//             text,
//             textAlign: TextAlign.center,
//             overflow: TextOverflow.ellipsis,
//             style: AppTextStyle.poppinsSemiBold(8, color: iconColor),
//           ),
//         ),
//       ],
//     ),
//   );
//
//   if (onTap != null) {
//     content = InkWell(
//       borderRadius: BorderRadius.circular(5),
//       onTap: onTap,
//       child: content,
//     );
//   }
//
//   return Expanded(
//     flex: flex,
//     child: Container(
//       alignment: Alignment.center,
//       child: content,
//     ),
//   );
// }

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
          context.read<ReportProvider>().setSearch(value);
        },
        decoration: InputDecoration(
          hintText: 'Search by customer name, order id...etc',
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

class StatCardConfig {
  final Color color;
  final String icon;
  const StatCardConfig(this.color, this.icon);
}
