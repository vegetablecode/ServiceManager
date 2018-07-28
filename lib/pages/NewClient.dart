import 'package:flutter/material.dart';
import 'package:elbiserwis/Client.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class NewClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new NewClientWidget(),
    );
  }
}

class NewClientWidget extends StatefulWidget {
  @override
  NewClientState createState() => new NewClientState();
}

class NewClientState extends State<NewClientWidget> {
  // controllers
  TextEditingController name = new TextEditingController();
  TextEditingController nip = new TextEditingController();
  TextEditingController contractPer = new TextEditingController();
  TextEditingController rate = new TextEditingController();
  TextEditingController deviceName = new TextEditingController();
  TextEditingController freeCopies = new TextEditingController();
  TextEditingController pagePrice = new TextEditingController();
  TextEditingController colorFreeCopies = new TextEditingController();
  TextEditingController colorPagePrice = new TextEditingController();
  DateTime _beginDate = new DateTime.now();
  String tasks = "";

  // JSON data
  File jsonFile;
  Directory dir;
  String fileName = "clientsData.json";
  bool fileExist = false;
  Map<String, dynamic> fileContent;

  // checkbox values
  var quaterRate = false; // rozliczenie kwartalne (false -> miesieczne)
  var tonerIncluded = false; // tonery wliczone w umowe
  var printerLease = false; // dzierzawa

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

  @override
  void dispose() {
    name.dispose();
    nip.dispose();
    contractPer.dispose();
    rate.dispose();
    deviceName.dispose();
    freeCopies.dispose();
    pagePrice.dispose();
    colorFreeCopies.dispose();
    colorPagePrice.dispose();
    super.dispose();
  }

  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExist = true;
    file.writeAsStringSync(JSON.encode(content));
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

  // switches & buttons
  void onPressed() {
    if (this.mounted) {
      setState(() {
        // create a new client
        Client tomek = Client(
            nip.text,
            int.tryParse(contractPer.text) ?? 0,
            int.tryParse(rate.text) ?? 0,
            deviceName.text,
            int.tryParse(freeCopies.text) ?? 0,
            double.tryParse(pagePrice.text) ?? 0.0,
            quaterRate,
            tonerIncluded,
            printerLease,
            int.tryParse(colorFreeCopies.text) ?? 0,
            double.tryParse(colorPagePrice.text) ?? 0.0,
            _beginDate.toIso8601String(),
            "",
            "",
            tasks);
        tomek.display();
        print("client has been created");

        // json test #temp
        Map<String, dynamic> userMap = {name.text: tomek.toJson()};
        var user = new Client.fromJson(userMap);
        print(user.deviceName);
        String jsonFile = json.encode(user);

        // save to the db
        writeToFile(userMap);
      });
    }
  }

  void quaterRateChanged(bool value) {
    if (this.mounted) {
      setState(() {
        quaterRate = value;
      });
    }
  }

  void tonerIncludedChanged(bool value) {
    if (this.mounted) {
      setState(() {
        tonerIncluded = value;
      });
    }
  }

  void printerLeaseChanged(bool value) {
    if (this.mounted) {
      setState(() {
        printerLease = value;
      });
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _beginDate,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2019));
    if (picked != null && picked != _beginDate) {
      print("Date seleted: ${_beginDate.toString()}");
      if (this.mounted) {
        setState(() {
          _beginDate = picked;
        });
      }
    }
  }

  String dateToString(DateTime date) {
    String readable = date.day.toString() +
        "." +
        date.month.toString() +
        "." +
        date.year.toString();
    return readable;
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        new Text(
          "Dane klienta",
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 20.0),
        ),
        new MyCard(
            label: "Nazwa klienta: ",
            controller: name,
            type: TextInputType.text),
        new MyCard(
            label: "NIP klienta: ", controller: nip, type: TextInputType.text),
        new MyCard(
          label: "Okres umowy (w miesiącach): ",
          controller: contractPer,
          type: TextInputType.numberWithOptions(signed: false, decimal: false),
        ),
        new MyCard(
          label: "Ryczałt (zł): ",
          controller: rate,
          type: TextInputType.numberWithOptions(signed: false, decimal: false),
        ),
        new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
        new Text(
          "Szczegóły umowy",
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 20.0),
        ),
        new MyCard(
          label: "Rodzaj urządzenia: ",
          controller: deviceName,
          type: TextInputType.text,
        ),
        new MyCard(
          label: "Liczba darmowych kopii (czb): ",
          controller: freeCopies,
          type: TextInputType.numberWithOptions(signed: false, decimal: false),
        ),
        new MyCard(
          label: "Cena za stronę (zł) (czb): ",
          controller: pagePrice,
          type: TextInputType.numberWithOptions(signed: false, decimal: true),
        ),
        new MyCard(
          label: "Liczba darmowych kopii (kolor): ",
          controller: colorFreeCopies,
          type: TextInputType.numberWithOptions(signed: false, decimal: false),
        ),
        new MyCard(
          label: "Cena za stronę (zł) (kolor): ",
          controller: colorPagePrice,
          type: TextInputType.numberWithOptions(signed: false, decimal: true),
        ),
        new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
        new Text(
          "Data początku umowy",
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 20.0),
        ),
        new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
        new Row(
          children: <Widget>[
            new Text("Wybrana data: "),
            new Padding(padding: new EdgeInsets.only(left: 5.0)),
            new Text("${dateToString(_beginDate)}",
                style: new TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        new Padding(padding: new EdgeInsets.only(bottom: 5.0)),
        new FlatButton(
          child: new Text("Wybierz inną datę!", style: TextStyle(color: Colors.blueAccent),),
          onPressed: () {
            _selectDate(context);
          },
        ),
        new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
        new Text(
          "Dodatkowe opcje",
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 20.0),
        ),
        new Container(
          padding: new EdgeInsets.all(2.0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text("Rozliczenie kwartalne:"),
                  new Checkbox(
                    value: quaterRate,
                    onChanged: (bool value) {
                      quaterRateChanged(value);
                    },
                  )
                ],
              )
            ],
          ),
        ),
        new Container(
          padding: new EdgeInsets.all(2.0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text("Tonery wliczone w umowę:"),
                  new Checkbox(
                    value: tonerIncluded,
                    onChanged: (bool value) {
                      tonerIncludedChanged(value);
                    },
                  )
                ],
              )
            ],
          ),
        ),
        new Container(
          padding: new EdgeInsets.all(2.0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text("Dzierżawa kserokopiarki:"),
                  new Checkbox(
                    value: printerLease,
                    onChanged: (bool value) {
                      printerLeaseChanged(value);
                    },
                  )
                ],
              )
            ],
          ),
        ),
        new RaisedButton(
          child: new Text("Dodaj!"),
          color: Colors.blueAccent,
          onPressed: onPressed,
        )
      ],
    ));
  }
}

class MyCard extends StatelessWidget {
  MyCard({this.label, this.controller, this.type});

  TextInputType type;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.only(bottom: 2.0),
      child: new Container(
        padding: new EdgeInsets.all(2.0),
        child: new Column(
          children: <Widget>[
            new TextField(
              keyboardType: type,
              controller: controller,
              decoration: new InputDecoration(labelText: label),
            ),
          ],
        ),
      ),
    );
  }
}
