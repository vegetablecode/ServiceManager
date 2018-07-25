class Client {
  // fields
  var name = ""; // nazwa klienta
  var nip = ""; // nip klienta
  var contractPer = 0; // okres umowy
  var rate = 0; // ryczalt
  var deviceName = ""; // nazwa urzadzenia
  var freeCopies = 0; // liczba darmowych kopii
  var pagePrice = 0.0; // cena za kopie

  // boxes
  var quaterRate = false; // rozliczenie kwartalne (false -> miesieczne)
  var tonerIncluded = false; // tonery wliczone w umowe
  var printerLease = false; // dzierzawa

  Client(this.name, this.nip, this.contractPer, this.rate, this.deviceName, this.freeCopies, this.pagePrice, this.quaterRate, this.tonerIncluded, this.printerLease);

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
  }

  void toJSON() {
    
  }

}
