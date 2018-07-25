import 'package:flutter/material.dart';
import 'package:elbiserwis/Client.dart';

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
  TextEditingController nazwaKlienta = new TextEditingController();
  TextEditingController nip = new TextEditingController();

  // checkbox values
  var quaterRate = false; // rozliczenie kwartalne (false -> miesieczne)
  var tonerIncluded = false; // tonery wliczone w umowe
  var printerLease = false; // dzierzawa

  void onPressed() {
    setState(() {
      //Client();
      print("client has been created");
    });
  }

  void quaterRateChanged(bool value) {
    setState(() {
      quaterRate = value;
    });
  }

  void tonerIncludedChanged(bool value) {
    setState(() {
      tonerIncluded = value;
    });
  }

  void printerLeaseChanged(bool value) {
    setState(() {
      printerLease = value;
    });
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
          controller: nazwaKlienta,
        ),
        new MyCard(
          label: "NIP klienta: ",
          controller: nip,
        ),
        new MyCard(
          label: "Okres umowy: ",
          controller: nip,
        ),
        new MyCard(
          label: "Ryczałt miesięczny: ",
          controller: nip,
        ),
        new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
        new Text(
          "Szczegóły umowy",
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 20.0),
        ),
        new MyCard(
          label: "Rodzaj urządzenia: ",
          controller: nip,
        ),
        new MyCard(
          label: "Liczba darmowych kopii: ",
          controller: nip,
        ),
        new MyCard(
          label: "Cena za stronę: ",
          controller: nip,
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
  MyCard({this.label, this.controller});

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
              controller: controller,
              decoration: new InputDecoration(labelText: label),
            ),
          ],
        ),
      ),
    );
  }
}
