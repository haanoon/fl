import 'package:flutter/material.dart';

class Painter2 extends StatefulWidget {
  final List<Offset> initialoffsets; // Offsets passed when creating Painter2
  const Painter2({super.key, required this.initialoffsets});

  @override
  State<Painter2> createState() => _PainterState();
}

class _PainterState extends State<Painter2> {
  late List<Offset> offsets; // Local state for offsets
  int? pointIndex;

  @override
  void initState() {
    super.initState();
    // Initialize local offsets from the passed initialoffsets
    offsets = widget.initialoffsets.map((e) => e).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 30.0),
        child: GestureDetector(
          onPanStart: (details) {
            pointIndex = getPoint(details.localPosition);
          },
          onPanUpdate: (details) {
            if (pointIndex != null) {
              setState(() {
                const double gridSize = 20.0;
                double minx = 0, miny = 0;
                double maxx = 800, maxy = 800;
                double x =
                    (details.localPosition.dx / gridSize).round() * gridSize;
                double y =
                    (details.localPosition.dy / gridSize).round() * gridSize;
                x = x.clamp(minx, maxx);
                y = y.clamp(miny, maxy);
                offsets[pointIndex!] = Offset(x, y);
              });
            }
            print(details.localPosition);
          },
          onPanEnd: (details) {
            setState(() {
              pointIndex = null;
            });
          },
          child: Stack(
            children: [
              CustomPaint(
                // Pass the local offsets to PaintInstance
                painter: PaintInstance(offsets: offsets),
                size: const Size(double.infinity, double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to get the nearest point from user interaction
  int? getPoint(Offset pos) {
    double threshold = 20;
    for (int i = 0; i < offsets.length; i++) {
      if ((offsets[i] - pos).distance <= threshold) {
        return i;
      }
    }
    return null;
  }
}

class PaintInstance extends CustomPainter {
  final List<Offset> offsets; // Accept the offsets list

  PaintInstance({required this.offsets}); // Constructor

  @override
  void paint(Canvas canvas, Size size) {
    int i, j;

    // Grid points
    Paint gridPoint = Paint();
    gridPoint.color = Colors.black.withOpacity(0.3);
    for (i = 0; i <= 40; i++) {
      for (j = 0; j <= 40; j++) {
        double x = i * 20;
        double y = j * 20;
        canvas.drawCircle(Offset(x, y), 5, gridPoint);
      }
    }

    // Paint variable for fill-area
    Paint pathArea = Paint();
    pathArea.color = Colors.grey.withOpacity(0.3);
    pathArea.style = PaintingStyle.fill;
    pathArea.strokeWidth = 2;

    Paint pathBorder = Paint();
    pathBorder.strokeWidth = 8;
    pathBorder.style = PaintingStyle.stroke;
    pathBorder.color = const Color.fromARGB(255, 205, 205, 205);

    Path path = Path();
    path.moveTo(offsets[0].dx, offsets[0].dy);
    for (i = 0; i < offsets.length; i++) {
      path.lineTo(offsets[i].dx, offsets[i].dy);
    }
    path.close();
    canvas.drawPath(path, pathArea);
    canvas.drawPath(path, pathBorder);

    // Control points
    Paint point = Paint();
    point.color = Colors.grey;
    for (i = 0; i < offsets.length; i++) {
      canvas.drawCircle(offsets[i], 8, point);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
