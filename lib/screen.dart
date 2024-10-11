import 'package:dynamic_tabbar/dynamic_tabbar.dart';

import 'package:flutter/material.dart';
import 'package:tabmanagement/old/painter2.dart';
import 'package:tabmanagement/tabs.dart';

class Floor3 extends StatefulWidget {
  const Floor3({super.key});

  @override
  State<Floor3> createState() => _Floor3State();
}

class _Floor3State extends State<Floor3> with TickerProviderStateMixin {
  List<TabData> floortabs = [];
  List<Painter2> painter = [];

  late TabController _tcontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tcontroller = TabController(length: floortabs.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Floors'),
        actions: [
          IconButton(
            onPressed: () {
              addtab();
            },
            icon: Icon(Icons.add),
          ),
          if (floortabs.isNotEmpty)
            IconButton(
              onPressed: () {
                deletetab(_tcontroller.index);
              },
              icon: Icon(Icons.delete),
            )
        ],
        bottom: DragTabBar(
          onTap: (index) {
            _tcontroller.index = index;
          },
          tabs: floortabs.map((e) => e.title).toList(),
          controller: _tcontroller,
          onReorder: (oldindex, newindex) {
            setState(() {
              if (newindex > oldindex) {
                newindex -= 1;
              }
              final TabData tab = floortabs.removeAt(oldindex);
              floortabs.insert(newindex, tab);
            });
          },
        ),
      ),
      body: TabBarView(
          controller: _tcontroller,
          children: floortabs.isNotEmpty
              ? floortabs.map((e) => e.content).toList()
              : [
                  const Center(
                    child: Text('No Floors Added Yet'),
                  )
                ]),
    );
  }

  void addtab() {
    String newfloor = '';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add New Floor'),
            content: TextField(
              onChanged: (value) {
                newfloor = value;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (newfloor.isNotEmpty) addtabdetails(newfloor);
                  Navigator.of(context).pop();
                },
                child: Text('Add'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'))
            ],
          );
        });
  }

  void addtabdetails(String floorname) {
    setState(() {
      Painter2 newpainter = const Painter2(
        initialoffsets: [
          Offset(20, 20),
          Offset(780, 20),
          Offset(780, 780),
          Offset(20, 780),
        ],
      );
      painter.add(newpainter);
      floortabs.add(TabData(
          index: floortabs.length + 1,
          title: Tab(
            icon: Icon(Icons.layers),
            child: Text(floorname),
          ),
          // content: Center(
          //   child: newpainter,
          // )
          content: floortabs.length % 2 == 0
              ? const Center(
                  child: Text('okokokokokokokok'),
                )
              : const Center(
                  child: Text('lalalalalalalalala'),
                )));
      _tcontroller.dispose;
      _tcontroller = TabController(length: floortabs.length, vsync: this);
    });
  }

  void deletetab(int floorindex) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Delete Floor'),
            content: Text('Are you sure you want to delete this floor'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    floortabs.removeAt(floorindex);
                    _tcontroller.dispose();
                    _tcontroller =
                        TabController(length: floortabs.length, vsync: this);
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Delete'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }
}
