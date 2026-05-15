import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Testing extends StatelessWidget {
  const Testing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: 100 ,
          width: 200,
          child: Lottie.asset(
              'assets/images/night_cloudy.json' ,
              fit: BoxFit.cover
          )
      ),
    );
  }
}
