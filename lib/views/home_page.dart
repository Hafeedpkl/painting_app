import 'package:flutter/material.dart';
import 'package:painting_app/core/app_color.dart';
import 'package:painting_app/model/drawing_point.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var availableColors = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown
  ];
  var historyDrawingPoint = <DrawingPoint>[];
  var drawingPoints = <DrawingPoint>[];
  DrawingPoint? currentDrawingPoint;
  var selectedColor = Colors.black;
  var selectedWidth = 2.0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        body: Stack(
          children: [
            canvasScreen(size),
            colorPalette(size),
            strokeSlider(mediaQuery)
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: selectedColor,
              shape: const CircleBorder(),
              heroTag: "Undo",
              onPressed: () {
                if (drawingPoints.isNotEmpty &&
                    historyDrawingPoint.isNotEmpty) {
                  setState(() {
                    drawingPoints.removeLast();
                  });
                }
              },
              child: const Icon(
                Icons.undo,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            FloatingActionButton(
              backgroundColor: selectedColor,
              shape: const CircleBorder(),
              heroTag: "Redo",
              onPressed: () {
                if (drawingPoints.length < historyDrawingPoint.length) {
                  final index = drawingPoints.length;
                  drawingPoints.add(historyDrawingPoint[index]);
                }
              },
              child: const Icon(
                Icons.redo,
                color: Colors.white,
              ),
            )
          ],
        ));
  }

  GestureDetector canvasScreen(Size size) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          currentDrawingPoint = DrawingPoint(
              id: DateTime.now().microsecondsSinceEpoch,
              offset: [details.localPosition],
              color: selectedColor,
              width: selectedWidth);
          if (currentDrawingPoint == null) return;
          drawingPoints.add(currentDrawingPoint!);
          historyDrawingPoint = List.of(drawingPoints);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          if (currentDrawingPoint == null) return;
          currentDrawingPoint = currentDrawingPoint!.copyWith(
              offset: currentDrawingPoint!.offset..add(details.localPosition));
          drawingPoints.last = currentDrawingPoint!;
          historyDrawingPoint = List.of(drawingPoints);
        });
      },
      onPanEnd: (details) {
        currentDrawingPoint = null;
      },
      child: CustomPaint(
        painter: DrawingPainter(drawingPoints: drawingPoints),
        child: SizedBox(
          height: size.height,
          width: size.width,
        ),
      ),
    );
  }

  Positioned strokeSlider(MediaQueryData mediaQuery) {
    return Positioned(
        top: mediaQuery.padding.top + 80,
        right: 5,
        bottom: 150,
        child: RotatedBox(
          quarterTurns: 3,
          child: Slider(
            value: selectedWidth,
            activeColor: Colors.black,
            min: 1,
            max: 20,
            onChanged: (value) {
              setState(() {
                selectedWidth = value;
              });
            },
          ),
        ));
  }

  SafeArea colorPalette(Size size) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: size.height * 0.1,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = availableColors[index];
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: availableColors[index],
                      shape: BoxShape.circle,
                      border: selectedColor == availableColors[index]
                          ? Border.all(color: AppColor.primaryColor, width: 4)
                          : null),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 8,
            ),
            itemCount: availableColors.length,
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;
  DrawingPainter({required this.drawingPoints});
  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;
      for (var i = 0; i < drawingPoint.offset.length; i++) {
        bool notLastOffset = i != drawingPoint.offset.length - 1;
        if (notLastOffset) {
          final current = drawingPoint.offset[i];
          final next = drawingPoint.offset[i + 1];
          canvas.drawLine(current, next, paint);
        } else {
          // nothing :)
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
