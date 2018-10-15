import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:elbiserwis/styles/MyColors.dart';
import 'package:elbiserwis/Client.dart';
import './ViewClient.dart' as viewClient;
import './ViewNonAgreementClient.dart' as viewNonAgreementClient;
import './Search.dart' as searchClient;

class Clients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new ClientsWidget(),
    );
  }
}

class ClientsWidget extends StatefulWidget {
  @override
  ClientsState createState() => new ClientsState();
}

class ClientsState extends State<ClientsWidget> {
  // JSON data
  File jsonFile;
  Directory dir;
  String fileName = "clientsData.json";
  bool fileExist = false;
  Map<String, dynamic> fileContent;
  var clientList;
  List<Client> clients = new List();
  List<bool> invoiceStatuses = new List();
  List<bool> agreementTypes = new List();

  // JSON create & read
  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExist = jsonFile.existsSync();
      if ((fileExist) && (this.mounted)) {
        this.setState(
            () => fileContent = json.decode(jsonFile.readAsStringSync()));
        clientList = fileContent.keys.toList();
        for (int i = 0; i < fileContent.length; i++) {
          clients.add(getClient(fileContent[clientList[i]]));
        }
        invoiceStatuses = getInvoicesStatuses(clients);
        agreementTypes = getAgreementTypes(clients);
      }
    });
  }

  void reloadState() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExist = jsonFile.existsSync();
      if ((fileExist) && (this.mounted)) {
        this.setState(
            () => fileContent = json.decode(jsonFile.readAsStringSync()));
        clientList = fileContent.keys.toList();

        // update clients
        List<Client> newList = new List();
        for (int i = 0; i < fileContent.length; i++) {
          newList.add(getClient(fileContent[clientList[i]]));
        }
        clients = newList;
        invoiceStatuses = getInvoicesStatuses(newList);
      }
    });
  }

  void view(String name, bool noAgreement) {
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

  void search() {
    if (this.mounted) {
      setState(() {
        Navigator
            .push(
          context,
          MaterialPageRoute(
              builder: (context) => searchClient.Search(clientList)),
        )
            .then((value) {
          setState(() {
            reloadState();
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: search,
          child: new Icon(Icons.search),
          backgroundColor: MyColors.flatButtonFill,
        ),
        backgroundColor: MyColors.background,
        body: new ListView.builder(
            itemCount: fileContent == null ? 0 : fileContent.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                  color: MyColors.card,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(left: 5.0),
                          ),
                          new Icon(Icons.date_range,
                              color:
                                  getDateColor(getNextDates(clients)[index])),
                          new Icon(
                            Icons.monetization_on,
                            color: getInvoicesStatuses(clients)[index]
                                ? MyColors.greenStatus
                                : MyColors.redStatus,
                          ),
                          new Icon(
                            getAgreementTypes(clients)[index]? Icons.build :Icons.settings,
                            color: MyColors.gray,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(left: 5.0),
                          ),
                          new Text(clientList[index]),
                        ],
                      ),
                      new IconButton(
                        icon: new Icon(Icons.remove_red_eye),
                        color: Colors.blueAccent,
                        onPressed: () {
                          view(clientList[index],
                              getAgreementTypes(clients)[index]);
                        },
                      )
                    ],
                  ));
            }));
  }

  List<bool> getInvoicesStatuses(List<Client> clients) {
    List<bool> statuses = new List();
    if (clients != null) {
      for (int i = 0; i < clients.length; i++)
        statuses.add(clients[i].isInvoicePaid ? true : false);
    }
    return statuses;
  }

  List<String> getNextDates(List<Client> clients) {
    List<String> dates = new List();
    if (clients != null) {
      for (int i = 0; i < clients.length; i++) dates.add(clients[i].nextDate);
    }
    return dates;
  }

/* noAgreement
 * true -> client has no agreement
 * false ->  client has service agreement */
  List<bool> getAgreementTypes(List<Client> clients) {
    List<bool> agreementTypes = new List();
    if (clients != null) {
      for (int i = 0; i < clients.length; i++)
        agreementTypes.add(clients[i].noAgreement);
    }
    return agreementTypes;
  }

  Color getDateColor(String date) {
    DateTime now = DateTime.now();
    DateTime inFiveDays = now.add(new Duration(days: 5));
    DateTime nextDate = DateTime.parse(date);
    if (nextDate.isBefore(now))
      return MyColors.redStatus;
    else if (nextDate.isBefore(inFiveDays))
      return MyColors.yellowStatus;
    else
      return MyColors.greenStatus;
  }

  Client getClient(Map<String, dynamic> fileContent) {
    Client client = new Client(
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
    if (fileContent != null) {
      client = Client.fromJson(fileContent);
    }
    return client;
  }
}
