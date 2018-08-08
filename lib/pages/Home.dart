import 'package:flutter/material.dart';
import 'package:elbiserwis/styles/MyColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<HomeWidget> {
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
      if ((fileExist) && (this.mounted))
        this.setState(
            () => fileContent = JSON.decode(jsonFile.readAsStringSync()));
    });
  }

  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExist = true;
    file.writeAsStringSync(JSON.encode(content));
  }

  void writeAsNewFile(Map<String, dynamic> content) {
    createFile(content, dir, fileName);
    this.setState(() => fileContent = JSON.decode(jsonFile.readAsStringSync()));
    print("A new file with data has been created!");
  }

  // save to Firebase
  void saveData(File content) async {
    var url = "https://elbiserwis-42e05.firebaseio.com/clients.json";
    var httpClient = Client();
    var response = await httpClient.post(url, body: JSON.encode(fileContent));
    print("response=" + response.body);
  }

  // get data from Firebase
  void loadData() async {
    var url = "https://elbiserwis-42e05.firebaseio.com/clients.json";
    var httpClient = Client();
    var response = await httpClient.get(url);
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    // logo image
    var assetsImage = new AssetImage("assets/branding/logo.png");
    var logoImg = new Image(
      image: assetsImage,
      width: 480.0,
    );
    // Scaffold widget
    return new Scaffold(
      backgroundColor: MyColors.background,
      body: new Center(
        child: new Container(
            padding: EdgeInsets.all(20.0),
            child: new Card(
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.all(20.0),
                    child: logoImg,
                  ),
                  new Text(
                    "elbiSerwis",
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  new RaisedButton(
                    child: new Text("cumon"),
                    onPressed: () {
                      saveData(jsonFile);
                    },
                  ),
                  new RaisedButton(
                    child: new Text("pobierz"),
                    onPressed: () {
                      loadData();
                    },
                  )
                ],
              ),
            )),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("firebase")),
      body: new StreamBuilder(
          stream: Firestore.instance.collection('baby').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemExtent: 25.0,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  return new Text(" ${ds['name']} ${ds['votes']}");
                });
          }),
    );
  }*/
}
