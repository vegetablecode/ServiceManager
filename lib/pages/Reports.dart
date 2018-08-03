import 'package:elbiserwis/Client.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:elbiserwis/styles/MyColors.dart';

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new ReportsWidget(),
    );
  }
}

class ReportsWidget extends StatefulWidget {
  @override
  ReportsState createState() => new ReportsState();
}

class ReportsState extends State<ReportsWidget> {
  // JSON data
  File jsonFile;
  Directory dir;
  String fileName = "clientsData.json";
  bool fileExist = false;
  Map<String, dynamic> fileContent;

  var clientList; // the list of client names
  List<Client> clients = new List();
  List<int> taskIndexes = new List();

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
      if (fileContent != null) {
        clientList = fileContent.keys.toList();
        for (int i = 0; i < fileContent.length; i++) {
          clients.add(getClient(fileContent[clientList[i]]));
        }
        taskIndexes = getTaskIndexes(clients);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: MyColors.background,
        body: new ListView.builder(
            itemCount: clients == null ? 0 : getNumbOfTasks(clients),
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                  color: MyColors.card,
                  child: new Container(
                    padding: new EdgeInsets.all(5.0),
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          clientList[index],
                          style: new TextStyle(fontSize: 20.0),
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(bottom: 20.0),
                        ),
                        new Row(
                          children: <Widget>[
                            new Text(
                              "Pilne zadania:",
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        new Card(
                            color: (getImportantTasks(
                                        clients[taskIndexes[index]].tasks) ==
                                    "")
                                ? MyColors.noTask
                                : MyColors.importantTask,
                            child: new Container(
                              padding: new EdgeInsets.all(5.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Icon(Icons.warning),
                                  new Padding(
                                      padding: new EdgeInsets.only(left: 5.0)),
                                  new Text(getImportantTasks(
                                      clients[taskIndexes[index]].tasks)),
                                ],
                              ),
                            )),
                        new Padding(
                          padding: new EdgeInsets.only(bottom: 20.0),
                        ),
                        new Row(
                          children: <Widget>[
                            new Text(
                              "Zadania przy następnej wizycie:",
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        new Card(
                          color: (getStandardTasks(
                                      clients[taskIndexes[index]].tasks) ==
                                  "")
                              ? MyColors.noTask
                              : MyColors.task,
                          child: new Container(
                            padding: new EdgeInsets.all(5.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Icon(Icons.list),
                                new Padding(
                                    padding: new EdgeInsets.only(left: 5.0)),
                                new Text(getStandardTasks(
                                    clients[taskIndexes[index]].tasks)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            }));
  }

  // helper
  int getNumbOfTasks(List<Client> clients) {
    int counter = 0;
    for (int i = 0; i < clients.length; i++) {
      if (clients[i].tasks.length > 1) counter++;
    }
    print(counter);
    return counter;
  }

  List<int> getTaskIndexes(List<Client> clients) {
    List<int> indexes = new List();
    for (int i = 0; i < clients.length; i++)
      if (clients[i].tasks.length > 1) indexes.add(i);
    return indexes;
  }

  Client getClient(Map<String, dynamic> fileContent) {
    Client client = new Client("", 0, 0, "", 0, 0.0, true, false, false, 0, 0.0,
        DateTime.now().toIso8601String(), "", "", "", null, 0, 0);
    if (fileContent != null) {
      client = Client.fromJson(fileContent);
    }
    return client;
  }

  String getTasks(Client client) {
    return client.tasks;
  }

  String getImportantTasks(String tasks) {
    String importantTasks = "";
    String tempTask = "";
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] == "\n") {
        if (tempTask.contains("!") == true) {
          if (importantTasks.length > 1) importantTasks += "\n";
          importantTasks += tempTask;
        }
        tempTask = "";
      } else
        tempTask += tasks[i];
    }
    return importantTasks;
  }

  String getStandardTasks(String tasks) {
    String standardTasks = "";
    String tempTask = "";
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] == "\n") {
        if (tempTask.contains("!") == false) {
          if (standardTasks.length > 1) standardTasks += "\n";
          standardTasks += tempTask;
        }

        tempTask = "";
      } else
        tempTask += tasks[i];
    }
    return standardTasks;
  }
}
