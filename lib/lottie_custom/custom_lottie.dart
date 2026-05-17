import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLottie extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CustomLottie({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.warning_amber_rounded,
          color: Colors.amber,
          size: 40,
        );
      },
    );
  }
}