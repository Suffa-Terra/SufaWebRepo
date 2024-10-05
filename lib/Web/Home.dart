import 'package:flutter/material.dart';
import 'package:sufaweb/Web/Upload/Upload.dart';

class Home_Web_Screen extends StatefulWidget {
  const Home_Web_Screen({super.key});

  @override
  State<Home_Web_Screen> createState() => _Home_Web_ScreenState();
}

class _Home_Web_ScreenState extends State<Home_Web_Screen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: UploadScreen(),
      ),
    );
  }
}
