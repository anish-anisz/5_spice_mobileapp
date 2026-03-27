import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cors/app_colors.dart';
import '../../cors/app_image.dart';
import '../../cors/app_text_style.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/report_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/dashed_divider.dart';


class OrderDetailsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const OrderDetailsScreen({super.key, this.onBack});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();


  static Widget _infoRow(
      String label,
      String value, {
        Color labelColor = AppColors.grey600 // default color
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.regular(13, color: labelColor),
          ),
          Text(
            value,
            style: AppTextStyle.regular(13, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }


  /// TOTAL ROW
  static Widget _totalRow(String label,
      double value, {
        bool bold = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: bold
                ? AppTextStyle.poppinsMedium(13)
                : AppTextStyle.regular(13, color: AppColors.grey600),
          ),
          Text(
            '₹ ${value.toStringAsFixed(2)}',
            style: bold
                ? AppTextStyle.poppinsMedium(13)
                : AppTextStyle.regular(13, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
      create: (_) => OrderProvider(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Consumer<OrderProvider>(
          builder: (_, provider, __) {
            final order = provider.order;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Order Details',
                                style: AppTextStyle.poppinsMedium(16),
                              ),
                              Spacer(),
                              BackButtonCustom(
                                label: 'Back',
                                onPressed: widget.onBack,
                                backgroundColor: Colors.white,
                                textColor: AppColors.textDark,
                                borderColor: AppColors.textDark,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _header(order,context),
                          const SizedBox(height: 12),
                          _orderCard(order),
                          const SizedBox(height: 12),
                          _summaryBar(order),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header(OrderModel order,BuildContext context) {
    String? selectedTimeline;
    final timelineItems = [
      'Ordered At: 12:30 PM',
      'KOT Sent At: 12:31 PM',
      'Prepared At: 12:55 PM',
      'Served At: 12:58 PM',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16), // inner spacing
          decoration: BoxDecoration(
            color: Colors.white, // background color
            border: Border.all(
              color: Colors.grey.shade300, // border color
              width: 1, // border width
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Order Id #${order.orderId} ',
                      style: AppTextStyle.poppinsSemiBold(16)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'KOT - 012',
                      style: AppTextStyle.medium(16)
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Chips
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _chip('Dine In', AppColors.primaryColor),
                      const SizedBox(width: 8),
                      _chip(order.table, Colors.purple),
                      const SizedBox(width: 8),
                      _chip('Paid', Colors.green.shade300),
                    ],
                  ),
                ),
              ),

              // Right side: Ordered On Time + Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ordered On 4:30 PM',
                    style: AppTextStyle.poppinsMedium(14)
                        .copyWith(color:AppColors.textDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                   "4/12/2025", // make sure your OrderModel has a date field
                    style: AppTextStyle.poppinsRegular(12)
                        .copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),


        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Customer info
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.person, size: 18),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sreya M R',
                      style: AppTextStyle.poppinsMedium(14),
                    ),
                    Text(
                      '7025906158',
                      style: AppTextStyle.poppinsRegular(12)
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(width: 40),

            // Middle controls
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Kitchen status (label + dropdown)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kitchen Status',
                        style: AppTextStyle.poppinsMedium(13)
                            .copyWith(color: AppColors.textDark),
                      ),
                      const SizedBox(height: 4),
                      _dropdown2(
                        value: 'Preparing',
                        items: const ['Preparing', 'Ready', 'Delayed'],
                        onChanged: (v) {},
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  Padding(
                    padding:  const EdgeInsets.only(top:22.0),
                    child: _orderTimelineContainer(
                      context: context,
                      selectedValue: selectedTimeline,
                      items: timelineItems,
                      onSelected: (value) {
                        setState(() {
                          selectedTimeline = value;
                        });
                      },
                    ),
                  ),

                ],
              ),
            ),

            // Right buttons
            Padding(
              padding: const EdgeInsets.only(right: 8.0,top: 12),
              child: Row(
                children: [
                  _iconButton(icon:Icons.share,text: 'Share'),
                  const SizedBox(width: 8),
                  _iconButton(svgPath: AppImage.print, text:'Print'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _orderTimelineContainer({
    required BuildContext context,
    String? selectedValue,
    required List<String> items,
    required ValueChanged<String> onSelected,
  }) {
    return PopupMenuButton<String>(
      color: Colors.white,
      onSelected: onSelected,
      offset: const Offset(0, 60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),

      itemBuilder: (_) {
        final menuItems = <PopupMenuEntry<String>>[];

        /// 🔹 Normal timeline items
        for (final e in items) {
          final index = e.indexOf(':');
          final label = index != -1 ? e.substring(0, index).trim() : e;
          final value = index != -1 ? e.substring(index + 1).trim() : '';

          menuItems.add(
            PopupMenuItem<String>(
              height: 36,
              value: e,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: AppTextStyle.poppinsMedium(13),
                  ),
                  Text(
                    value,
                    style: AppTextStyle.poppinsMedium(13)
                        .copyWith(color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
          );
        }
        menuItems.add(
          PopupMenuItem<String>(
            enabled: false,
            value: 'total_prep_time',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Prep Time',
                  style: AppTextStyle.poppinsSemiBold(13),
                ),
                SizedBox(width: 8,),
                Text(
                  '25 mins',
                  style: AppTextStyle.poppinsMedium(13)
                      .copyWith(color: Colors.green),
                ),
              ],
            ),
          ),
        );

        return menuItems;
      },

      /// 🔹 Button UI
      child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.schedule, size: 16, color: AppColors.blue),
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 160),
                child: Text(
                  selectedValue ?? 'Order Timeline',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextStyle.poppinsRegular(12),
                ),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(
                AppImage.downArrow,
                width: 15,
                height: 15,
                 color: Colors.grey.shade800,
              ),
            ],
          ),
        ),

    );
  }


  Widget _orderCard(OrderModel order) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "#9307544",
              style: AppTextStyle.poppinsMedium(13,color: AppColors.blue),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Cravia - Tech Meets Taste",
              style: AppTextStyle.poppinsMedium(13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),// Make product list scrollable if too long
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: order.items.length,
                itemBuilder: (_, index) => _productRow(order.items[index]),
              ),
            ),
            const SizedBox(height: 15,),
            const DashedDivider(color: Colors.grey),
            const SizedBox(height: 15,),
            OrderDetailsScreen._infoRow('Coupon Code', 'Not Applied',labelColor: AppColors.blue),
            const SizedBox(height: 15,),
            const DashedDivider(color: Colors.grey),
            const SizedBox(height: 15,),
            OrderDetailsScreen._infoRow('Reward Points', 'Not Used'),
            const SizedBox(height: 15,),
            const DashedDivider(color: Colors.grey),
            const SizedBox(height: 15,),
            OrderDetailsScreen._totalRow('Subtotal', order.subTotal),
            OrderDetailsScreen._totalRow('Estimated Tax (5%)', order.gst),
            const SizedBox(height: 15,),
            const Divider(thickness: 2,color: AppColors.grey400,),
            const SizedBox(height: 15,),
            OrderDetailsScreen._totalRow('Total', order.total, bold: true),
          ],
        ),
      ),
    );
  }

  Widget _productRow(ProductModel item) {
    double total = item.qty * item.price;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(

                  'https://images.unsplash.com/photo-1601924578600-5e44b9fae6c2?auto=format&fit=crop&w=48&q=80',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 48,
                  height: 48,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 24, color: Colors.white),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          // Product Name
          Expanded(
            child: Text(
              item.name,
              style: AppTextStyle.poppinsMedium(13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 12),

          // Qty × Price
          Text(
            'Qty: ${item.qty} × ${item.price.toStringAsFixed(2)}',
            style: AppTextStyle.regular(12).copyWith(color: Colors.grey[700]),
          ),

         Spacer(),

          // Total Price
          Text(
            '₹ ${total.toStringAsFixed(2)}',
            style: AppTextStyle.medium(12),
          ),
        ],
      ),
    );
  }


  Widget _dropdown2({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      width: 180,
      height: 36,
      child: DropdownButton2<String>(
        value: value,
        isExpanded: true,
        items: items
            .map(
              (e) => DropdownMenuItem<String>(
            value: e,
            child: Text(
              e,
              style: AppTextStyle.poppinsRegular(13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
            .toList(),
        onChanged: onChanged,


        buttonStyleData: ButtonStyleData(
          height: 36,
          padding: const EdgeInsets.only(left: 2, right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black54),
          ),
        ),


        iconStyleData: IconStyleData(
          icon: SvgPicture.asset(
            AppImage.downArrow,
            width: 15,
            height: 15,
          color: AppColors.textDark,
          ),
          iconSize: 12,
          iconEnabledColor: AppColors.textDark,
        ),


        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),

        underline: const SizedBox(),
      ),
    );
  }


  Widget _summaryBar(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // background color
        borderRadius: BorderRadius.circular(5),

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Items: ${order.items.length}',
            style: AppTextStyle.semiBold(13, color: AppColors.textDark),
          ),
          Text(
            'Subtotal: ₹${order.subTotal}',
            style: AppTextStyle.semiBold(13, color: AppColors.textDark),
          ),
          Text(
            'GST(5%): ₹${order.gst}',
            style: AppTextStyle.semiBold(13, color: AppColors.textDark),
          ),
          Text(
            'Total: ₹${order.total}',
            style: AppTextStyle.semiBold(13, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  Widget _timelineCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Timeline',
                style: AppTextStyle.poppinsMedium(14)),
            const SizedBox(height: 12),
            _timelineRow('Ordered At', '12:30 PM'),
            _timelineRow('KOT Sent', '12:31 PM'),
            _timelineRow('Prepared At', '12:55 PM'),
            _timelineRow('Served At', '12:58 PM'),
            const Divider(),
            Text('Total Prep Time: 25 mins',
                style: AppTextStyle.medium(12)),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          text,
            textAlign: TextAlign.center,
          style: AppTextStyle.poppinsMedium(13,color: AppColors.white)
        ),
      ),
    );
  }

  Widget _iconButton({
    IconData? icon,
    String? svgPath,
    required String text,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 110,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// If SVG provided
            if (svgPath != null)
              SvgPicture.asset(
                svgPath,
                height: 16,
                width: 16,
                color: Colors.white,
              )

            /// Else if Icon provided
            else if (icon != null)
              Icon(icon, size: 16, color: Colors.white),

            const SizedBox(width: 6),

            Text(
              text,
              style: AppTextStyle.poppinsMedium(13)
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }


  Widget _timelineRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyle.regular(12)),
          Text(value, style: AppTextStyle.medium(12)),
        ],
      ),
    );
  }
}
