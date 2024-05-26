import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:voita_app/routing/routes.dart';
import 'package:voita_app/utils/services/supabase_client.dart';

void main() {
  initializeDateFormatting('uk_EU', null).then((_) async {
    await SupabaseClient.initialize();
    runApp(const VoitaApp());
  });
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