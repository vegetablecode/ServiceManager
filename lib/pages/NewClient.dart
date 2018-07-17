import 'package:flutter/material.dart';

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

  TextEditingController nazwaKlienta = new TextEditingController();
  TextEditingController nip = new TextEditingController();

  void onPressed() {
    setState(() {
      print(nazwaKlienta.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Column(
      children: <Widget>[
        new MyCard(label: "Nazwa klienta: ", controller: nazwaKlienta,),
        new MyCard(label: "NIP klienta: ", controller: nip,),
        new MyCard(label: "Okres umowy: ", controller: nip,),
        new MyCard(label: "Liczba darmowych kopii: ", controller: nip,),
        new RaisedButton(
          child: new Text("Dodaj!"),
          color: Colors.red,
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
            decoration: new InputDecoration(
              labelText: label
            ),
          ),
          ],
        ),
      ),
    );
  }
}
