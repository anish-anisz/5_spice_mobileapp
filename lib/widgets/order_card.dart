import 'package:cravia_kitchen/cors/app_colors.dart';
import 'package:cravia_kitchen/cors/app_image.dart';
import 'package:cravia_kitchen/screens/dash_board/dash_board_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../cors/app_text_style.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderProductModel order;
  const OrderCard({super.key, required this.order});
  bool isLessThanTenMinutes(DateTime orderTime, Duration preparingTime) {
    final endTime = orderTime.add(preparingTime);
    final remaining = endTime.difference(DateTime.now());

    return remaining.inMinutes <= 10;
  }

  @override
  Widget build(BuildContext context) {
    print(order.status);
    final provider = context.read<OrderProvider>();
    final orderDate = DateTime(2015, 12, 12);
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor(order.status),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                /// LEFT CONTENT → FLEXIBLE
                Expanded(
                  child: Row(
                    children: [
                      /// ORDER NO
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "KOT No",
                              style: AppTextStyle.poppinsMedium(
                                8,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              order.orderNo.replaceAll("ORD-", ""),
                              style: AppTextStyle.poppinsSemiBold(
                                12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      /// ORDER DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.orderType,
                              style: AppTextStyle.poppinsSemiBold(
                                12,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Order ID: ${order.orderNo}",
                              style: AppTextStyle.poppinsRegular(
                                8,
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              order.status == OrderStatus.ready
                                  ? "Ordered On 4:00 PM\nClosed on 5:00 PM"
                                  : "Ordered On 4:00 PM",
                              style: AppTextStyle.poppinsRegular(
                                8,
                                color: Colors.white70,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),


                /// RIGHT TIME → FIXED SIZE
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLessThanTenMinutes(order.time, order.preparingTime)
                        ? Color(0xFFF60303)
                        : AppColors.grey300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppImage.clock,
                        width: 15,
                        height: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatPreparingEndTime(
                          order.time,
                          order.preparingTime,
                        ),
                        style: AppTextStyle.poppinsMedium(
                          11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT → STATUS + TABLE (fixed)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: order.status.color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        order.status.label,
                        style: AppTextStyle.poppinsMedium(
                          11,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    if (order.orderType == "Dine In")
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.grey700,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Table 12",
                          style: AppTextStyle.poppinsMedium(
                            11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 10),

                /// RIGHT → CUSTOMER NAME (wraps downward only here)
                Expanded(
                  child: Text(
                    "${order.customerName} | ${order.phoneNumber}",
                    textAlign: TextAlign.right,
                   // maxLines: 3,
                   // overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.poppinsRegular(
                      10,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),


          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length + 1,
              separatorBuilder: (_, index) {
                // Divider only between order items
                if (index < order.items.length - 1) {
                  return const Divider(height: 24);
                }
                return const SizedBox.shrink();
              },
              itemBuilder: (context, index) {

                if (index == order.items.length) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 24),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Add-ons : ",
                              style: AppTextStyle.poppinsMedium(13,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  "Extra Cheese (10 gm), Mayonnaise (10 gm), Spicy Sauce (10 gm)",
                              style: AppTextStyle.poppinsRegular(10,
                                  color: AppColors.grey700),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
                /*     if (index == order.items.length) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Divider(height: 24),
                      Text(
                        "Add-ons : Extra Cheese (10 gm), Mayonnaise (10 gm), Spicy Sauce (10 gm)",
                        style: AppTextStyle.poppinsRegular(
                           11,
                          color: AppColors.grey700,
                        ),
                      ),
                    ],
                  );
                }*/

                final item = order.items[index];

                // return Row(
                //   children: [
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             "${item.qty} × ${item.name}",
                //             style: AppTextStyle.poppinsMedium(
                //               14,
                //               color: Colors.black,
                //             ),
                //           ),
                //           const SizedBox(height: 6),
                //           Text(
                //             "Size : ${item.size}",
                //             style: AppTextStyle.poppinsRegular(
                //               11,
                //               color: Colors.black87,
                //             ),
                //           ),
                //           const SizedBox(height: 4),
                //           Text(
                //             "Spice Level : Large",
                //             style: AppTextStyle.poppinsRegular(
                //               11,
                //               color: Colors.red,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     if (order.status != OrderStatus.ready &&
                //         order.status != OrderStatus.newOrder &&
                //         order.status != OrderStatus.delay)
                //       Checkbox(
                //         value: item.isChecked,
                //         activeColor: AppColors.ready,
                //         onChanged: (value) {
                //           provider.toggleItemCheck(
                //             order,
                //             index,
                //             value ?? false,
                //           );
                //         },
                //       ),
                //
                //   ],
                // );
                return Stack(
                  alignment: Alignment.center,
                  children: [

                    Opacity(
                      opacity: item.isChecked ? 0.4 : 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "${item.qty} × ${item.name}",
                                  style: AppTextStyle.poppinsMedium(
                                    14,
                                    color: item.isChecked
                                        ? AppColors.grey700
                                        : Colors.black,
                                  ).copyWith(
                                    decoration: item.isChecked
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "Size : ${item.size}",
                                  style: AppTextStyle.poppinsRegular(
                                    11,
                                    color: item.isChecked
                                        ? AppColors.grey700
                                        : Colors.black87,
                                  ).copyWith(
                                    decoration: item.isChecked
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "Spice Level : Large",
                                  style: AppTextStyle.poppinsRegular(
                                    11,
                                    color: item.isChecked
                                        ? AppColors.grey700
                                        : Colors.red,
                                  ).copyWith(
                                    decoration: item.isChecked
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (order.status != OrderStatus.ready &&
                              order.status != OrderStatus.newOrder &&
                              order.status != OrderStatus.delay)
                            Checkbox(
                              value: item.isChecked,
                              activeColor: AppColors.ready,
                              onChanged: (value) {
                                provider.toggleItemCheck(
                                  order,
                                  index,
                                  value ?? false,
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // const SizedBox(height: 8),
          if (order.status != OrderStatus.ready &&
              order.status != OrderStatus.newOrder &&
              order.status != OrderStatus.delay)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.grey300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LABEL
                  Text(
                    "Packed by",
                    style: AppTextStyle.poppinsRegular(
                      10,
                      color: AppColors.textDark,
                    ),
                  ),

                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: provider.selectedPackedBy,
                      isExpanded: true,
                      isDense: true,
                      icon: Image.asset(AppImage.arrow, scale: 10),
                      items: provider.packers.map((name) {
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(
                            name,
                            style: AppTextStyle.poppinsRegular(
                              13,
                              color: AppColors.textDark,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        provider.setPackedBy(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          Visibility(
            visible: order.status == OrderStatus.ready ||
                order.status == OrderStatus.delay,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("Packed by : Sreya", style: AppTextStyle.medium(12)),
              ]),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
            child: _actionButton(context, provider),
          ),
        ],
      ),
    );
  }

  String formatPreparingEndTime(
    DateTime orderTime,
    Duration preparingTime,
  ) {
    final endTime = orderTime.add(preparingTime);

    final hours = endTime.hour.toString().padLeft(2, '0');
    final minutes = endTime.minute.toString().padLeft(2, '0');

    return "$hours:$minutes";
  }

  String statusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.newOrder:
        return "New Order";
      case OrderStatus.preparing:
        return "Preparing";
      case OrderStatus.ready:
        return "Ready";
      case OrderStatus.closed:
        return "Completed";
      case OrderStatus.delay:
        return "Delayed";
      default:
        return "";
    }
  }

  Widget? _actionButton(BuildContext context, OrderProvider provider) {
    switch (order.status) {
      case OrderStatus.newOrder:
        return _statusButton(
          text: "Start Preparing",
          status: OrderStatus.newOrder,
          onTap: () => provider.updateOrderStatusWithValidation(
            context,
            order,
            OrderStatus.preparing,
          ),
        );

      case OrderStatus.preparing:
        return _statusButton(
          text: "Close Order",
          status: OrderStatus.preparing,
          onTap: () => provider.updateOrderStatusWithValidation(
            context,
            order,
            OrderStatus.ready,
          ),
        );
      case OrderStatus.delay:
        return _statusButton(
          text: "Start Preparing",
          status: OrderStatus.delay,
          onTap: () => provider.updateOrderStatusWithValidation(
            context,
            order,
            OrderStatus.preparing,
          ),
        );
      // case OrderStatus.queue:
      //   return _statusButton(
      //     text: "Start Preparing",
      //     status: OrderStatus.queue, onTap: () {  },
      //     // onTap: () => provider.updateOrderStatusWithValidation(
      //     //   context,
      //     //   order,
      //     //   OrderStatus.preparing,
      //     // ),
      //   );
      default:
        return null;
    }
  }

  Color statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.newOrder:
        return AppColors.primaryColor;
      case OrderStatus.preparing:
        return AppColors.preparing;
      case OrderStatus.ready:
        return AppColors.ready;
      case OrderStatus.closed:
        return Colors.grey;
      case OrderStatus.delay:
        return Colors.red;
      // case OrderStatus.queue:
      //   return Colors.blue;

      default:
        return Colors.blue;
    }
  }

  Color statusButtonColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.all:
        return Colors.black;
      case OrderStatus.newOrder:
        return AppColors.primaryColor;
      case OrderStatus.preparing:
        return AppColors.preparing;
      case OrderStatus.ready:
        return AppColors.ready;
      case OrderStatus.closed:
        return Colors.grey;
      case OrderStatus.delay:
        return Colors.red;
      // case OrderStatus.queue:
      //   return Colors.grey;
    }
  }




  Widget _statusButton({
    required String text,
    required OrderStatus status,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: statusButtonColor(status),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyle.poppinsMedium(
            14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _btn(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onTap, child: Text(text)),
    );
  }
}
