import 'package:flutter/material.dart';
import 'package:zoyo_bathware/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: ColoredBox(
        color: Color(0xFF87CEEB),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/PHOTO-2025-02-03-18-58-20.jpg',
                width: screenSize.width * 0.5,
                height: screenSize.height * 0.3,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 50),
              Text(
                '''Powered by

wwww.zoyobathware.com''',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF00008B),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
