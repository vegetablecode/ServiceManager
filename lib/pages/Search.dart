import 'package:flutter/material.dart';
import 'package:elbiserwis/styles/MyColors.dart';
import './ViewClient.dart' as viewClient;
import './ViewNonAgreementClient.dart' as viewNonAgreementClient;
import 'package:material_search/material_search.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:elbiserwis/Client.dart';

class Search extends StatelessWidget {
  var clientList;
  Search(this.clientList);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new SearchWidget(clientList),
    );
  }
}

class SearchWidget extends StatefulWidget {
  var clientList;
  SearchWidget(this.clientList);

  @override
  SearchState createState() => new SearchState(clientList);
}

class SearchState extends State<SearchWidget> {
  // client details
  var clientList;
  SearchState(this.clientList);
  var _names = [
    '',
    '',
  ];

  // JSON data
  File jsonFile;
  Directory dir;
  String fileName = "clientsData.json";
  bool fileExist = false;
  Map<String, dynamic> fileContent;

  // move to ViewClient page
void view(String name) {
  bool noAgreement = isClientNonAgreement(name);

    if (this.mounted) {
      if (noAgreement == false) {
        setState(() {
          print(name);
          Navigator
              .push(
            context,
            MaterialPageRoute(
                builder: (context) => viewClient.ViewClient(name)),
          )
              .then((value) {
            setState(() {
              print("back from: " + name);
              reloadState();
            });
          });
        });
      } else {
        setState(() {
          print(name);
          Navigator
              .push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    viewNonAgreementClient.ViewNonAgreementClient(name)),
          )
              .then((value) {
            setState(() {
              print("back from: " + name);
              reloadState();
            });
          });
        });
      }
    }
  }

  // get clients names
  @override
  void initState() {
    super.initState();
    if (clientList != null) _names = clientList;
  }

  // update state
  void reloadState() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExist = jsonFile.existsSync();
      if ((fileExist) && (this.mounted)) {
        this.setState(
            () => fileContent = JSON.decode(jsonFile.readAsStringSync()));
        clientList = fileContent.keys.toList();
        if (clientList != null) _names = clientList;
      }
    });
  }

  bool isClientNonAgreement(String name) {
    bool status = false;
    if(fileContent != null) {
      status = Client.fromJson(fileContent[name]).noAgreement;
    }
    return status;
  }

  /*
   * MATERIAL SEARCH WIDGET
   * adapted from: https://pub.dartlang.org/packages/material_search#-example-tab-
   */
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.tabBar,
        title: new Text("Wyszukiwanie klientów"),
        actions: <Widget>[
        ],
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 50.0),
            ),
            new Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: new Form(
                key: _formKey,
                child: new Column(
                  children: <Widget>[
                    new MaterialSearchInput<String>(
                      placeholder: 'Wpisz nazwę klienta',
                      results: _names
                          .map((String v) => new MaterialSearchResult<String>(
                                icon: Icons.person,
                                value: v,
                                text: "$v",
                              ))
                          .toList(),
                      filter: (dynamic value, String criteria) {
                        return value.toLowerCase().trim().contains(new RegExp(
                            r'' + criteria.toLowerCase().trim() + ''));
                      },
                      onSelect: (dynamic v) {
                        print(v);
                        if (clientList != null) _names = clientList;
                        view(v);
                      },
                      validator: (dynamic value) =>
                          value == null ? 'Required field' : null,
                      formatter: (dynamic v) => '$v',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
