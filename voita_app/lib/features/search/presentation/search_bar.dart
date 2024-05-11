import 'package:flutter/material.dart';
import 'package:voita_app/constants/app_colors.dart';

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({ Key? key }) : super(key: key);

  @override
  _SearchBarAppState createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: SearchAnchor(
        builder:(BuildContext context, SearchController controller) {
          return SearchBar(
            backgroundColor: MaterialStateProperty.all(AppColor.purplishBlueLight),
            overlayColor: MaterialStateProperty.all(Colors.white),
            shadowColor: MaterialStateProperty.all(Colors.white),
            surfaceTintColor: MaterialStateProperty.all(Colors.white),
            controller: controller,
            //onTap: controller.openView(),
            onChanged: (_) {
                controller.openView();
              },
            leading: const ImageIcon(
              AssetImage("assets/search.png"),
              size: 30,  
            ),
            
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController controller) {
          return List<ListTile>.generate(5, (int index) {
              final String item = 'item $index';
              return ListTile(
                title: Text(item),
                onTap: () {
                  setState(() {
                    controller.closeView(item);
                  });
                },
              );
            });
        },
      )
    );
  }
}