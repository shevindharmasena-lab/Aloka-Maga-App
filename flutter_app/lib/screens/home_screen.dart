import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/animated_background.dart';
import '../widgets/dove_border_trail.dart';
import '../widgets/gif_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1 — Main Lottie animated background
          const AnimatedBackground(),

          // 2 — GIF glowing cross animation (your GIF file)
          GifBackground(
            path: 'assets/animations/gifs/cross_glow.gif',
          ),

          // 3 — Optional Neon Lottie layered on top
          Opacity(
            opacity: 0.45,
            child: Lottie.asset(
              'assets/animations/lottie/Neon_Ui_Pack/neon_cross.json',
              fit: BoxFit.cover,
            ),
          ),

          // 4 — Dove border animation on top
          const DoveBorderTrail(),
        ],
      ),
    );
  }
}
