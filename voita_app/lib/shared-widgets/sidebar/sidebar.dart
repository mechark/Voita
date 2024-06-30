import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/search/presentation/search_bar.dart';

class Sidebar extends StatefulWidget {
  final List<Note> notes;
  const Sidebar({ super.key, required this.notes });

  @override
  State<Sidebar> createState() {
    return _SidebarState();
  }
}

class _SidebarState extends State<Sidebar> {
  int selectedIndex = 0;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;
  
  NavigationRailLabelType labelType = NavigationRailLabelType.none;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
                selectedIndex: selectedIndex,
                elevation: 3,
                groupAlignment: groupAlignment,
                extended: true,
                onDestinationSelected: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                labelType: labelType,
                indicatorColor: AppColor.purplishBlueLight,
                leading: Column(
                  children: [
                    Container(
                      width: 250,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Row(children: [
                        IconButton(
                          onPressed: () => {}, 
                          icon: const ImageIcon(AssetImage("assets/base.png"))
                        ),
                        const Text("Павло",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: 'Lato'
                          )),
                      ],),
                      IconButton(
                        icon: const Icon(Icons.dark_mode),
                        onPressed: () => {}
                      )
                    ],),
                    ),
                    const Divider(height: 20, thickness: 20,color: Colors.black,),
                    SearchBarApp(notes: widget.notes),
                  ],
                ),
                trailing: Row(
                  children: [
                    const SizedBox(height: 150),
                    Container(
                    width: 110,
                    height: 40,
                    child: FloatingActionButton(
                      backgroundColor: AppColor.purplishBlue,
                      hoverColor: AppColor.darkPurple,
                      onPressed: () => {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text('Запис',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            fontFamily: 'Lato'
                          ),),
                        Icon(Icons.mic, size: 25,),
                      ],),
                    ))
                  ],
                ),
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Додому',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: 'Lato'
                      ),),
                    ),
                  NavigationRailDestination(
                    icon: Icon(Icons.folder_shared),
                    label: Text('Групи',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: 'Lato'
                      ),),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.description),
                    label: Text(
                      'Усі нотатки',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: 'Lato'
                      ),
                    ),
                  ),
              ],
            );
  }
}