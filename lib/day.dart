import 'dart:convert';

enum TransactionType { Debit, Credit, None }
enum PeriodType { Work, Relax, None }

class Day {
  DateTime date;
  final List<Map> _transactions = [];
  final List<Map> _periods = [];
  final List<Map> _debts = [];

  int transactionCounter = 0;
  int periodCounter = 0;
  int debtCounter = 0;

  Day(this.date);
  int get day => date.day;
  int get month => date.month;
  int get year => date.year;

  String _transactionToJson(Map transaction) {
    return jsonEncode({
      "id": transaction["id"],
      "type": transaction["type"] == TransactionType.Credit
          ? "Credit"
          : transaction["type"] == TransactionType.Debit
              ? "Debit"
              : "None",
      "amount": transaction["amount"],
      "reason": transaction["reason"],
    });
  }

  String _periodToJson(Map period) {
    return jsonEncode({
      "id": period["id"],
      "type": period["type"] == PeriodType.Work
          ? "Work"
          : period["type"] == PeriodType.Relax
              ? "Relax"
              : "None",
      "amount": period["amount"],
      "reason": period["reason"],
    });
  }

  String _debtToJson(Map debt) {
    return jsonEncode({
      "id": debt["id"],
      "type": debt["type"] == TransactionType.Credit
          ? "Credit"
          : debt["type"] == TransactionType.Debit
              ? "Debit"
              : "None",
      "amount": debt["amount"],
      "name": debt["name"],
    });
  }

  String toJson() {
    List listOfencodedTransactions = [];
    List listOfencodedPeriods = [];
    List listOfencodedDebts = [];

    for (Map transaction in _transactions) {
      listOfencodedTransactions.add(_transactionToJson(transaction));
    }
    for (Map period in _periods) {
      listOfencodedPeriods.add(_periodToJson(period));
    }
    for (Map debt in _debts) {
      listOfencodedDebts.add(_debtToJson(debt));
    }

    Map dayMap = {
      "date": date.microsecondsSinceEpoch,
      "isUtc": date.isUtc,
      "transactions": listOfencodedTransactions,
      "periods": listOfencodedPeriods,
      "debts": listOfencodedDebts
    };
    String encodedDay = jsonEncode(dayMap);
    return encodedDay;
  }

  static Day fromJson(String encodeDay) {
    final decodedDay = jsonDecode(encodeDay);
    DateTime decodedDate = DateTime.fromMicrosecondsSinceEpoch(
        decodedDay["date"],
        isUtc: decodedDay["isUtc"]);
    Day newDay = Day(decodedDate);
    final decodedTransactions = decodedDay["transactions"];
    final decodedPeriods = decodedDay["periods"];
    final decodedDebts = decodedDay["debts"];

    // print("main : ${decodedTransactions.runtimeType}");
    // for (var x in decodedTransactions) {
    //   print("x type: ${x.runtimeType}");
    //   print(x);
    // }

    for (String jsonTransaction in decodedTransactions) {
      Map decodedTransaction = jsonDecode(jsonTransaction);
      newDay.addTransaction(
          decodedTransaction["type"] == "Credit"
              ? TransactionType.Credit
              : decodedTransaction["type"] == "Debit"
                  ? TransactionType.Debit
                  : TransactionType.None,
          decodedTransaction["amount"],
          decodedTransaction["reason"]);
    }

    for (String jsonPeriod in decodedPeriods) {
      Map decodedPeriod = jsonDecode(jsonPeriod);
      newDay.addPeriod(
          decodedPeriod["type"] == "Work"
              ? PeriodType.Work
              : decodedPeriod["type"] == "Relax"
                  ? PeriodType.Relax
                  : PeriodType.None,
          decodedPeriod["amount"],
          decodedPeriod["reason"]);
    }

    for (String jsonDebt in decodedDebts) {
      Map decodedDebt = jsonDecode(jsonDebt);
      newDay.addDebt(
          decodedDebt["type"] == "Credit"
              ? TransactionType.Credit
              : decodedDebt["type"] == "Debit"
                  ? TransactionType.Debit
                  : TransactionType.None,
          decodedDebt["amount"],
          decodedDebt["name"]);
    }
    return newDay;
  }

  List<Map> get transactions => _transactions;
  void addTransaction(TransactionType type, double amount, String reason) {
    Map transaction = {
      "id": transactionCounter,
      "type": type,
      "amount": amount,
      "reason": reason,
    };
    _transactions.add(transaction);
    transactionCounter += 1;
  }

  void removeTransaction(atDate, int id) {
    var toRemove;
    for (var element in _transactions) {
      if (element["id"] == id) toRemove = element;
    }
    _transactions.remove(toRemove!);
  }

  get periods => _periods;
  void addPeriod(PeriodType type, double time, String reason) {
    Map period = {
      "id": periodCounter,
      "type": type,
      "amount": time,
      "reason": reason,
    };
    _periods.add(period);
    periodCounter += 1;
  }

  void removePeriod(DateTime atDate, int id) {
    var toRemove;
    for (var element in _periods) {
      if (element["id"] == id) toRemove = element;
    }
    _periods.remove(toRemove!);
  }

  get debts => _debts;
  void addDebt(
    TransactionType type,
    double amount,
    String name,
  ) {
    Map debt = {
      "name": name,
      "id": debtCounter,
      "type": type,
      "amount": amount,
    };

    _debts.add(debt);
    debtCounter += 1;
  }

  void removeDebt(DateTime atDate, int id) {
    var toRemove;
    for (var element in _debts) {
      if (element["id"] == id) toRemove = element;
    }
    _debts.remove(toRemove!);
  }

  double get netTransaction {
    double _netTransaction = 0;
    for (Map element in transactions) {
      if (element["type"] == TransactionType.Credit) {
        _netTransaction += element["amount"];
      } else if (element["type"] == TransactionType.Debit) {
        _netTransaction -= element["amount"];
      }
    }
    return _netTransaction;
  }

  double get netWorkingPeriod {
    double _netPeriod = 0;
    for (Map element in periods) {
      if (element["type"] == PeriodType.Work) _netPeriod += element["amount"];
    }
    return _netPeriod;
  }

  double get netRelaxingPeriod {
    double _netPeriod = 0;
    for (Map element in periods) {
      if (element["type"] == PeriodType.Relax) _netPeriod += element["amount"];
    }
    return _netPeriod;
  }
}
