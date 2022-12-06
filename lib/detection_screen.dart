import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';
import 'second_screen_listview.dart';

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
  String _objectDetected = "";
  String _objectDetectedPopUp = "";

  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res;

    WidgetsFlutterBinding.ensureInitialized();
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print('Error: $e.code\nError Message: $e.message');
    }

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

  onSelect(model, objectDetected) {
    setState(() {
      _model = model;
      _objectDetected = objectDetected;
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
      appBar: _model != ""
          ? null
          : AppBar(
              title: Text('TCC - UNIP'),
              backgroundColor: Colors.blue[600],
              elevation: 4.0,
            ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://i.imgur.com/ZtIxMZd.png'),
                      /* https://i.imgur.com/WhZWsSB.png - Fundo transparente */
                      radius: 50.0,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'inBreeze - TCC Unip',
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight + Alignment(0, .3),
                    child: Text(
                      'Ciência da Computação',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Geovane Martins de Moraes - D895940'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Gabriel Garcia dos Santos - N449241'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Caio Tenório da Silva - F1001E0'),
              onTap: () {
                Navigator.of(context).pop();
              },
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
                        onPressed: () async {
                          var resultLabel = await _showTextInputDialog(context);

                          if (resultLabel != null) {
                            setState(() {
                              _objectDetectedPopUp =
                                  resultLabel.toLowerCase().trim();
                            });

                            try {
                              cameras = await availableCameras();
                              onSelect(ssd, _objectDetectedPopUp);
                            } on CameraException catch (e) {
                              print(
                                  'Error: $e.code\nError Message: $e.message');
                            }
                          }
                        },
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
                              semanticLabel: "Botão Pesquisar Objeto'",
                            ),
                          ],
                        )),
                    FlatButton(
                        color: Colors.white,
                        // child: const Text(mobilenet),
                        onPressed: () => onSelect(ssd, ''),
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
                              semanticLabel: "Botão Câmera'",
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
                    _model,
                    _objectDetected),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_model == "") {
            _irParaProximaPagina(context);
          } else {
            setState(() {
              _model = "";
            });
          }
        },
        backgroundColor: Colors.white,
        label: Text(_model == "" ? 'Listar' : 'Voltar'),
        icon: Icon(_model == "" ? Icons.view_list : Icons.keyboard_return),
      ),
    );
  }

  _irParaProximaPagina(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaListagemItens()));

    if (result != null) {
      WidgetsFlutterBinding.ensureInitialized();
      try {
        cameras = await availableCameras();
        onSelect(ssd, result);
      } on CameraException catch (e) {
        print('Error: $e.code\nError Message: $e.message');
      }
    }
  }

  final _textFieldController = TextEditingController();

  Future<String> _showTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Digite o objeto que quer procurar'),
            content: TextField(
              autofocus: true,
              controller: _textFieldController,
              decoration: const InputDecoration(
                  hintText: "Digite ou fale através do microfone"),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text("Cancelar"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(
                    context,
                    _textFieldController.text != ""
                        ? _textFieldController.text
                        : null),
              ),
            ],
          );
        });
  }
}
