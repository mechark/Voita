import 'package:flutter/material.dart';
import 'package:voita_app/routing/routes.dart';

void main() {
  runApp(const VoitaApp());
}

class VoitaApp extends StatefulWidget {
  const VoitaApp({ Key? key }) : super(key: key);

  @override
  _VoitaApp createState() => _VoitaApp();
}

class _VoitaApp extends State<VoitaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: routes,
    );
  }
}