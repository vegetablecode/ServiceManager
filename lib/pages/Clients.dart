import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Clients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new ClientsWidget(),
    );
  }
}

class ClientsWidget extends StatefulWidget {
  @override
  ClientsState createState() => new ClientsState();
}

class ClientsState extends State<ClientsWidget> {
  // JSON data
  File jsonFile;
  Directory dir;
  String fileName = "clientsData.json";
  bool fileExist = false;
  Map<String, dynamic> fileContent;

  // JSON create & read
  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExist = jsonFile.existsSync();
      if (fileExist)
        this.setState(
            () => fileContent = JSON.decode(jsonFile.readAsStringSync()));
    });
  }

  void onPressed() {
    setState(() {
      print(fileContent.toString());
      print(fileContent.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          new RaisedButton(
            child: new Text("Check!"),
            color: Colors.blueAccent,
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
