import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:voita_app/routing/router.dart';
import 'package:voita_app/utils/blocs/notes_bloc/notes_bloc.dart';
import 'package:voita_app/utils/services/data/supabase_client.dart';

void main() {
  initializeDateFormatting('uk_EU', null).then((_) async {
    await SupabaseClient.initialize();
    runApp(const VoitaApp());
  });
}

class VoitaApp extends StatefulWidget {
  const VoitaApp({super.key});

  @override
  State<VoitaApp> createState() {
    return _VoitaApp();
  }
}

class _VoitaApp extends State<VoitaApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<NotesBloc>(
              lazy: false,
              create: (context) => NotesBloc()..add(const LoadNotes())),
        ],
        child: MaterialApp.router(
          routerConfig: VoitaRouter.router,
        ));
  }
}
