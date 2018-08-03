import 'dart:async';

class Client {
  // client details
  var name = ""; // nazwa klienta
  var nip = ""; // nip klienta
  var contractPer = 0; // okres umowy
  var rate = 0; // ryczalt
  var deviceName = ""; // nazwa urzadzenia
  var freeCopies = 0; // liczba darmowych kopii
  var pagePrice = 0.0; // cena za kopie
  var colorFreeCopies = 0; // liczba darmowych kolorowych kopii
  var colorPagePrice = 0.0; // cena za kopie kolorowa
  var initialCopies = 0;
  var initialColorCopies = 0;

  String beginDate = ""; // data poczatku umowy
  String lastDate = ""; // ostatni termin wizyty
  String nextDate = ""; // nastepny termin wizyty
  String notes = ""; // notatki, zadania
  String tasks = ""; // zadania

  // boxes
  var quaterRate = false; // rozliczenie kwartalne (false -> miesieczne)
  var tonerIncluded = false; // tonery wliczone w umowe
  var printerLease = false; // dzierzawa

  Client(
      this.nip,
      this.contractPer,
      this.rate,
      this.deviceName,
      this.freeCopies,
      this.pagePrice,
      this.quaterRate,
      this.tonerIncluded,
      this.printerLease,
      this.colorFreeCopies,
      this.colorPagePrice,
      this.beginDate,
      this.lastDate,
      this.nextDate,
      this.notes,
      this.tasks,
      this.initialCopies,
      this.initialColorCopies);

  Client.fromJson(Map<String, dynamic> json)
      : nip = json['nip'],
        contractPer = json['contractPer'],
        rate = json['rate'],
        deviceName = json['deviceName'],
        freeCopies = json['freeCopies'],
        pagePrice = json['pagePrice'],
        quaterRate = json['quaterRate'],
        tonerIncluded = json['tonerIncluded'],
        printerLease = json['printerLease'],
        colorFreeCopies = json['colorFreeCopies'],
        colorPagePrice = json['colorPagePrice'],
        beginDate = json['beginDate'],
        lastDate = json['lastDate'],
        nextDate = json['nextDate'],
        notes = json['notes'],
        tasks = json['tasks'],
        initialCopies = json['initialCopies'],
        initialColorCopies = json['initialColorCopies'];

  Map<String, dynamic> toJson() => {
        'nip': nip,
        'contractPer': contractPer,
        'rate': rate,
        'deviceName': deviceName,
        'freeCopies': freeCopies,
        'pagePrice': pagePrice,
        'quaterRate': quaterRate,
        'tonerIncluded': tonerIncluded,
        'printerLease': printerLease,
        'colorFreeCopies': colorFreeCopies,
        'colorPagePrice': colorPagePrice,
        'beginDate': beginDate,
        'lastDate': lastDate,
        'nextDate': nextDate,
        'notes': notes,
        'tasks': tasks,
        'initialCopies': initialCopies,
        'initialColorCopies': initialColorCopies
      };

  // debug
  void display() {
    print(name);
    print(nip);
    print(contractPer);
    print(rate);
    print(deviceName);
    print(freeCopies);
    print(pagePrice);
    print(quaterRate);
    print(tonerIncluded);
    print(printerLease);
    print(colorFreeCopies);
    print(colorPagePrice);
    print("---");
  }
}
