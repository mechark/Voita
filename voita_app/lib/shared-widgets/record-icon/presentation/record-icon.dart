import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voita_app/constants/app_colors.dart';

class RecordIcon extends StatelessWidget {
final Color color;
const RecordIcon({ Key? key, required this.color }) : super(key: key);


  @override
  Widget build(BuildContext context){
    return IconButton(
            onPressed: () async {
              final status = await Permission.microphone.request();

              if (status.isGranted) {
                Navigator.pushNamed(context, "/note");
              }
              else {print("status.isDenied ${status.isDenied}");}
            },
            icon: ImageIcon(AssetImage("assets/add_note.png")),
            iconSize: 90,
            color: color,
          );
  }
}