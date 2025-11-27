import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Lottie Heavenly light rays (background)
        Positioned.fill(
          child: Opacity(
            opacity: 0.65,
            child: Lottie.asset(
              'assets/animations/lottie/Heavenly_Background/heavenly_bg.json',
              fit: BoxFit.cover,
            ),
          ),
        ),

        /// Neon UI cross glow (foreground subtle)
        Positioned.fill(
          child: Opacity(
            opacity: 0.35,
            child: Lottie.asset(
              'assets/animations/lottie/Neon_Ui_Pack/neon_cross.json',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
