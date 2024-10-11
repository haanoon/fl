import 'package:flutter/material.dart';

class DragTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget> tabs;
  final TabController controller;
  final void Function(int, int) onReorder;
  final void Function(int) onTap;
  const DragTabBar(
      {super.key,
      required this.tabs,
      required this.controller,
      required this.onReorder,
      required this.onTap});

  @override
  State<DragTabBar> createState() => _DragTabBarState();
  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _DragTabBarState extends State<DragTabBar> {
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
                  GestureDetector(
                    key: ValueKey(i),
                    onTap: () {
                      widget.onTap(i);
                    },
                    child: Container(
                      key: ValueKey('$i-a'),
                      child: tab,
                    ),
                  )))
              .values
              .toList()),
    );
  }
}
