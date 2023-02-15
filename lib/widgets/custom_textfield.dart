import 'package:flutter/material.dart';
import 'package:namma_bengaluru_metro/components/colors.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final BoxConstraints? suffixIconConstraints;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.height = 50.0,
    this.width,
    this.margin,
    this.contentPadding = EdgeInsets.zero,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.sentences,
    this.prefix,
    this.prefixIcon,
    this.prefixIconColor,
    this.prefixIconConstraints = const BoxConstraints(
      minWidth: 50.0,
    ),
    this.suffix,
    this.suffixIcon,
    this.suffixIconColor,
    this.suffixIconConstraints,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      height: 50.0,
      width: widget.width,
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          labelStyle: const TextStyle(
            fontSize: 20.0,
          ),
          contentPadding: widget.contentPadding,
          prefix: widget.prefix,
          prefixIcon: widget.prefixIcon,
          prefixIconColor: widget.prefixIconColor,
          prefixIconConstraints: widget.prefixIconConstraints,
          suffix: widget.suffix,
          suffixIcon: widget.suffixIcon,
          suffixIconColor: widget.suffixIconColor,
          suffixIconConstraints: widget.suffixIconConstraints,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: AppColors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: AppColors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: AppColors.grey,
            ),
          ),
        ),
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
      ),
    );
  }
}
