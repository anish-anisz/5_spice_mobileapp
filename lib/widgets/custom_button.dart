import 'package:cravia_kitchen/cors/app_colors.dart';
import 'package:cravia_kitchen/cors/app_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackButtonCustom extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const BackButtonCustom({
    super.key,
    this.onPressed,
    this.label = 'Back',
    this.backgroundColor = AppColors.white,
    this.textColor = AppColors.textDark,
    this.borderColor =AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed ?? () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 6,
                offset: Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 6),
              Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.poppinsMedium(14,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
