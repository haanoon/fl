import 'package:flutter/material.dart';

class Boundarywall extends StatefulWidget {
  const Boundarywall({super.key});

  @override
  State<Boundarywall> createState() => _BoundarywallState();
}

//Sizes
double gridSpace = 20.0;
int gridCount = 40;
double minx = 40, miny = 40;
double maxx = 840, maxy = 840;

//Offset list
List<Offset> offsets = [
  Offset(minx + gridSpace, minx + gridSpace), //top left
  Offset(maxy - gridSpace, minx + gridSpace), //top right

  Offset(maxy - gridSpace, maxy - gridSpace), //bottom left
  Offset(minx + gridSpace, maxy - gridSpace), //bottom right
];
//current point index
int? pointIndex;
//Colors
Color dotMatrix = const Color(0xfff6f6f8);
Color fillArea = const Color(0xfff7f6f7).withOpacity(0.3);
Color border = const Color(0xffe0e1e0);
Color disablePoint = const Color(0xffe0e1e0);
Color enablePoint = const Color(0xff1175a6);

class _BoundarywallState extends State<Boundarywall> {
  //button visibility
  bool showButton = false, showDel = false;
  //button offset
  Offset? buttonOffset, delOffset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: GestureDetector(
        //get point on drag start
        onPanStart: (details) {
          pointIndex = getPoint(details.localPosition);
          showButtonFn();
        },
        //update point position while dragging
        onPanUpdate: (details) => pointDrag(details),
        //place the point to a dot on matrix
        onPanEnd: (details) {
          if (pointIndex != null) {
            setState(() {
              offsets[pointIndex!] = snapToGrid(offsets[pointIndex!]);
              buttonOffset = offsets[pointIndex!];
            });
          }
        },
        //function when tapped on border or a point
        onTapUp: (details) {
          _tapfn(details.localPosition);
        },
        child: Stack(
          children: [
            //Canvas for boundary wall
            CustomPaint(
              painter: PaintInstance(),
              size: const Size(double.infinity,
                  double.infinity), // Set the custom canvas size
            ),
            //Options icon button
            if (showButton)
              Positioned(
                  left: buttonOffset!.dx - 18, // Center horizontally
                  top: buttonOffset!.dy - 48,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          showDel = !showDel;
                        });
                      },
                      icon: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          Icons.more_horiz,
                          size: 25,
                          color: enablePoint,
                        ),
                      ))),
            //Delete Button
            if (showDel)
              Positioned(
                  left: buttonOffset!.dx - 0, // Center horizontally
                  top: buttonOffset!.dy,
                  child: SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.zero))),
                        onPressed: () {
                          offsets.removeAt(pointIndex!);
                          setState(() {
                            showButton = false;
                            showDel = false;
                            pointIndex = null;
                          });
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.black,
                            ),
                            Text(
                              "Delete",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        )),
                  ))
          ],
        ),
      )),
    );
  }

//funtion to control free dragging
  void pointDrag(DragUpdateDetails details) {
    if (pointIndex != null) {
      setState(() {
        //get current x,y axis location
        double x = details.localPosition.dx;
        double y = details.localPosition.dy;
        //make it dragged inside the dt matrix space only
        x = x.clamp(minx, maxx);
        y = y.clamp(miny, maxy);
        //update point and button offset
        offsets[pointIndex!] = Offset(x, y);
        buttonOffset = Offset(x, y);
      });
    }
  }

  //funtion to control tap
  void _tapfn(Offset value) {
    setState(() {
      //get the index of point tapped
      pointIndex = getPoint(value);
    });
    if (pointIndex != null) {
      //if its an existing point show the option button
      showButtonFn();
    } else {
      //if tapped on border creae a new point
      setState(() {
        showButton = false;
        showDel = false;
      });
      //get the nearest edge
      int? nearestEdge = getNearestEdge(value);
      //get the dot on matrix for placing new point
      Offset nearestGridPoint = snapToGrid(value);

      if (nearestEdge != null && isPointOnGrid(nearestGridPoint)) {
        setState(() {
          // Insert new point at the snapped grid location and split the edge
          offsets.insert(nearestEdge + 1, nearestGridPoint);
          pointIndex = nearestEdge + 1;
          showButtonFn();
        });
      }
    }
  }

  //function to enable and disable button
  void showButtonFn() {
    int length = offsets.length;
    if (length <= 3) {
    } else {
      setState(() {
        showButton = true;
        showDel = false;
        buttonOffset = offsets[pointIndex!];
      });
    }
  }

  //fuction for getting the nearest point from user interaction
  int? getPoint(Offset pos) {
    double threshold = 20;
    for (int i = 0; i < offsets.length; i++) {
      if ((offsets[i] - pos).distance <= threshold) {
        return i;
      }
    }
    return null;
  }

// Function to get the nearest edge where the user tapped
  int? getNearestEdge(Offset pos) {
    double threshold = 10.0;
    for (int i = 0; i < offsets.length; i++) {
      int nextIndex = (i + 1) % offsets.length;
      if (isPointNearLineSegment(
          pos, offsets[i], offsets[nextIndex], threshold)) {
        return i;
      }
    }
    return null;
  }

// function to check if a point is near a line segment
  bool isPointNearLineSegment(Offset p, Offset a, Offset b, double threshold) {
    double distance = distanceFromPointToLine(p, a, b);
    return distance <= threshold;
  }

//function to get shortest distance from a given point to a line segment
  double distanceFromPointToLine(Offset p, Offset a, Offset b) {
    // Calculate vector components
    final double dx = b.dx - a.dx;
    final double dy = b.dy - a.dy;

    // Handle the case where the line segment is of zero length
    if (dx == 0 && dy == 0) {
      return (p - a).distance; // Direct distance to point A
    }

    // Calculate the projection of point p onto the line defined by points a and b
    double t = ((p.dx - a.dx) * dx + (p.dy - a.dy) * dy) / (dx * dx + dy * dy);

    // Clamp the value of t to the range [0, 1] to stay within the segment
    t = t.clamp(0.0, 1.0);

    // Calculate the closest point on the line segment
    Offset closestPoint = Offset(a.dx + t * dx, a.dy + t * dy);

    // Return the distance from point p to the closest point on the line segment
    return (p - closestPoint).distance;
  }

//function to place the new point or dragged point to matrix dots
  Offset snapToGrid(Offset pos) {
    double x = (pos.dx / gridSpace).round() * gridSpace;
    double y = (pos.dy / gridSpace).round() * gridSpace;
    return Offset(x, y);
  }

// Function to check if a point is on the grid
  bool isPointOnGrid(Offset point) {
    const double gridSpace = 20.0;
    return (point.dx % gridSpace == 0) && (point.dy % gridSpace == 0);
  }
}

//canvas painter instance
class PaintInstance extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    int i, j;
    //grid points
    Paint gridPoint = Paint();
    gridPoint.color = dotMatrix;
    for (i = 0; i <= gridCount; i++) {
      for (j = 0; j <= gridCount; j++) {
        double x = i * gridSpace + 40;
        double y = j * gridSpace + 40;
        canvas.drawCircle(Offset(x, y), 5, gridPoint);
      }
    }

    //Paint variable for fill-area
    Paint pathArea = Paint();
    pathArea.color = fillArea;
    pathArea.style = PaintingStyle.fill;
    pathArea.strokeWidth = 2;
    //Paint variable for polygon border
    Paint pathBorder = Paint();
    pathBorder.strokeWidth = 8;
    pathBorder.style = PaintingStyle.stroke;
    pathBorder.color = border;
    Path path = Path();
    path.moveTo(offsets[0].dx, offsets[0].dy);
    for (i = 0; i < offsets.length; i++) {
      path.lineTo(offsets[i].dx, offsets[i].dy);
    }
    path.close();
    canvas.drawPath(path, pathArea);
    canvas.drawPath(path, pathBorder);

    //control points
    Paint point = Paint(); //points
    Paint shadow = Paint(); //shadow for points
    point.color = disablePoint;
    shadow.color = const Color.fromARGB(255, 218, 218, 218);
    for (i = 0; i < offsets.length; i++) {
      canvas.drawCircle(offsets[i], 10, shadow);
      if (i == pointIndex) {
        point.color = enablePoint;
      } else {
        point.color = disablePoint;
      }

      canvas.drawCircle(offsets[i], 8, point);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
