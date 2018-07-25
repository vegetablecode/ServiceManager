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
  TextEditingController name = new TextEditingController();
  TextEditingController nip = new TextEditingController();
  TextEditingController contractPer = new TextEditingController();
  TextEditingController rate = new TextEditingController();
  TextEditingController deviceName = new TextEditingController();
  TextEditingController freeCopies = new TextEditingController();
  TextEditingController pagePrice = new TextEditingController();

  // checkbox values
  var quaterRate = false; // rozliczenie kwartalne (false -> miesieczne)
  var tonerIncluded = false; // tonery wliczone w umowe
  var printerLease = false; // dzierzawa

  void onPressed() {
    setState(() {
      Client tomek = Client(name.text, nip.text, int.tryParse(contractPer.text)??0, int.tryParse(rate.text)??0, deviceName.text, int.tryParse(freeCopies.text)??0, double.tryParse(pagePrice.text)??0.0, quaterRate, tonerIncluded, printerLease);
      tomek.display();
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
          controller: name,
          type: TextInputType.text
        ),
        new MyCard(
          label: "NIP klienta: ",
          controller: nip,
          type: TextInputType.text
        ),
        new MyCard(
          label: "Okres umowy (w miesiącach): ",
          controller: contractPer,
          type: TextInputType.numberWithOptions(
            signed: false,
            decimal: false
          ),
        ),
        new MyCard(
          label: "Ryczałt (zł): ",
          controller: rate,
          type: TextInputType.numberWithOptions(
            signed: false,
            decimal: false
          ),
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
          label: "Liczba darmowych kopii: ",
          controller: freeCopies,
          type: TextInputType.numberWithOptions(
            signed: false,
            decimal: false
          ),
        ),
        new MyCard(
          label: "Cena za stronę (zł): ",
          controller: pagePrice,
          type: TextInputType.numberWithOptions(
            signed: false,
            decimal: true
          ),
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
