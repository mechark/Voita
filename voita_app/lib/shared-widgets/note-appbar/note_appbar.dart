import 'package:flutter/material.dart';
import 'package:voita_app/constants/app_colors.dart';

class NoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NoteAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Нотатка",
        style: TextStyle(
            fontSize: 30, fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {},
            icon: const ImageIcon(
              AssetImage("assets/share.png"),
              size: 25,
              color: AppColor.spaceGray,
            ))
      ],
    );
  }
}
