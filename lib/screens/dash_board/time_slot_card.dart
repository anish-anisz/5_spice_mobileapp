import 'package:cravia_kitchen/cors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../cors/app_text_style.dart';
import '../../models/time_slot_model.dart';

class TimeSlotCard extends StatelessWidget {
  final TimeSlot slot;
  final bool selected;
  final VoidCallback onTap;

  const TimeSlotCard({
    super.key,
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  @override
  bool isCurrentOrPastSlot(String slotTime) {
    final now = DateTime.now();

    // Example slot.time = "10:30 AM"
    final format = DateFormat("hh:mm a");
    final parsedTime = format.parse(slotTime);

    final slotDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    return !slotDateTime.isAfter(now); // true for past & current
  }

  Widget build(BuildContext context) {
    final bool canTap = isCurrentOrPastSlot(slot.time);
    return GestureDetector(
      onTap: canTap ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: EdgeInsets.only(
          top: selected ? 0 : 12,
          bottom: selected ? 12 : 0,
        ),
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryColor
                    : const Color(0xFF44AE74), // blue
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              child: Text(
                slot.count.toString(),
                textAlign: TextAlign.center,
                style: AppTextStyle.poppinsMedium(
                  14,
                  color: Colors.white,
                ),
              ),
            ),


            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                color: AppColors.grey300,

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Text(
                slot.time,
                textAlign: TextAlign.center,
                style: AppTextStyle.poppinsRegular(
                  9,
                  color: selected ? Colors.black87 : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}

