import 'package:flutter/material.dart';
import './styles/MyColors.dart';
import './pages/Home.dart' as home;
import './pages/Clients.dart' as clients;
import './pages/NewClient.dart' as newclient;
import './pages/Reports.dart' as reports;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MainPage(title: 'elbiSerwis'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  final List<MyTabs> tabs = [
    new MyTabs(title: "Panel Główny"),
    new MyTabs(title: "Klienci"),
    new MyTabs(title: "Dodaj klienta"),
    new MyTabs(title: "Raporty"),
  ];
  MyTabs myHandler;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 4);
    myHandler = tabs[0];
    controller.addListener(handleSelected);
  }

  void handleSelected() {
    setState(() {
      myHandler = tabs[controller.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: MyColors.background,
      appBar: new AppBar(
        title: new Text(myHandler.title),
        backgroundColor: MyColors.tabBar,
      ),
      bottomNavigationBar: new Material(
          color: MyColors.iconBar,
          child: new TabBar(controller: controller, tabs: <Tab>[
            new Tab(icon: new Icon(Icons.home)),
            new Tab(icon: new Icon(Icons.people)),
            new Tab(icon: new Icon(Icons.add_box)),
            new Tab(icon: new Icon(Icons.view_list))
          ])),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new home.Home(),
          new clients.Clients(),
          new newclient.NewClient(),
          new reports.Reports()
        ],
      ),
    );
  }
}

class MyTabs {
  final String title;
  final Color color;
  MyTabs({this.title, this.color});
}
