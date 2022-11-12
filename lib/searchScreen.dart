import 'package:flutter/material.dart';

class TelaSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TCC - UNIP'),
          backgroundColor: Colors.blue[600],
          elevation: 4.0,
        ),
        body: SearchScreen());
  }
}

class SearchScreen extends StatefulWidget {
  @override
  ListViewHome createState() {
    return new ListViewHome();
  }
}

class ListViewHome extends State<SearchScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'AALLALA',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _textController.clear();
                          },
                          icon: const Icon(Icons.clear)),
                    )),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context, _textController.text);
                  },
                  color: Colors.blue,
                  child: Text('Post', style: TextStyle(color: Colors.white)),
                )
              ],
            )));
  }
}
