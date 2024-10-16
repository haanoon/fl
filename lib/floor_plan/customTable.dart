import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Customtable extends StatefulWidget {
  const Customtable({super.key});

  @override
  State<Customtable> createState() => _CustomtableState();
}

class _CustomtableState extends State<Customtable> {
  //height and width of table
  double width = 100;
  double height = 100;
  double minWidth = 40;
  double minHeight = 40;
  double maxWidth = 400;
  double maxHeight = 400;
  //button visibility
  bool edit = false;
  bool showOpt = false;
  //colors
  Color shadowColor = const Color(0xffe1e0e0);
  Color borderColor = const Color(0xffe1e0e0);
  Color tableBody = const Color(0xfff9f9f9);
  Color button = const Color(0xff1175a6);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              edit = true;
              tableBody = const Color(0xff1175a6);
            });
          },
          child: Container(
            height: height + 100,
            width: width + 300,
            child: Stack(
              alignment: Alignment.center, // Center the elements in the stack
              children: [
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 5,
                        offset: const Offset(-3, 7),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: tableBody,
                  ),
                ),
                // show options icon
                if (edit)
                  Positioned(
                    right: 90,
                    top: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          shape: BoxShape.circle,
                          color: Colors.white),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              showOpt = !showOpt;
                            });
                          },
                          icon: Icon(
                            Icons.more_horiz,
                            size: 25,
                            color: button,
                          )),
                    ),
                  ),
                //show dragging point
                if (edit)
                  Positioned(
                    right: 90,
                    bottom: 20,
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            shape: BoxShape.circle,
                            color: button),
                        height: 25,
                        width: 25,
                      ),
                      //resizing the table
                      onPanUpdate: (details) {
                        setState(() {
                          showOpt = false;
                          width = clampDouble(
                              width + details.delta.dx, minWidth, maxWidth);
                          height = clampDouble(
                              height + details.delta.dy, minHeight, maxHeight);
                        });
                      },
                    ),
                  ),
                //show options
                if (showOpt)
                  Positioned(
                    right: 0,
                    top: 70,
                    child: Container(
                        width: 180,
                        height: 100,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          children: [
                            editButton(Icons.edit_outlined, "Edit"),
                            editButton(Icons.delete_outline_rounded, "Delete")
                          ],
                        )),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//edit option buttons
  Widget editButton(IconData icon, String option) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero))),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, color: Colors.black),
              Text(
                option,
                style: const TextStyle(color: Colors.black),
              )
            ],
          )),
    );
  }
}
