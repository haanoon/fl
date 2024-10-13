import 'package:dynamic_tabbar/dynamic_tabbar.dart';

import 'package:flutter/material.dart';
import 'package:tabmanagement/old/plan.dart';
import 'package:tabmanagement/tabs.dart';

class DynamicTab1 extends StatefulWidget {
  const DynamicTab1({super.key});

  @override
  State<DynamicTab1> createState() => _DynamicTab1State();
}

class _DynamicTab1State extends State<DynamicTab1>
    with SingleTickerProviderStateMixin {
  List<TabData> tabs = [
    TabData(
      index: 1,
      title: const Tab(
        icon: Icon(Icons.home, color: Colors.black),
        child: Text(
          'Tab 1',
          style: TextStyle(color: Colors.black),
        ),
      ),
      content: const Center(child: Home()),
    ),
    TabData(
      index: 2,
      title: const Tab(
        icon: Icon(Icons.business, color: Colors.black),
        child: Text(
          'Tab 2',
          style: TextStyle(color: Colors.black),
        ),
      ),
      content: const Home(),
    ),
  ];

  int currentIndex = 0;
  late TabController
      _controller; // Change to non-nullable and late initialization

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    _controller.addListener(() {
      setState(() {
        currentIndex = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floors'),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 30, 183, 140),
        bottom: DragTabBar(
          onDoubleTap: (index) {},
          tabs: tabs.map((tabData) => tabData.title).toList(),
          controller: _controller, // Pass the controller
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final TabData tab = tabs.removeAt(oldIndex);
              tabs.insert(newIndex, tab);
            });
          },
          onTap: (index) {
            setState(() {
              _controller.index = index;
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              _addNewTab(context);
            },
            icon: const Icon(Icons.add),
          ),
          if (tabs.isNotEmpty)
            IconButton(
              onPressed: () {
                deleteTab(currentIndex);
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: TabBarView(
        controller: _controller,
        children: tabs.map((tabData) => tabData.content).toList(),
      ),
    );
  }

  void _addNewTab(BuildContext context) {
    String newFloor = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add New Floor',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 30, 183, 140),
            ),
          ),
          content: TextField(
            onChanged: (value) {
              newFloor = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter Floor Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newFloor.isNotEmpty) {
                  _addTab(newFloor);
                  Navigator.of(context).pop();
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 183, 140),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addTab(String floorName) {
    setState(() {
      int nextIndex = tabs.length + 1;
      tabs.add(
        TabData(
            index: nextIndex,
            title: Tab(
              icon: const Icon(Icons.layers, color: Colors.black),
              child: Text(
                floorName,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            // content: const Center(child: Home()),
            content: nextIndex % 2 == 0
                ? const Center(
                    child: Text('okokokokokokokok'),
                  )
                : const Center(
                    child: Text('lalalalalalalalala'),
                  )),
      );

      // Use the existing controller to avoid creating a new one
      _controller = TabController(length: tabs.length, vsync: this);
      _controller.animateTo(currentIndex);
    });
  }

  void deleteTab(int tabIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Floor'),
          content: const Text('Confirm Delete'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  tabs.removeAt(tabIndex);
                  // Update controller length
                  _controller = TabController(length: tabs.length, vsync: this);

                  if (tabIndex >= tabs.length && tabs.isEmpty) {
                    currentIndex = tabIndex - 1;
                  } else if (tabs.isEmpty) {
                    currentIndex = 0;
                  }
                  _controller.animateTo(currentIndex);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
