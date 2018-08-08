import 'package:flutter/material.dart';
import 'package:elbiserwis/styles/MyColors.dart';

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
                ],
              ),
            )),
      ),
    );
  }
}
