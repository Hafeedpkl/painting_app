import 'package:flutter/material.dart';

class DrawingPoint {
  int id;
  List<Offset> offset;
  Color color;
  double width;
  DrawingPoint(
      {this.id = -1,
      this.offset = const [],
      this.color = Colors.black,
      this.width = 2});

  DrawingPoint copyWith({List<Offset>? offset}) {
    return DrawingPoint(
        id: id, color: color, width: width, offset: offset ?? this.offset);
  }
}
