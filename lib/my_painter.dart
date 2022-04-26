import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as image_library;
import 'package:logging/logging.dart';
import 'package:pixel_lego_art/my_painter_canvas.dart';
import 'package:pixel_lego_art/tile.dart';

final log = Logger('MyPainter');

class MyPainter extends StatefulWidget {
  const MyPainter({Key? key}) : super(key: key);

  @override
  State<MyPainter> createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> {
  late List<Tile> tiles;
  late Size size;
  int tilesWidth = 27;
  int tilesHeight = 42;
  int counter = 0;
  ui.Image? painterImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;

    double tileWidth = (size.width / tilesWidth).floorToDouble();
    double tileHeight = (size.height / tilesHeight).floorToDouble();
    tiles = List.generate(tilesWidth * tilesHeight, (index) {
      Tile tile = Tile();
      tile.color = Colors.black;
      tile.x = (tileWidth * index) % (tilesWidth * tileWidth);
      tile.y = tileHeight * (index / tilesWidth).floor();
      tile.width = tileWidth.toDouble();
      tile.height = tileHeight.toDouble();
      return tile;
    });

    log.fine('matrix ready');
    super.didChangeDependencies();
    loadUiImage('assets/images/lego.png');
    loadImageFromPath('assets/images/pika.jpg');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          try {
            var image = await ImagePicker().pickImage(
                source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
            Uint8List readAsBytes = await image!.readAsBytes();
            loadImageToProcess(readAsBytes);
          } catch (e) {
            log.shout('exception $e');
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: painterImage == null
            ? const CircularProgressIndicator()
            : CustomPaint(
                child: Container(),
                painter: MyPainterCanvas(tiles: tiles, image: painterImage!),
              ),
      ),
    );
  }

  Future loadUiImage(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    setState(() {
      painterImage = image;
    });
  }

  loadImageToProcess(Uint8List bytes) async {
    var decodeImage = image_library.decodeImage(bytes);
    var resize = image_library.copyResize(decodeImage!,
        width: tilesWidth, height: tilesHeight);
    var data = resize.data;
    for (var i = 0; i < data.length; i++) {
      var a = image_library.getAlpha(data[i]);
      var r = image_library.getRed(data[i]);
      var g = image_library.getGreen(data[i]);
      var b = image_library.getBlue(data[i]);
      tiles[i].color = Color.fromARGB(a, r, g, b);
    }
    setState(() {});
  }

  loadImageFromPath(String imageAssetPath) async {
    final ByteData byteData = await rootBundle.load(imageAssetPath);
    final Uint8List bytes = byteData.buffer.asUint8List();
    loadImageToProcess(bytes);
  }
}
