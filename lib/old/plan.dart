import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Rect rect = Rect.fromCenter(
    center: MediaQuery.of(context).size.center(Offset.zero),
    width: 150,
    height: 150,
  );
  bool clicked = false;
  Color colorTable = Color(0xfff9f9f9);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          TransformableBox(
            allowContentFlipping: false,
            rect: rect,
            clampingRect: Offset.zero & MediaQuery.sizeOf(context),
            onChanged: (result, event) {
              setState(() {
                rect = result.rect;
              });
            },
            onTap: () {
              setState(() {
                colorTable = const Color.fromARGB(255, 1, 87, 155);
              });
            },
            contentBuilder: (context, rect, flip) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffe1e0e0)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffe1e0e0),
                      blurRadius: 5,
                      offset: Offset(-3, 7),
                    )
                  ],
                  color: colorTable,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
