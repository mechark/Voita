import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/notes-overview/bloc/notes_bloc.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/notes-overview/presentation/note_card.dart';
import 'package:voita_app/features/notes-overview/presentation/notes_overview_desk.dart';
import 'package:voita_app/features/notes-overview/presentation/notes_overview_mob.dart';
import 'package:voita_app/features/search/presentation/search_bar.dart';
import 'package:voita_app/shared-widgets/navbar/presentation/navbar.dart';
import 'package:voita_app/shared-widgets/record-icon/presentation/record-icon.dart';
import 'package:voita_app/utils/services/context_extension.dart';

class NotesScreen extends StatefulWidget {
  final List<Note> notes;
  const NotesScreen({super.key, required this.notes});

  @override
  State<NotesScreen> createState() {
    return _NotesScreenState();
  }
}

class _NotesScreenState extends State<NotesScreen> {

  late final NotesOverviewMob mobWidget;
  late final NotesOverviewDesk deskWidget;

  @override
  void initState() {
    mobWidget = NotesOverviewMob(notes: widget.notes);
    deskWidget = NotesOverviewDesk(notes: widget.notes);

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