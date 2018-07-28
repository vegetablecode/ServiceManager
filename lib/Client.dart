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
  Appointments appointments; // spotkania, rozliczenia
  Tasks tasks; // lista zadan
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

class Appointments {
  List<String> date;
  List<String> nextDate;
  List<int> numbOfCopies;

  void add(String date, String nextDate, int numbOfCopies){
    this.date.add(date);
    this.nextDate.add(nextDate);
    this.numbOfCopies.add(numbOfCopies);
  }
}

class Tasks {
  List<String> taskList;

  void add(String task) {
    taskList.add(task);
  }

  void remove(int index) {
    taskList.removeAt(index);
  }
}
