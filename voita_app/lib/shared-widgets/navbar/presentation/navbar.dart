import 'package:flutter/material.dart';
import 'package:voita_app/constants/app_colors.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        notchMargin: -5,
        color: Colors.white,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => {
                if (Navigator.of(context).canPop())
                  {Navigator.pushReplacementNamed(context, '/voita_home')}
              },
              icon: const ImageIcon(AssetImage("assets/home.png")),
              color: AppColor.spaceGray,
              disabledColor: AppColor.purplishBlue,
            ),
            IconButton(
              onPressed: () => {},
              icon: const ImageIcon(AssetImage("assets/groups.png")),
              color: AppColor.spaceGray,
              disabledColor: AppColor.purplishBlue,
            ),
          ],
        ));
  }
}
