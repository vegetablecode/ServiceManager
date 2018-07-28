import 'package:elbiserwis/Client.dart';
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

  // client details
  Client client =
      new Client("nip", 0, 0, "deviceName", 0, 0.0, true, false, false, 0, 0.0);

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
      if ((fileExist) && (this.mounted))
        this.setState(
            () => fileContent = JSON.decode(jsonFile.readAsStringSync()));
      clientList = fileContent.keys.toList();
      client = Client.fromJson(fileContent[name]);
    });
  }

  void editClient() {
    print("tu sie bedzie edytowac");
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
                new Text(
                  name,
                  style: new TextStyle(fontSize: 20.0),
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
                new Row(
                  children: <Widget>[
                    new Text(
                      "NIP: ",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text(client.nip),
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new Row(
                  children: <Widget>[
                    new Text(
                      "okres umowy: ",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text(client.contractPer.toString()),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text("miesięcy")
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new Row(
                  children: <Widget>[
                    new Text(
                      "ryczałt: ",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text(client.rate.toString()),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text("zł")
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new Row(
                  children: <Widget>[
                    new Text(
                      "nazwa urządzenia: ",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text(client.deviceName),
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new Row(
                  children: <Widget>[
                    new Text(
                      "liczba darmowych kopii (czb): ",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text(client.freeCopies.toString()),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text("szt.")
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new Row(
                  children: <Widget>[
                    new Text(
                      "liczba darmowych kopii (kolor): ",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text(client.colorFreeCopies.toString()),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text("szt.")
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new Row(
                  children: <Widget>[
                    new Text(
                      "cena za stronę (czb): ",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text(client.pagePrice.toString()),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text("zł")
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new Row(
                  children: <Widget>[
                    new Text(
                      "cena za stronę (kolor): ",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text(client.colorPagePrice.toString()),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text("zł")
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new Row(
                  children: <Widget>[
                    new Text(
                      "rozliczenie: ",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text(client.quaterRate ? "kwartalne" : "miesięczne"),
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new Row(
                  children: <Widget>[
                    new Text(
                      "tonery zawarte w umowie: ",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text(client.quaterRate ? "tak" : "nie"),
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new Row(
                  children: <Widget>[
                    new Text(
                      "dzierżawa urządzenia: ",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: new EdgeInsets.only(left: 5.0)),
                    new Text(client.quaterRate ? "tak" : "nie"),
                  ],
                ),
              ],
            )),
            new Card(
              child: new Column(
                children: <Widget>[
                  new Text(
                    "Historia",
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "01.02.18: ",
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                      new Padding(padding: new EdgeInsets.only(left: 5.0)),
                      new Text("240 zł"),
                    ],
                  ),
                ],
              ),
            ),
            new Card(
              child: new Column(
                children: <Widget>[
                  new Text(
                    "Liczniki",
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
                ],
              ),
            ),
            new Card(
              child: new Column(
                children: <Widget>[
                  new Text(
                    "TODO",
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),
            new Column(
              children: <Widget>[
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new RaisedButton(
                  child: new Text("Dodaj stan licznika"),
                  color: Colors.blueAccent,
                  onPressed: editClient,
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new FlatButton(
                  child: new Text("Edytuj klienta"),
                  onPressed: editClient,
                ),
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new FlatButton(
                  child: new Text("Usuń klienta"),
                  onPressed: editClient,
                )
              ],
            )
          ],
        ));
  }
}
