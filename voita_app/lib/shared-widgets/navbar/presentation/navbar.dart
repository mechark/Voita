import 'package:flutter/material.dart';
import 'package:voita_app/constants/app_colors.dart';

class Navbar extends StatelessWidget {
const Navbar({ Key? key }) : super(key: key);

void _homeOnPressed() {
  
}

  @override
  Widget build(BuildContext context){
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      notchMargin: -5,
      color: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: CircularNotchedRectangle(),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () => {
                        if (Navigator.of(context).canPop()) {
                          Navigator.pushReplacementNamed(context, '/voita_home')
                        }
                      },
                      icon: ImageIcon(AssetImage("assets/home.png")),
                      color: AppColor.spaceGray,
                      disabledColor: AppColor.purplishBlue,
                  ),
                  IconButton(
                      onPressed: () => {},
                      icon: ImageIcon(AssetImage("assets/groups.png")),
                      color: AppColor.spaceGray,
                      disabledColor: AppColor.purplishBlue,
                      ),
                ],
      )
    );
  }
}