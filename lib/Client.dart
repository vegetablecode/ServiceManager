import 'dart:async';

class Client {
  // fields
  var name = ""; // nazwa klienta
  var nip = ""; // nip klienta
  var contractPer = 0; // okres umowy
  var rate = 0; // ryczalt
  var deviceName = ""; // nazwa urzadzenia
  var freeCopies = 0; // liczba darmowych kopii
  var pagePrice = 0.0; // cena za kopie
  // --- > updated
  var colorFreeCopies = 0; // liczba darmowych kolorowych kopii
  var colorPagePrice = 0.0; // cena za kopie kolorowa
  //List<Appointment> appointments; // spotkania, rozliczenia
  //List<String> tasks = null; // lista zadan
  String beginDate;

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
      this.beginDate);

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
        beginDate = json['beginDate'];

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
        'beginDate': beginDate
      };
}

class Appointment {
  final String date;
  final String nextDate;
  final int numbOfCopies;

  const Appointment(this.date, this.nextDate, this.numbOfCopies);

  Appointment.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        nextDate = json['nextDate'],
        numbOfCopies = json['numbOfCopies'];
}
