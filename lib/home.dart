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

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res;
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
            // model:
            // "object_detection_mobile_object_localizer_v1_1_default_1.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt");
        break;

      // case posenet:
      //   res = await Tflite.loadModel(
      //       model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
      //   break;

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
          IconButton(icon: Icon(Icons.search), onPressed: null),
        ],
        leading: Icon(Icons.list),
      ),
      body: _model == ""
          ? Container(
              margin: const EdgeInsets.all(50),
              width: 1000,
              height: 130,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                      color: Colors.white,
                      onPressed: () => {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      padding: new EdgeInsets.all(40),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.view_list,
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
                          borderRadius: BorderRadius.all(Radius.circular(16))),
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
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
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
    );
  }
}
