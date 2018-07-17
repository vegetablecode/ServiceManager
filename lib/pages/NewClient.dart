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
        new MyCard(label: new Text("SIEMA"), controller: nazwaKlienta,),
        new RaisedButton(
          child: new Text("Klikaj!"),
          color: Colors.red,
          onPressed: onPressed,
        )
      ],
    ));
  }
}

class MyCard extends StatelessWidget {
  MyCard({this.label, this.controller});

  final Widget label;
  final TextEditingController controller; 

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.only(bottom: 20.0),
      child: new Container(
        padding: new EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            this.label,
            new TextField(
            controller: controller,
          ),
          ],
        ),
      ),
    );
  }

}
