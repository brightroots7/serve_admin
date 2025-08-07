import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'appcolor.dart';
import 'fonts.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final Color? labelColor;
  final double? labelFontSize;
  final double? hintFontSize;
  final double? borderRadius;
  final double? containerHeight;
  final double? containerWidth;
  final Widget? suffix;
  final Widget? prefix;
  final double? padding;
  final double? shadowOpacity;
  final FontWeight? labelFontWeight;
  final FontWeight? hintFontWeight;
  final Color? focusedBorderColor;
  final String? Function(String?)? validator;
  final VoidCallback? editingComplete;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final IconButton? suffixIcon;
  final IconButton? prefixIcon;
  final bool? obscureText;
  final Function()? onTap;

  CustomTextField({
    this.labelText,
    this.hintText,
    this.labelColor,
    this.labelFontSize,
    this.hintFontSize,
    this.borderRadius,
    this.containerHeight,
    this.containerWidth,
    this.suffix,
    this.prefix,
    this.padding,
    this.shadowOpacity,
    this.labelFontWeight,
    this.hintFontWeight,
    this.focusedBorderColor,
    this.validator,
    this.editingComplete,
    this.controller,
    this.textInputAction,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.onTap,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText= false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.containerHeight ?? 68,
      width: widget.containerWidth ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 12)),
        color: appcolor.white,
      ),
      child: TextFormField(
        onTap: widget.onTap,
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        obscureText: _obscureText,
        onEditingComplete: widget.editingComplete,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle:
            GoogleFonts.urbanist(fontWeight: widget.hintFontWeight, fontSize: widget.hintFontSize),

          labelStyle: GoogleFonts.urbanist(
              fontWeight: widget.labelFontWeight,
              color: widget.labelColor,
              fontSize: widget.labelFontSize,
            ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 12)),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 12)),
            borderSide: BorderSide(color: widget.focusedBorderColor ?? appcolor.appColor, width: 2),
          ),
          suffixIcon: widget.obscureText == true
              ? IconButton(
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: _toggleObscureText,
          )
              : widget.suffix,
          prefixIcon: widget.prefix,
        ),
      ).paddingOnly(left: widget.padding ?? 0),
    );
  }
}
