import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:tabmanagement/floor_plan/floorPlan.dart';

class FloorM3 extends StatefulWidget {
  const FloorM3({super.key});

  @override
  State<FloorM3> createState() => _FloorM3State();
}

class _FloorM3State extends State<FloorM3> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Floorplan> painter = [];
  int selectedfloor = 0;

  @override
  void initState() {
    Floorplan tab1 = Floorplan();
    painter.add(tab1);
    super.initState();
    List<TabData> floortabs = [
      TabData(
          index: 1,
          title: Tab(
            child: Text('First Floor '),
          ),
          content: Floorplan()),
    ];

    _tabController = TabController(length: floortabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _selectFloor(int index) {
    setState(() {
      selectedfloor = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floors'),
        bottom: TabBar(
          tabs: floortabs.map((e) => e.title).toList(),
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          IconButton(
            onPressed: () {
              addtab();
            },
            icon: const Icon(Icons.add),
          ),
          if (floortabs.isNotEmpty)
            IconButton(
              onPressed: () {
                deletetab(selectedfloor);
              },
              icon: const Icon(Icons.delete),
            )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              key: const ValueKey('Header'),
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Manage Floors',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            Expanded(
                child: ReorderableListView(onReorder: _onReorder, children: [
              for (int index = 0; index < floortabs.length; index++)
                ListTile(
                  key: ValueKey(floortabs[index].index),
                  title: Text((floortabs[index].title.child as Text).data ??
                      "Unknown Floor"),
                  selected: selectedfloor == index,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            _rename(index);
                          },
                          icon: const Icon(Icons.edit)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedfloor == index;
                      _tabController.index = index;
                    });
                    Navigator.pop(context);
                  },
                )
            ]))
          ],
        ),
      ),
      body: TabBarView(
        children: floortabs.map((tab) => tab.content).toList(),
        controller: _tabController,
      ),
    );
  }

  void addtab() {
    String newfloor = '';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add New Floor'),
            content: TextField(
              onChanged: (value) {
                newfloor = value;
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  if (newfloor.isNotEmpty) addtabdetails(newfloor);
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              )
            ],
          );
        });
  }

  void addtabdetails(String floorname) {
    Floorplan newpainter = Floorplan();
    painter.add(newpainter);
    floortabs.add(TabData(
      index: floortabs.length + 1,
      title: Tab(
        child: Text(floorname),
      ),
      content: newpainter,
    ));

    setState(() {
      _tabController.dispose();
      _tabController = TabController(length: floortabs.length, vsync: this);
      _tabController.index = floortabs.length - 1;
    });
  }

  void _onReorder(int oldindex, int newindex) {
    if (newindex > oldindex) {
      newindex -= 1;
    }
    final TabData tab = floortabs.removeAt(oldindex);
    floortabs.insert(newindex, tab);

    setState(() {
      _tabController.dispose();
      _tabController = TabController(length: floortabs.length, vsync: this);
    });
  }

  void _rename(int tabindex) {
    String floorname = floortabs[tabindex].title.child.toString();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Rename Floor'),
            content: TextField(
              onChanged: (value) {
                floorname = value;
              },
              decoration: const InputDecoration(hintText: 'Floor name'),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    if (floorname.isNotEmpty) {
                      print(floorname);
                      setState(() {
                        floortabs[tabindex] = TabData(
                          index: tabindex + 1,
                          title: Tab(
                            child: Text(floorname),
                          ),
                          content: floortabs[tabindex].content,
                        );
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Rename')),
            ],
          );
        });
  }

  void deletetab(int floorindex) {
    String floorname =
        (floortabs[floorindex].title.child as Text).data ?? "Unknown Floor";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm Delete Floor'),
            content: RichText(
                text: TextSpan(
                    text: 'Are you sure you want to delete ',
                    style: TextStyle(color: Colors.black),
                    children: [
                  TextSpan(
                      text: floorname,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(text: '?')
                ])),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    floortabs.removeAt(floorindex);
                    _tabController.dispose();
                    _tabController =
                        TabController(length: floortabs.length, vsync: this);
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
        });
  }
}
