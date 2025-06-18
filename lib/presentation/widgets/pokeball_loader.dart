import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PokeballLoader extends StatelessWidget {
  final Color? backgroundColor;
  final double backgroundOpacity;

  const PokeballLoader({
    super.key,
    this.backgroundColor,
    this.backgroundOpacity = 0.45,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Opacity(
            opacity: backgroundOpacity,
            child: Container(color: backgroundColor),
          ),
          const Center(
            child: _PokeballLottie(),
          ),
        ],
      ),
    );
  }
}

class _PokeballLottie extends StatelessWidget {
  const _PokeballLottie();

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/pokeball_lottie.json',
      width: 120,
      height: 120,
      repeat: true,
      animate: true,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Lottie load error: $error');
        return const CircularProgressIndicator();
      },
    );
  }
}
