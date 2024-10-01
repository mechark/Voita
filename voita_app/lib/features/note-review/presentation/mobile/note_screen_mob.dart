import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/note-review/bloc/review_bloc.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/shared-widgets/navbar/presentation/navbar.dart';
import 'package:voita_app/shared-widgets/note-appbar/note_appbar.dart';
import 'package:voita_app/shared-widgets/record-icon/presentation/record-icon.dart';
import 'package:voita_app/utils/services/time_formatter.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  final Function(Note) onNoteUpdated;
  const NoteScreen({super.key, required this.onNoteUpdated, required this.note});

  @override
  State<NoteScreen> createState() {
    return _NoteScreenState();
  }
}

class _NoteScreenState extends State<NoteScreen> {
  late final Note note;
  bool isEditable = false;
  late String currHeader = note.header;
  late String currText = note.text;
  late TextEditingController _headerController;
  late TextEditingController _textController;
  late ReviewBloc _bloc;

  @override
  void initState() {
    note = widget.note;

    super.initState();
    _headerController = TextEditingController(text: note.header);
    _textController = TextEditingController(text: note.text);
  }

  @override
  void deactivate() {
    if (note.header != _headerController.text ||
        note.text != _textController.text) {
      _bloc.add(ReviewTerminate(
        id: note.id,
        header: _headerController.text,
        text: _textController.text,
      ));

      note.header = _headerController.text;
      note.text = _textController.text;
      widget.onNoteUpdated(note);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ReviewBloc(),
        child: BlocBuilder<ReviewBloc, ReviewState>(builder: (context, state) {
          _bloc = BlocProvider.of<ReviewBloc>(context);
          return Scaffold(
            appBar: const NoteAppBar(),
            body:
                BlocBuilder<ReviewBloc, ReviewState>(builder: (context, state) {
              return Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IgnorePointer(
                      ignoring: !isEditable,
                      child: TextField(
                        onChanged: (value) =>
                            {currHeader = _headerController.text},
                        controller: _headerController,
                        style: const TextStyle(
                          fontFamily: "Open Sans",
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            TimeFormatter.getDay(note.date) ==
                                    TimeFormatter.getDay(DateTime.now())
                                ? "Сьогодні"
                                : TimeFormatter.getDay(note.date),
                            style: const TextStyle(
                              fontFamily: "Open Sans",
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            )),
                        Text(
                            TimeFormatter.getTimeRange(
                                note.date, note.duration),
                            style: const TextStyle(
                              fontFamily: "Open Sans",
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Switch(
                        value: isEditable,
                        inactiveThumbColor: AppColor.darkPurple,
                        thumbColor:
                            WidgetStateProperty.all(AppColor.darkPurple),
                        activeColor: AppColor.darkPurple,
                        trackOutlineColor:
                            WidgetStateProperty.all(Colors.white),
                        thumbIcon:
                            WidgetStateProperty.all(const Icon(Icons.edit)),
                        onChanged: (value) => {
                              setState(() {
                                isEditable = !isEditable;
                              })
                            }),
                    const SizedBox(height: 10),
                    const Divider(),
                    IgnorePointer(
                        ignoring: !isEditable,
                        child: TextField(
                          onChanged: (value) =>
                              {currText = _textController.text},
                          controller: _textController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                            fontFamily: "Open Sans",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        )),
                  ],
                ),
              );
            }),
            extendBody: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: const RecordIcon(color: AppColor.spaceGray),
            bottomNavigationBar: const Navbar(),
          );
        }));
  }
}
