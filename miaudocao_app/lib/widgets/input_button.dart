import 'package:flutter/material.dart';

class InputButton extends StatelessWidget {
  final Function() onTap;
  final String label;
  final Icon icon;
  final Color textColor;

  InputButton({
    @required this.onTap,
    @required this.label,
    this.icon,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  )
                ),
              ),
              icon == null ? Container() : icon
            ]
          ),
        ),
      ),
    );
  }
}