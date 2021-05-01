import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:login_page/widgets/group_chat.dart';
import 'package:login_page/widgets/recent_chats.dart';

class CategorySelector extends StatefulWidget {
  @override
  CategorySelectorState createState() => CategorySelectorState();
}

class CategorySelectorState extends State<CategorySelector> {
  int selectedIndex;
  final List<String> categories = ['Messages','Groups'];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(left: 15, top: 15, bottom: 0, right:15),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: index == selectedIndex ? Colors.white : Colors.white60,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
