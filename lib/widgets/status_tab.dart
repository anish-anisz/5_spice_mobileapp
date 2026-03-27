import 'package:cravia_kitchen/cors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cors/app_text_style.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';

Widget statusTab(
    String title,
    OrderStatus status,
    OrderProvider provider,
    ) {
  final selected = provider.selectedStatus == status;
  final count = provider.count(status);

  return InkWell(
    onTap: () => provider.changeTab(status),
    borderRadius: BorderRadius.circular(90),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? status.color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected
              ? status.color
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          Text(
            title,
            style: AppTextStyle.poppinsMedium(
              13,
              color: selected ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(width: 8),

          /// Count badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? Colors.white : Colors.grey.shade200,
            ),
            child: Text(
              count.toString(),
              style: AppTextStyle.poppinsMedium(
                11,
                color: selected
                    ? status.color
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    ),
  );
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
        return AppColors.primaryColor;
    }
  }}
