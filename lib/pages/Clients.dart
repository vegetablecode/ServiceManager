import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import './ViewClient.dart' as viewClient;

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

  void view(String name) {
    setState(() {
      print(name);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => viewClient.ViewClient(name)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new ListView.builder(
            itemCount: fileContent == null ? 0 : fileContent.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                  child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(left: 5.0),
                      ),
                      new Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      new Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: 5.0),
                      ),
                      new Text(clientList[index]),
                    ],
                  ),
                  new IconButton(
                    icon: new Icon(Icons.remove_red_eye),
                    color: Colors.blueAccent,
                    onPressed: (){view(clientList[index]);},
                  )
                ],
              ));
            }));
  }
}
