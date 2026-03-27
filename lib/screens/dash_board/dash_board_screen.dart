import 'package:cravia_kitchen/cors/app_image.dart';
import 'package:cravia_kitchen/screens/dash_board/report_dashboard_screen.dart';
import 'package:cravia_kitchen/screens/dash_board/report_main_screen.dart';
import 'package:cravia_kitchen/screens/dash_board/time_slot_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../cors/app_colors.dart';
import '../../cors/app_text_style.dart';
import '../../cors/resonsiveness.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../widgets/order_card.dart';
import '../../widgets/status_tab.dart';
import 'menu_dashboard_screen.dart';
enum DashboardPage {
  orders,
  menu,
  report,
}

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  DashboardPage selectedPage = DashboardPage.orders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.25),
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.white,
          title: Image.asset(
            AppImage.logo,
           fit: BoxFit.contain,
           // fit: BoxFit.fitHeight,
            height: 60,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [

                  Image.asset(
                    AppImage.calender,
                    // fit: BoxFit.fitHeight,
                  ),

                  const SizedBox(width: 8),

                  /// Date & Time Column
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Date
                      Text(
                        _formattedDate(),
                        style: AppTextStyle.poppinsMedium(12
                        ),
                      ),

                      /// Time (Next line)
                      Text(
                        _formattedTime(),
                        style: AppTextStyle.poppinsMedium(12
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),



      body: Row(
        children: [
          SideBar(
            selectedPage: selectedPage,
            onPageChanged: (page) {
              setState(() {
                selectedPage = page;
              });
            },
          ),

          // RIGHT SIDE
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _buildContent(),
                ),
                Visibility(
                  visible: selectedPage == DashboardPage.orders,
                  child: const TimeSlotBottomBar(),
                )
              ],
            ),
          ),
        ],
      ),
    );

  }

  String _formattedDate() {
    final now = DateTime.now();
    const days = [
      'Monday,',
      'Tuesday,',
      'Wednesday,',
      'Thursday,',
      'Friday,',
      'Saturday,',
      'Sunday,'
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return "${days[now.weekday - 1]} "
        "${now.day} "
        "${months[now.month - 1]}";
  }

  String _formattedTime() {
    final now = DateTime.now();

    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';

    return "$hour:$minute $period";
  }



  Widget _buildContent() {
    switch (selectedPage) {
      case DashboardPage.orders:
        return const OrdersDashboardScreen();
      case DashboardPage.menu:
        return const MenuDashboardScreen();
      case DashboardPage.report:
       //
      //return  ReportDashboardScreen();
        return  const ReportMainScreen();
    }
  }
}
extension OrderStatusColor on OrderStatus {
  Color get color {
    switch (this) {
      case OrderStatus.newOrder:
        return AppColors.primaryColor;
      case OrderStatus.preparing:
        return AppColors.preparing;
      case OrderStatus.ready:
        return  AppColors.ready;
      case OrderStatus.closed:
        return Colors.grey;
      case OrderStatus.delay:
        return Colors.red;
      // case OrderStatus.queue:
      //   return Colors.blue;
      case OrderStatus.all:
        return Colors.black;
    }
  }
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.all:
        return 'All';
      case OrderStatus.newOrder:
        return 'New Order';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Completed';
      case OrderStatus.closed:
        return 'Closed';
      case OrderStatus.delay:
        return 'Delayed';
      // case OrderStatus.queue:
      //   return ' ';
    }
  }
}

class OrdersDashboardScreen extends StatelessWidget {
  const OrdersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // STATUS BAR
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    statusTab("All Orders", OrderStatus.all, provider),
                    const SizedBox(width: 8),
                    statusTab("New Orders", OrderStatus.newOrder, provider),
                    const SizedBox(width: 8),
                    statusTab("Preparing", OrderStatus.preparing, provider),
                    const SizedBox(width: 8),
                    statusTab("Closed Orders", OrderStatus.ready, provider),
                    const SizedBox(width: 8),
                    statusTab("Delay", OrderStatus.delay, provider),
                    // const SizedBox(width: 8),
                    // statusTab("Queue", OrderStatus.queue, provider),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // GRID
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    int crossAxisCount;
                    if (width >= 1400) {
                      crossAxisCount = 5;
                    } else if (width >= 1100) {
                      crossAxisCount = 4;
                    } else if (width >= 800) {
                      crossAxisCount = 3;
                    } else {
                      crossAxisCount = 2;
                    }

                    return MasonryGridView.builder(
                      itemCount: provider.filteredOrders.length,
                      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                      ),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemBuilder: (_, i) {
                        return OrderCard(
                          order: provider.filteredOrders[i],
                        );
                      },
                    );
                  },
                ),
              ),


            ],
          );
        },
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  final DashboardPage selectedPage;
  final ValueChanged<DashboardPage> onPageChanged;

  const SideBar({
    super.key,
    required this.selectedPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsiveness.sidebarWidth(context),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(3, 0),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      //color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),

          _menuItem(
            
            label: "Orders",
            iconPath: AppImage.order,
            active: selectedPage == DashboardPage.orders,
            onTap: () => onPageChanged(DashboardPage.orders), context: context,
          ),

          const SizedBox(height: 20),

          _menuItem(
            label: "Menu",
            iconPath: AppImage.list,
            active: selectedPage == DashboardPage.menu,
            onTap: () => onPageChanged(DashboardPage.menu), context: context,
          ),
          const SizedBox(height: 20),
          _menuItem(
            context: context,
            label: "Report",
            iconPath: AppImage.report,
            active: selectedPage == DashboardPage.report,
            onTap: () => onPageChanged(DashboardPage.report),
          ),

        ],
      ),
    );
  }

  Widget _menuItem({
    required BuildContext context,
    required String iconPath,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.secondary.withOpacity(0.4)
                  : AppColors.grey300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              iconPath,
              height: Responsiveness.menuIconSize(context),
              width: Responsiveness.menuIconSize(context),
              color: active ? AppColors.primaryColor : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyle.poppinsSemiBold(
              15,
              color: active ? AppColors.secondary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}


