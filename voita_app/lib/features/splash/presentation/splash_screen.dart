import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/voita_home');
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Voita',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 50,
            fontWeight: FontWeight.bold
          ),
        )
      )
    );
  }
}