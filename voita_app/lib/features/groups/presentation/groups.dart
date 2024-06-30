import 'package:flutter/cupertino.dart';

class Groups extends StatefulWidget {
  const Groups({ Key? key }) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return Container(child:
      Center(child: Text("Групи"),)
    );
  }
}