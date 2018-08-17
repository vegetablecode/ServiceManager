import 'package:elbiserwis/Client.dart';
import 'package:elbiserwis/pages/MonthSummary.dart' as monthSummary;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:elbiserwis/styles/MyColors.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  TextEditingController note = new TextEditingController();
  TextEditingController counterStatus = new TextEditingController();
  TextEditingController colorCounterStatus = new TextEditingController();
  TextEditingController task = new TextEditingController();
  DateTime _appointmentDate = new DateTime.now();

  Client client;

  // JSON data
  File jsonFile;
  Directory dir;
  String fileName = "clientsData.json";
  bool fileExist = false;
  Map<String, dynamic> fileContent;
  var clientList;

  var importantTask = false; // checkbox

  // JSON create & read
  @override
  void initState() {
    super.initState();

    // client details
    client = new Client(
        "",
        0,
        0,
        "",
        0,
        0.0,
        true,
        false,
        false,
        0,
        0.0,
        DateTime.now().toIso8601String(),
        DateTime.now().toIso8601String(),
        DateTime.now().toIso8601String(),
        "",
        null,
        0,
        0,
        0,
        0,
        0,
        0,
        false,
        false,
        false,
        "",
        "");
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _appointmentDate,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2019));
    if (picked != null && picked != _appointmentDate) {
      print("Date seleted: ${_appointmentDate.toString()}");
      if (this.mounted) {
        setState(() {
          _appointmentDate = picked;
        });
      }
    }
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
    saveData(jsonFile);
    print("A new file with data has been created!");
  }

  // save to Firebase
  void saveData(File content) async {
    var url = "https://elbiserwis-42e05.firebaseio.com/clients.json";
    var httpClient = http.Client();
    var removeData = await httpClient.delete(url);
    var response = await httpClient.post(url, body: JSON.encode(fileContent));
    print("response=" + response.body);
  }

  void writeToFile(Map<String, dynamic> content) {
    print("Writing to file!");
    if (fileExist) {
      print("File exist!");
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(JSON.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    this.setState(() => fileContent = JSON.decode(jsonFile.readAsStringSync()));
  }

  void editClient() {
    print("tu sie bedzie edytowac");
  }

  void importanTaskChanged(bool value) {
    if (this.mounted) {
      setState(() {
        importantTask = value;
      });
    }
  }

  void removeClient() {
    if (this.mounted) {
      setState(() {
        Map<String, dynamic> newFileContent = fileContent;
        newFileContent.remove(name);
        writeAsNewFile(newFileContent);
      });
    }
    Navigator.pop(context);
  }

  void removeTaskAction(int index) {
    client.tasks = removeTask(client.tasks, getTaskList(client.tasks), index);
    updateClient();
  }

  void addTask() {
    if (this.mounted) {
      setState(() {
        client.tasks += task.text.toString();
        if (importantTask == true) client.tasks += "!";
        client.tasks += '\n';
        print("the task has been added!");
        updateClient();
      });
    }
  }

  void addNote() {
    if ((this.mounted) &&
        ((counterStatus.text != "") && (colorCounterStatus.text != ""))) {
      setState(() {
        // add note
        client.notes += dateToString(_appointmentDate);
        client.notes += ": ";
        client.notes += note.text.toString();
        client.notes += '\n';
        print("the note has been added!");

        // add dates & update counter
        client.isInvoicePaid = false;
        client.lastDate = _appointmentDate.toIso8601String();
        client.nextDate = client.quaterRate
            ? _appointmentDate.add(new Duration(days: 90)).toString()
            : _appointmentDate.add(new Duration(days: 30)).toString();
        client.prevCopyCount = client.newCopyCount;
        client.prevColorCopyCount = client.newColorCopyCount;
        client.newCopyCount = int.tryParse(counterStatus.text) ?? 0;
        client.newColorCopyCount = int.tryParse(colorCounterStatus.text) ?? 0;
        client.copiesLimitReached =
            (getPriceOfAddCopies() > 0.0) ? true : false;

        // clear the fields
        note.clear();
        counterStatus.clear();
        colorCounterStatus.clear();

        // save data
        updateClient();
        noteAddedDialog();
      });
    } else {
      noDataDialog();
    }
  }

  void openSummary(String name, Client client) {
    if (this.mounted) {
      setState(() {
        print(name);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => monthSummary.MonthSummary(name, client)),
        );
      });
    }
  }

  void changePaymentStatus() {
    if (this.mounted) {
      setState(() {
        if (client.isInvoicePaid == true)
          client.isInvoicePaid = false;
        else
          client.isInvoicePaid = true;
      });
      updateClient();
    }
  }

  double getPriceOfAddCopies() {
    int bwCopies = getOverCopies();
    int colorCopies = getOverColorCopies();
    var bwPrice = bwCopies * client.pagePrice;
    var colorPrice = colorCopies * client.colorPagePrice;
    return bwPrice + colorPrice;
  }

  int getOverCopies() {
    int copies =
        ((client.newCopyCount - client.prevCopyCount) - client.freeCopies);
    return (copies <= 0) ? 0 : copies;
  }

  int getOverColorCopies() {
    int copies = ((client.newColorCopyCount - client.prevColorCopyCount) -
        client.colorFreeCopies);
    return (copies <= 0) ? 0 : copies;
  }

  void updateClient() {
    // update client details
    Client updatedClient = Client(
        client.nip,
        client.contractPer,
        client.rate,
        client.deviceName,
        client.freeCopies,
        client.pagePrice,
        client.quaterRate,
        client.tonerIncluded,
        client.printerLease,
        client.colorFreeCopies,
        client.colorPagePrice,
        client.beginDate,
        client.lastDate,
        client.nextDate,
        client.notes,
        client.tasks,
        client.initialCopies,
        client.initialColorCopies,
        client.newCopyCount,
        client.newColorCopyCount,
        client.prevCopyCount,
        client.prevColorCopyCount,
        client.copiesLimitReached,
        client.isInvoicePaid,
        client.noAgreement,
        client.email,
        client.phone);

    Map<String, dynamic> updatedMap = {name: updatedClient.toJson()};
    writeToFile(updatedMap);
    saveData(jsonFile);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: MyColors.background,
        appBar: new AppBar(
          title: new Text("Zobacz klienta"),
          backgroundColor: MyColors.tabBar2,
        ),
        body: ListView(
          padding: const EdgeInsets.all(5.0),
          children: <Widget>[
            new Card(
                color: MyColors.card,
                child: new Container(
                    padding: EdgeInsets.all(5.0),
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
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.nip),
                          ],
                        ),
                        new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                        new Row(
                          children: <Widget>[
                            new Text(
                              "E-Mail: ",
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.email),
                          ],
                        ),
                        new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                        new Row(
                          children: <Widget>[
                            new Text(
                              "Telefon: ",
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.phone),
                          ],
                        ),
                        new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                        new Row(
                          children: <Widget>[
                            new Text(
                              "okres umowy: ",
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.contractPer.toString()),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
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
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.rate.toString()),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
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
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.deviceName),
                          ],
                        ),
                        new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                        new Row(
                          children: <Widget>[
                            new Text(
                              "początkowy stan licznika (czb): ",
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.initialCopies.toString()),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text("szt.")
                          ],
                        ),
                        new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                        new Row(
                          children: <Widget>[
                            new Text(
                              "początkowy stan licznika (kolor): ",
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.initialColorCopies.toString()),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text("szt.")
                          ],
                        ),
                        new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                        new Row(
                          children: <Widget>[
                            new Text(
                              "liczba darmowych kopii (czb): ",
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.freeCopies.toString()),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
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
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.colorFreeCopies.toString()),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
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
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.pagePrice.toString()),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
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
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.colorPagePrice.toString()),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
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
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(
                                client.quaterRate ? "kwartalne" : "miesięczne"),
                          ],
                        ),
                        new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                        new Row(
                          children: <Widget>[
                            new Text(
                              "tonery zawarte w umowie: ",
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
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
                            new Padding(
                                padding: new EdgeInsets.only(left: 5.0)),
                            new Text(client.printerLease ? "tak" : "nie"),
                          ],
                        ),
                      ],
                    ))),
            new Card(
                color: MyColors.card,
                child: new Container(
                  padding: EdgeInsets.all(5.0),
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "Informacje o umowie",
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
                      new Row(
                        children: <Widget>[
                          new Text("Data rozpoczęcia umowy: "),
                          new Padding(padding: new EdgeInsets.only(left: 5.0)),
                          new Text(
                            dateToString(DateTime.parse(client.beginDate)),
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                      new Row(
                        children: <Widget>[
                          new Text("Data ostatniego rozliczenia: "),
                          new Padding(padding: new EdgeInsets.only(left: 5.0)),
                          new Text(
                            dateToString(DateTime.parse(client.lastDate)),
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                      new Row(
                        children: <Widget>[
                          new Text("Data kolejnego rozliczenia: "),
                          new Padding(padding: new EdgeInsets.only(left: 5.0)),
                          new Text(
                            dateToString(DateTime.parse(client.nextDate)),
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                      new Row(
                        children: <Widget>[
                          new Text("Liczba cz-b kopii ponad stan: "),
                          new Padding(padding: new EdgeInsets.only(left: 5.0)),
                          new Text(
                            getOverCopies().toString(),
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                      new Row(
                        children: <Widget>[
                          new Text("Liczba kolorowych kopii ponad stan: "),
                          new Padding(padding: new EdgeInsets.only(left: 5.0)),
                          new Text(
                            getOverColorCopies().toString(),
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                      new Row(
                        children: <Widget>[
                          new Text("Dodatkowo do zapłaty w tym miesiącu: "),
                          new Padding(padding: new EdgeInsets.only(left: 5.0)),
                          new Text(
                            getPriceOfAddCopies().toString(),
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                          new Padding(padding: new EdgeInsets.only(left: 5.0)),
                          new Text(
                            "zł",
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                      new Row(
                        children: <Widget>[
                          new Text("Status faktury: "),
                          new Padding(padding: new EdgeInsets.only(left: 5.0)),
                          new Text(
                            (client.isInvoicePaid)
                                ? "wystawiona"
                                : "niewystawiona",
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                      new RaisedButton(
                        child: new Text(client.isInvoicePaid
                            ? "wystawiono fakturę"
                            : "faktura do wystawienia"),
                        color: client.isInvoicePaid
                            ? MyColors.greenButton
                            : MyColors.flatButtonFill,
                        onPressed: changePaymentStatus,
                      ),
                      new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                      new RaisedButton(
                        child: new Text("zobacz raport"),
                        color: MyColors.noTask,
                        onPressed: () {
                          openSummary(name, client);
                        },
                      )
                    ],
                  ),
                )),
            new Card(
                color: MyColors.card,
                child: new Container(
                  padding: EdgeInsets.all(5.0),
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "Wizyty",
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
                      new Row(
                        children: <Widget>[new Text(client.notes.toString())],
                      ),
                      new Card(
                          color: MyColors.light,
                          child: new Center(
                              child: new Container(
                                  padding: new EdgeInsets.all(5.0),
                                  child: new Column(
                                    children: <Widget>[
                                      new TextField(
                                        decoration: InputDecoration(
                                            hintText:
                                                'Wpisz notatkę do wizyty...'),
                                        controller: note,
                                      ),
                                      new Padding(
                                          padding:
                                              new EdgeInsets.only(bottom: 5.0)),
                                      new TextField(
                                        decoration: InputDecoration(
                                            hintText:
                                                'Dodaj stan licznika (czb)...'),
                                        controller: counterStatus,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false, decimal: false),
                                      ),
                                      new Padding(
                                          padding:
                                              new EdgeInsets.only(bottom: 5.0)),
                                      new TextField(
                                        decoration: InputDecoration(
                                            hintText:
                                                'Dodaj stan licznika (kolor)...'),
                                        controller: colorCounterStatus,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false, decimal: false),
                                      ),
                                    ],
                                  )))),
                      new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                      new Card(
                          color: MyColors.light,
                          child: new Center(
                              child: new Container(
                                  padding: new EdgeInsets.all(5.0),
                                  child: new Column(
                                    children: <Widget>[
                                      new Row(
                                        children: <Widget>[
                                          new Text("Wybrana data: "),
                                          new Padding(
                                              padding: new EdgeInsets.only(
                                                  left: 5.0)),
                                          new Text(
                                              "${dateToString(_appointmentDate)}",
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          new FlatButton(
                                            child: new Text(
                                              "Wybierz inną datę!",
                                              style: TextStyle(
                                                  color: MyColors.flatButton),
                                            ),
                                            onPressed: () {
                                              _selectDate(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )))),
                      new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                      new FlatButton(
                        child: new Text(
                          "Zapisz wizytę!",
                          style: TextStyle(color: MyColors.flatButton),
                        ),
                        onPressed: clientCreatedDialog,
                      ),
                    ],
                  ),
                )),
            new Card(
              color: MyColors.card,
              child: new Container(
                padding: new EdgeInsets.all(5.0),
                child: new Column(
                  children: <Widget>[
                    new Text(
                      "Zadania",
                      style: new TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
            new Container(
                height: 200.0,
                child: new Card(
                  color: MyColors.card,
                  child: ListView.builder(
                    itemCount: client.tasks == null
                        ? 0
                        : getTaskList(client.tasks).length,
                    itemBuilder: (context, index) {
                      return new Card(
                        margin: new EdgeInsets.all(5.0),
                        color: MyColors.task,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Padding(
                                    padding: new EdgeInsets.only(left: 5.0)),
                                new Text(getTaskList(client.tasks)[index]),
                              ],
                            ),
                            new IconButton(
                              icon: new Icon(Icons.delete),
                              onPressed: () {
                                removeTaskAction(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )),
            new Card(
                color: MyColors.card,
                child: new Container(
                  padding: new EdgeInsets.all(5.0),
                  child: new Column(
                    children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
                      new TextField(
                        decoration:
                            InputDecoration(hintText: 'Dodaj zadanie...'),
                        controller: task,
                      ),
                      new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                      new Container(
                        padding: new EdgeInsets.all(2.0),
                        child: new Column(
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Icon(
                                  Icons.warning,
                                  color: Colors.redAccent,
                                ),
                                new Text("ważne zadanie:"),
                                new Checkbox(
                                  value: importantTask,
                                  onChanged: (bool value) {
                                    importanTaskChanged(value);
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      new FlatButton(
                        child: new Text(
                          "Zapisz zadanie!",
                          style: TextStyle(color: MyColors.flatButton),
                        ),
                        onPressed: addTask,
                      ),
                    ],
                  ),
                )),
            new Column(
              children: <Widget>[
                new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
                new FlatButton(
                  child: new Text("Usuń klienta"),
                  onPressed: removeClient,
                )
              ],
            )
          ],
        ));
  }

  String dateToString(DateTime date) {
    String readable = date.day.toString() +
        "." +
        date.month.toString() +
        "." +
        date.year.toString();
    return readable;
  }

  List<String> getTaskList(String tasks) {
    int lastBreak = 0;
    List<String> taskList = new List();
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] == '\n') {
        taskList.add(tasks.substring(lastBreak, i));
        lastBreak = i + 1;
      }
    }
    return taskList;
  }

  String removeTask(String tasks, List<String> taskList, int index) {
    String newTasks = "";
    for (int i = 0; i < taskList.length; i++) {
      if (i != index) {
        newTasks += taskList[i];
        newTasks += '\n';
      }
    }
    return newTasks;
  }

  Future<Null> clientCreatedDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Dodawanie wizyty'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Czy jesteś pewien, że chcesz dodać nową wizytę?'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                addNote();
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Anuluj'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

   Future<Null> noDataDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Dodawanie wizyty'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Nie możesz dodać wizyty bez podania stanu licznika'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

   Future<Null> noteAddedDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Dodawanie wizyty'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Wizyta została dodana pomyślnie.'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
