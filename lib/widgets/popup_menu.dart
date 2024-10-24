import 'package:flutter/material.dart';

class PopupMenu extends StatelessWidget {
  final List<PopupMenuEntry<String>> menuItems;
  final void Function(String) onSelected;

  const PopupMenu(
      {Key? key, required this.menuItems, required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        color: Colors.white,
        // Background color of the menu
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        itemBuilder: (BuildContext context) => menuItems,
        onSelected: onSelected,
        position: PopupMenuPosition.over);
  }
}
