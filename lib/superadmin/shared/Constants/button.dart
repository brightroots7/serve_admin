import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'appcolor.dart';
import 'fonts.dart';

class CustomButton extends StatelessWidget {

  final VoidCallback onTap;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;

  final Color? bgColor;
  final Color? fontColor;
  final BoxShadow? boxShadow;
  final Border? border;
  final double? width;
  final double? height;
  final double? padding;

  final TextAlign? textAlign;
  final Widget? child;

  const CustomButton(
      {Key? key,

      required this.onTap,
      this.borderRadius,
      this.fontSize,
      this.fontWeight,

      this.bgColor,
      this.fontColor,
      this.boxShadow,
      this.border,
      this.width,
      this.height,
      this.padding,
      this.textAlign,

      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: width ?? 448,
          height: height ?? 69,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            color: bgColor ?? appcolor.appColor,
            border:   Border.all()
          ),
          child:
              Center(child: child).paddingSymmetric(horizontal: padding ?? 30),
        ),
      ),
    );
  }
}
