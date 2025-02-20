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
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ColoredBox(
          color: Color(0xFF87CEEB),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 100,
                child: Image.asset(
                  'assets/images/PHOTO-2025-02-03-18-58-20.jpg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              // Text at bottom center
              Positioned(
                bottom: 20,
                child: Center(
                  child: Text(
                    '''Powered by

wwww.zoyobathware.com''',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF00008B),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
