import 'package:cravia_kitchen/screens/dash_board/report_dashboard_screen.dart';
import 'package:cravia_kitchen/screens/dash_board/sales_report_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../cors/app_colors.dart';
import '../../cors/app_image.dart';
import '../../cors/app_text_style.dart';
import 'menu_availability_screen.dart';
import 'order_details_screen.dart';




class ReportMainScreen extends StatefulWidget {
  const ReportMainScreen({super.key});

  @override
  State<ReportMainScreen> createState() => _ReportMainScreenState();
}

class _ReportMainScreenState extends State<ReportMainScreen> {
  int selectedIndex = 0;
  bool showOrderDetails = false;
  bool isSidebarOpen = true;

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }
  bool showStats = true;

  void toggleStats() {
    setState(() {
      showStats = !showStats;
    });
  }

  String get reportTitle {
    switch (selectedIndex) {
      case 0:
        return "ORDER &QUEUE REPORT";
      case 1:
        return "ITEM PERFORMANCE REPORT";
      case 2:
        return "MENU AVAILABILITY REPORT";
      default:
        return "Reports";
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /// 🔹 Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSidebarOpen ? 300 : 0,
            child: isSidebarOpen
                ? ReportSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  selectedIndex = index;
                  showOrderDetails = false;
                });
              },
              onToggleSidebar: toggleSidebar,
            )
                : const SizedBox(),
          ),

          if (isSidebarOpen)
            Container(width: 1, color: AppColors.grey300),

          /// 🔹 Content
          Expanded(
            child: Column(
              children: [
                if (!showOrderDetails)
                  _reportHeader(),
                Expanded(child: _buildReportScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _reportHeader() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.grey300),
        ),
      ),
      child: Row(
        children: [

          if (!isSidebarOpen)
            InkWell(
              onTap: toggleSidebar,
              borderRadius: BorderRadius.circular(20),
              child:Image.asset(
                AppImage.rightArrow, 
                height: 10,
                color: AppColors.textDark,
              ),
            ),

          if (!isSidebarOpen) const SizedBox(width: 12),


          Expanded(
            child: Text(
              reportTitle,
              style: AppTextStyle.poppinsSemiBold(
                18,
                color: AppColors.textDark,
              ),
            ),
          ),


          if (selectedIndex == 0 ||selectedIndex == 1 || selectedIndex == 2 )
            InkWell(
              onTap: toggleStats,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                turns: showStats ? 0 : 0.5,
                child: SvgPicture.asset(
                  AppImage.arrowDown,
                  height: 18,
                  width: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildReportScreen() {
    switch (selectedIndex) {
      case 0:
        return showOrderDetails
            ? OrderDetailsScreen(
          onBack: () {
            setState(() {
              showOrderDetails = false;
            });
          },
        )
            : ReportDashboardScreen(showStats: showStats, onToggleStats: toggleStats,
          onRowTap: () {
            setState(() {
              showOrderDetails = true;
            });
          },
        );
      case 1:
        return SalesReportScreen(showStats: showStats, onToggleStats: toggleStats,);
      case 2:
        return MenuAvailabilityScreen( showStats: showStats, onToggleStats: toggleStats,);
      default:
        return ReportDashboardScreen(showStats: showStats, onToggleStats: toggleStats);
    }
  }
}

class ReportSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onToggleSidebar;

  const ReportSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onToggleSidebar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          left: BorderSide(
            color: AppColors.grey300,
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(3, 0),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          /// 🔹 Sidebar Header with Toggle Arrow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                InkWell(
                  onTap: onToggleSidebar,
                  borderRadius: BorderRadius.circular(20),
                  child:Image.asset(
                   AppImage.leftArrow,
                    color: AppColors.textDark,
                    height: 10,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "All Reports",
                  style: AppTextStyle.poppinsSemiBold(
                    18,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _sidebarItem(
            svgPath: AppImage.queueReport,
            title: "Order & Queue Report",
            index: 0,
          ),
          _sidebarItem(
            svgPath: AppImage.orders,
            title: "Item Performance Report",
            index: 1,
          ),
          _sidebarItem(
            svgPath: AppImage.menuAvailable,
            title: "Menu Availability",
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem({
    required String svgPath,
    required String title,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onItemSelected(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              svgPath,
              width: 25,
              height: 25,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : AppColors.textDark,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTextStyle.medium(
                14,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


