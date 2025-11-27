import 'package:flutter/material.dart';

class GifBackground extends StatelessWidget {
  final String path;

  const GifBackground({
    super.key,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        path,
        fit: BoxFit.cover,
      ),
    );
  }
}
