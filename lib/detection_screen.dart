import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";
  List<CameraDescription> cameras;
  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res;
    cameras = await availableCameras();

    switch (_model) {
      case yolo:
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        );
        break;

      case mobilenet:
        res = await Tflite.loadModel(
            model: "assets/mobilenet_v1_1.0_224.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt");
        break;

      default:
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    }
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('TCC - UNIP'),
        backgroundColor: Colors.blue[600],
        elevation: 4.0,
        actions: [
          IconButton(icon: Icon(Icons.mic), onPressed: null),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('inBreeze - TCC Unip Ciência da Computação'),
            ),
            ListTile(
              title: const Text('Geovane Martins de Moraes - D895940'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Gabriel Garcia - XXXXXX'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Caio Tenório - XXXXXX'),
              onTap: () {},
            )
          ],
        ),
      ),
      body: _model == ""
          ? Center(
              child: Container(
                margin: const EdgeInsets.all(50),
                height: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                        color: Colors.white,
                        onPressed: () => {},
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        padding: new EdgeInsets.all(40),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              color: Colors.grey[850],
                              size: 50.0,
                            ),
                          ],
                        )),
                    FlatButton(
                        color: Colors.white,
                        // child: const Text(mobilenet),
                        onPressed: () => onSelect(ssd),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        padding: new EdgeInsets.all(40),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.camera_alt,
                              color: Colors.grey[850],
                              size: 50.0,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                Camera(
                  cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.white,
        label: const Text('Listar'),
        icon: const Icon(Icons.view_list),
      ),
    );
  }
}
