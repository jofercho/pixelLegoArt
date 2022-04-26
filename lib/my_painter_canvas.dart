import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:pixel_lego_art/tile.dart';

class MyPainterCanvas extends CustomPainter {
  List<Tile> tiles;
  ui.Image image;

  MyPainterCanvas({required this.tiles, required this.image});

  @override
  void paint(Canvas canvas, Size size) async{
    for (Tile tile in tiles) {
      
      Rect rect =
          Rect.fromLTWH(tile.x, tile.y, tile.width, tile.height);
      paintImage(canvas: canvas, rect: rect, image: image, fit: BoxFit.cover, colorFilter: ColorFilter.mode(tile.color, BlendMode.overlay));
      // canvas.drawImage(
      //     image, Offset(tile.x, tile.y), paint);

      // var paint = Paint()..color = tile.color;
      // canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
