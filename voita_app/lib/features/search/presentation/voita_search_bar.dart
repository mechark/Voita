import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/utils/blocs/notes_bloc/notes_bloc.dart';
import 'package:voita_app/utils/services/context_extension.dart';
import 'package:voita_app/utils/services/time_formatter.dart';

class VoitaSearchBar extends StatefulWidget {
  const VoitaSearchBar({ super.key });

  @override
  State<VoitaSearchBar> createState() => _VoitaSearchBarState();
}

class _VoitaSearchBarState extends State<VoitaSearchBar> {

  final TextEditingController textController = TextEditingController();
  Iterable<Widget> suggestions = [];

  List<Note> getMatched(List<Note> notes, String query) {
    return notes.where((note) => 
    note.header.toLowerCase().contains(query.toLowerCase()) ||
    note.text.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  RegExpMatch ? getMatchingContext(String text, String query) {
    final expression = RegExp('${query.toLowerCase()}.*?(?=\$)');
    return expression.firstMatch(text.toLowerCase());
  }

  TextSpan getMatchingString(String text, String query) {
    final match = getMatchingContext(text, query);

    if (match != null) {
      return TextSpan(
        style: const TextStyle(
          color: AppColor.spaceGray,
        ),
        children: [
          TextSpan(
            text: text.substring(0, match.start)
          ),
          TextSpan(
            text: query,
            style: const TextStyle(fontWeight: FontWeight.bold)
          ),
          TextSpan(
            text: text.substring(text.indexOf(query) + query.length, match.end)
          ),
        ]
      );
    }
    return const TextSpan();
  }

  void getSuggestions(List<Note> notes, String query) {
    final matchedNotes = getMatched(notes, query);

    if (query.trim() == '') {
      suggestions = List<Widget>.generate(1, (index) {
       return const Padding(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Center(
            child: Icon(Icons.search_off, size: 40),
        ));
      });
    } else if (matchedNotes.isNotEmpty) {
      suggestions = List<Widget>.generate(matchedNotes.length, (index) {
        Note note = matchedNotes[index];
        return Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ],
                    color: context.responsive(
                        AppColor.purplishBlue,
                        xl: Colors.white)),
                child: ListTile(
                    titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Open Sans',
                        fontSize: 14,
                        color: AppColor.spaceGray),
                    title: Text(note.header),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(thickness: 1),
                        RichText(
                          text: getMatchingString(note.text, query)
                        ),
                        Text(TimeFormatter.getDay(note.date))
                      ],
                    ),
                    onTap: () {
                      context.go('/notes/1');
                    }));
        });
    } else {
      suggestions = List<Widget>.generate(1, (index) {
        return const Padding(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Center(
            child: Icon(Icons.search_off, size: 40),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<NotesBloc>(context),
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoaded) {
            return Material( 
            child: Container(
              decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.spaceGray.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 1,
                        offset: const Offset(0, 2)
                      )
                    ]
                  ),
              constraints: const BoxConstraints(minWidth: 400, maxWidth: 800, minHeight: 200, maxHeight: 600),
              child: Column(
              mainAxisSize: MainAxisSize.min,
                children: [
                  Container( 
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.spaceGray.withOpacity(0.1),
                          spreadRadius: 0.5,
                          blurRadius: 1,
                          offset: const Offset(0, 2)
                        )
                      ]
                    ),
                    height: 40,
                    child: TextField(
                    controller: textController,
                    cursorColor: const Color.fromARGB(255, 107, 107, 107),
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (query) {
                      setState(() => getSuggestions(state.notes, query));
                    },
                      decoration: InputDecoration(
                      focusColor: AppColor.spaceGray,
                      isDense: true,
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20
                      ),
                      suffixIcon: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          child: const Icon(
                            Icons.close,
                            size: 20
                          ),
                          onTap: () => textController.clear(),
                        )
                      )
                    )
                  )),

                  Container(
                    constraints: const BoxConstraints( minHeight: 200, maxHeight: 500),
                    child: 
                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return suggestions.elementAt(index);
                          }, 
                          separatorBuilder: (context, index) => const SizedBox(height: 5), 
                          itemCount: suggestions.length
                        )
                    )
                ]
              )
            )); 
          }
          else {
            // TODO change this to the error screen or something
            return const Placeholder();
          }
        }
      )
    );
  }
}