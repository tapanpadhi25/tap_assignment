import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
   Future.delayed(const Duration(seconds: 2)).then((value){
     if(mounted){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
     }
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("Welcome",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),),),
    );
  }
}
