import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final int maxLength;
  final bool showCounter;
  final bool multiline;
  final bool obscureText;
  final Icon suffixIcon;
  final Function onTap;
  final Function onChanged;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;

  CustomTextField({
    @required this.hint,
    @required this.maxLength,
    this.showCounter = false,
    this.multiline = false,
    this.obscureText = false,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.controller,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200
      ),
      child: TextField(
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        controller: controller,
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          counterText: showCounter ? null : "",
          suffixIcon: suffixIcon
        ),
        obscureText: obscureText,
        maxLength: maxLength,
        maxLines: multiline ? null : 1,
        buildCounter: (_, {currentLength, maxLength, isFocused}) => Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                currentLength.toString() + "/" + maxLength.toString(),
                style: TextStyle(
                  color: Colors.grey.shade700
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}