import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashViewModel>().checkLogin(context); // gọi checkLogin từ ViewModel
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Image.asset(
          "assets/images/Frame1.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
