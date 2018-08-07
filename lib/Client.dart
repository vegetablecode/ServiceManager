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
  var initialCopies = 0; // poczatkowa liczba kopii (czb)
  var initialColorCopies = 0; // poczatkowa liczba kopii (kolor)
  var newCopyCount = 0;
  var newColorCopyCount = 0;
  var prevCopyCount = 0;
  var prevColorCopyCount = 0;
  var copiesLimitReached = false;
  var isInvoicePaid = false;
  var noAgreement = false;

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
      this.initialColorCopies,
      this.newCopyCount,
      this.newColorCopyCount,
      this.prevCopyCount,
      this.prevColorCopyCount,
      this.copiesLimitReached,
      this.isInvoicePaid,
      this.noAgreement);

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
        initialColorCopies = json['initialColorCopies'],
        newCopyCount = json['newCopyCount'],
        newColorCopyCount = json['newColorCopyCount'],
        prevCopyCount = json['prevCopyCount'],
        prevColorCopyCount = json['prevColorCopyCount'],
        copiesLimitReached = json['copiesLimitReached'],
        isInvoicePaid = json['isInvoicePaid'],
        noAgreement = json['noAgreement'];

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
        'initialColorCopies': initialColorCopies,
        'newCopyCount': newCopyCount,
        'newColorCopyCount': newColorCopyCount,
        'prevCopyCount': prevCopyCount,
        'prevColorCopyCount': prevColorCopyCount,
        'copiesLimitReached': copiesLimitReached,
        'isInvoicePaid': isInvoicePaid,
        'noAgreement': noAgreement
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
