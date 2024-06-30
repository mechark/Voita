import 'package:flutter/material.dart';
import 'package:voita_app/features/notes-overview/presentation/notes_overview_desk.dart';
import 'package:voita_app/features/notes-overview/presentation/notes_overview_mob.dart';
import 'package:voita_app/utils/services/context_extension.dart';
import 'package:voita_app/utils/services/notes_provider.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() {
    return _NotesScreenState();
  }
}

class _NotesScreenState extends State<NotesScreen> {
  late final NotesProvider notesProvider;

  late final NotesOverviewMob mobWidget;
  late final NotesOverviewDesk deskWidget;

  @override
  void initState() {
    notesProvider = Provider.of<NotesProvider>(context);
    mobWidget = NotesOverviewMob(notes: notesProvider.notes);
    deskWidget = NotesOverviewDesk(notes: notesProvider.notes);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: context.responsive<Widget>(
        mobWidget,
        xl: deskWidget 
      )
    );
  }
}