import 'package:flutter/material.dart';
import 'package:elbiserwis/styles/MyColors.dart';
import './NewAgreementClient.dart' as newAgreementClient;

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
  void openNewAgreementClient() {
    if (this.mounted) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => newAgreementClient.NewAgreementClient()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: MyColors.background,
        body: new Center(
          child: new Container(
            padding: new EdgeInsets.all(20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Card(
                    child: new Container(
                        padding: new EdgeInsets.all(20.0),
                        child: new Center(
                          child: new Column(
                            children: <Widget>[
                              new Text(
                                "Stała umowa serwisowa",
                                textAlign: TextAlign.center,
                                style: new TextStyle(fontSize: 20.0),
                              ),
                              new IconButton(
                                icon: new Icon(Icons.add_box,
                                    size: 40.0, color: MyColors.flatButtonFill),
                                onPressed: openNewAgreementClient,
                              )
                            ],
                          ),
                        ))),
                new Padding(
                  padding: new EdgeInsets.only(bottom: 5.0),
                ),
                new Card(
                    child: new Container(
                        padding: new EdgeInsets.all(20.0),
                        child: new Center(
                          child: new Column(
                            children: <Widget>[
                              new Text(
                                "Klient bez umowy",
                                textAlign: TextAlign.center,
                                style: new TextStyle(fontSize: 20.0),
                              ),
                              new IconButton(
                                icon: new Icon(Icons.add_box,
                                    size: 40.0, color: MyColors.flatButtonFill),
                                onPressed: null,
                              )
                            ],
                          ),
                        )))
              ],
            ),
          ),
        ));
  }
}
