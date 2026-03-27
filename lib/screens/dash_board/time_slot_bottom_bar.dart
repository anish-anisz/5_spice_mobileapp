import 'package:cravia_kitchen/screens/dash_board/time_slot_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cors/app_colors.dart';
import '../../providers/order_provider.dart';

class TimeSlotBottomBar extends StatefulWidget {
  const TimeSlotBottomBar({super.key});

  @override
  State<TimeSlotBottomBar> createState() => _TimeSlotBottomBarState();
}

class _TimeSlotBottomBarState extends State<TimeSlotBottomBar> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().selectCurrentTimeSlot();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        return Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: Colors.white,
          child: Row(
            children: [

              IconButton(
                onPressed: () {},
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.grey600,
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ),


              // SLOTS
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.timeSlots.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8),
                      child: TimeSlotCard(
                        slot: provider.timeSlots[index],
                        selected: provider.selectedTimeIndex == index,
                        onTap: () => provider.selectTimeSlot(index),
                      ),
                    );
                  },
                ),
              ),


              IconButton(
                onPressed: () {},
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.grey600,
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
