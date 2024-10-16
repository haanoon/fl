import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';

class Circletable extends StatefulWidget {
  final Rect initialRect;
  final Function(Rect) onChanged;
  const Circletable({
    super.key,
    required this.initialRect,
    required this.onChanged,
  });

  @override
  State<Circletable> createState() => _CircletableState();
}

//Colors
Color shadowColor = const Color(0xffe1e0e0);
Color borderColor = const Color(0xffe1e0e0);
Color tableBody = const Color(0xfff9f9f9);

class _CircletableState extends State<Circletable> {
  late Rect rect;

  @override
  void initState() {
    super.initState();
    rect = widget.initialRect;
  }

  @override
  Widget build(BuildContext context) {
    return TransformableBox(
      allowContentFlipping: false,
      rect: rect,
      clampingRect: Offset.zero & MediaQuery.sizeOf(context),
      onChanged: (result, event) {
        setState(() {
          rect = result.rect;
        });
        widget.onChanged(rect);
      },
      contentBuilder: (context, rect, flip) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 5,
                offset: const Offset(-3, 7),
              ),
            ],
            borderRadius: BorderRadius.circular(100),
            color: tableBody,
          ),
        );
      },
    );
  }
}

// SquareTable
class SquareTable extends StatefulWidget {
  final Rect initialRect;
  final Function(Rect) onChanged;

  const SquareTable({
    super.key,
    required this.initialRect,
    required this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SquareTableState createState() => _SquareTableState();
}

class _SquareTableState extends State<SquareTable> {
  late Rect rect;

  @override
  void initState() {
    super.initState();
    rect = widget.initialRect;
  }

  @override
  Widget build(BuildContext context) {
    return TransformableBox(
      allowContentFlipping: false,
      rect: rect,
      clampingRect: Offset.zero & MediaQuery.sizeOf(context),
      onChanged: (result, event) {
        setState(() {
          rect = result.rect;
        });
        widget.onChanged(rect);
      },
      contentBuilder: (context, rect, flip) {
        return Container(
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
        );
      },
    );
  }
}

// Circle Widget for dragging
class CircleWidget extends StatelessWidget {
  const CircleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Draggable<circleData>(
      data: circleData(),
      feedback: const Circle(),
      childWhenDragging: Container(),
      child: const Circle(),
    );
  }
}

// Square Widget for dragging
class SquareWidget extends StatelessWidget {
  const SquareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Draggable<squareData>(
      data: squareData(),
      feedback: const Square(),
      childWhenDragging: Container(),
      child: const Square(),
    );
  }
}

// Circle Shape
class Circle extends StatelessWidget {
  const Circle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffe1e0e0),
            blurRadius: 5,
            offset: Offset(-3, 7),
          ),
        ],
        shape: BoxShape.circle,
        color: tableBody,
      ),
    );
  }
}

// Square Shape
class Square extends StatelessWidget {
  const Square({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
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
    );
  }
}

// Widget Data for Circle
// ignore: camel_case_types
class circleData {}

// Widget Data for Square
// ignore: camel_case_types
class squareData {}
