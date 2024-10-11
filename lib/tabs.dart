import 'package:flutter/material.dart';

class dragTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget> tabs;
  final TabController controller;
  final void Function(int, int) onReorder;
  const dragTabBar(
      {required this.tabs, required this.controller, required this.onReorder});

  @override
  State<dragTabBar> createState() => _dragTabBarState();
  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _dragTabBarState extends State<dragTabBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: MediaQuery.sizeOf(context).width,
      child: ReorderableListView(
          scrollDirection: Axis.horizontal,
          onReorder: widget.onReorder,
          children: widget.tabs
              .asMap()
              .map((i, tab) => MapEntry(
                  i,
                  Container(
                    key: ValueKey(i),
                    child: tab,
                  )))
              .values
              .toList()),
    );
  }
}
