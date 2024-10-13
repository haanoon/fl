import 'package:flutter/material.dart';

class DragTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget> tabs;
  final TabController controller;
  final void Function(int, int) onReorder;
  final void Function(int) onTap;
  final void Function(int) onDoubleTap;
  const DragTabBar(
      {super.key,
      required this.tabs,
      required this.controller,
      required this.onReorder,
      required this.onTap,
      required this.onDoubleTap});

  @override
  State<DragTabBar> createState() => _DragTabBarState();
  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _DragTabBarState extends State<DragTabBar> {
  int currentindex = 0;
  @override
  void initState() {
    super.initState();
    currentindex = widget.controller.index;
    widget.controller.addListener(() {
      setState(() {
        currentindex = widget.controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final tabWidth = screenWidth / widget.tabs.length;
    final tabheight = MediaQuery.sizeOf(context).height * .075;
    return SizedBox(
      height: tabheight,
      width: screenWidth,
      child: ReorderableListView(
          scrollDirection: Axis.horizontal,
          onReorder: widget.onReorder,
          children: widget.tabs
              .asMap()
              .map((i, tab) => MapEntry(
                  i,
                  ReorderableDragStartListener(
                    key: ValueKey(i),
                    index: i,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentindex = i;
                        });
                        widget.onTap(i);
                      },
                      onDoubleTap: () {
                        widget.onDoubleTap(i);
                        print('Double Tap');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: Container(
                          width: tabWidth,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: i == currentindex
                                  ? Colors.green[400]
                                  : Colors.grey),
                          child: tab,
                        ),
                      ),
                    ),
                  )))
              .values
              .toList()),
    );
  }
}
