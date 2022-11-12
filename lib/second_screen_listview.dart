import 'package:flutter/material.dart';

class TelaListagemItens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Escolha o objeto para ser focado.'),
          backgroundColor: Colors.blue[600],
          elevation: 4.0,
        ),
        body: ListViewHomeLayout());
  }
}

class ListViewHomeLayout extends StatefulWidget {
  @override
  ListViewHome createState() {
    return new ListViewHome();
  }
}

class ListViewHome extends State<ListViewHomeLayout> {
  List<String> titles = ["Pessoa", "Copo", "Mouse", "Teclado", "Televisão"];

  final subtitles = [
    "Clique aqui para o foco ser detectar 'Pessoa'",
    "Clique aqui para o foco ser detectar 'Copo'.",
    "Clique aqui para o foco ser detectar 'Mouse'.",
    "Clique aqui para o foco ser detectar 'Teclado'.",
    "Clique aqui para o foco ser detectar 'Televisão/Monitor'.",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                  onTap: () {
                    Navigator.pop(context, titles[index]);
                  },
                  title: Text(titles[index]),
                  subtitle: Text(subtitles[index])));
        });
  }
}
