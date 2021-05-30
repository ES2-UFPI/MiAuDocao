import 'dart:convert';

import 'package:flutter/material.dart';

class FullscreenImage extends StatelessWidget {
  final String image;
  FullscreenImage(this.image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
            child: Image.memory(
              base64Decode(image.split(',')[1]),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      onTap: () => Navigator.pop(context)
    );
  }
}