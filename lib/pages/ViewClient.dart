import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class ViewClient extends StatelessWidget {
  String name;
  ViewClient(this.name);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new ViewClientWidget(name),
    );
  }
}

class ViewClientWidget extends StatefulWidget {
  String name;
  ViewClientWidget(this.name);

  @override
  ViewClientState createState() => new ViewClientState(name);
}

class ViewClientState extends State<ViewClientWidget> {
  String name;
  ViewClientState(this.name);

  // JSON data
  File jsonFile;
  Directory dir;
  String fileName = "clientsData.json";
  bool fileExist = false;
  Map<String, dynamic> fileContent;
  var clientList;

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
      clientList = fileContent.keys.toList();
    });
  }

   @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Zobacz klienta"),
          backgroundColor: Colors.green,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            new Card(
                child: new Column(
              children: <Widget>[
                new Text(name, style: new TextStyle(fontSize: 20.0),),
                new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
                new Row(
                  children: <Widget>[
                    new Text("NIP: ", style: new TextStyle(fontWeight: FontWeight.bold ),),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text("wdwd"),
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new Row(
                  children: <Widget>[
                    new Text("NIP: ", style: new TextStyle(fontWeight: FontWeight.bold ),),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text("efefef"),
                  ],
                )
              ],
            ))
          ],
        ));
  }

}