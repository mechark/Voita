import 'package:flutter/cupertino.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({ Key? key }) : super(key: key);

  @override
  _AllNotesState createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  @override
  Widget build(BuildContext context) {
    return Container(child:
      Center(child: Text("Усі нотатки"),)
    );
  }
}