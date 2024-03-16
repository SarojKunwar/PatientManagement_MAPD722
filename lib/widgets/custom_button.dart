import 'package:patient_management/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.fontSize = 20,
      this.loading = false,
      this.buttonType = 'primary'})
      : super(key: key);

  final Function onPressed;
  final String label;
  final double fontSize;
  final bool loading;
  final String buttonType;

  @override
  Widget build(BuildContext context) {
    bool isPrimary = buttonType == 'primary';

    return InkWell(
      onTap: () {
        if (!loading) {
          onPressed();
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
            color: isPrimary ? const Color(0xff000000) : Colors.transparent,
            borderRadius: BorderRadius.circular(13.0),
            border: Border.all(
                color:
                    isPrimary ? Colors.transparent : AppColors.primaryColor)),
        child: loading
            ? CircularProgressIndicator(
                color: isPrimary ? Colors.white : AppColors.primaryColor,
              )
            : Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fontSize,
                  color: isPrimary
                      ? const Color(0xffffffff)
                      : AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
