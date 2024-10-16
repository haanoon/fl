import 'package:flutter/material.dart';
import 'package:tabmanagement/floor_plan/boundaryWall.dart';
import 'package:tabmanagement/floor_plan/tableType.dart';

class Floorplan extends StatefulWidget {
  const Floorplan({super.key});

  @override
  State<Floorplan> createState() => _FloorplanState();
}

class _FloorplanState extends State<Floorplan> {
  List<Rect> widgetPosition = []; //position
  List<Type> widgetTypes = []; //type of widget circle or square
  //function for adding new tables
  void addWidget(Offset offset, Type widgetType) {
    setState(() {
      widgetPosition
          .add(Rect.fromCenter(center: offset, width: 150, height: 150));
      widgetTypes.add(widgetType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 100,
            color: Colors.grey[200],
            child: const Center(
              child: Column(
                children: [
                  //circle table
                  CircleWidget(),
                  //square table
                  SquareWidget(),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                DragTarget(
                  onAcceptWithDetails: (details) {
                    if (details.data is circleData) {
                      //adding circle table
                      addWidget(details.offset, Circletable);
                    } else if (details.data is squareData) {
                      //adding square table
                      addWidget(details.offset, SquareTable);
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    return const Boundarywall();
                  },
                ),
                //for saving the table type
                for (int i = 0; i < widgetPosition.length; i++)
                  widgetTypes[i] == Circletable
                      ? Circletable(
                          initialRect: widgetPosition[i],
                          onChanged: (newRect) {
                            setState(() {
                              widgetPosition[i] = newRect;
                            });
                          },
                        )
                      : SquareTable(
                          initialRect: widgetPosition[i],
                          onChanged: (newRect) {
                            setState(() {
                              widgetPosition[i] = newRect;
                            });
                          },
                        ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
