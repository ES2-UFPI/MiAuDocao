import 'package:flutter/material.dart';

class CentralizedTipText extends StatelessWidget {

  final String title;
  final String subtitle;

  CentralizedTipText({
    @required this.title,
    @required this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 5),
        Text(
          subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}