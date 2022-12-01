import 'dart:convert';

import 'package:my_wallet/day.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Data {
  Future<String> getFilePath() async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/DailyStat.json'; // 3

    return filePath;
  }

  List reasonsForTransactions = [
    "Misc",
    // "Tea",
    // "Food",
    // "Supper",
    // "Dinner",
    // "Transport",
    // "Fuel",
    // "Bike",
    // "Rent",
    // "Pocket Money",
    // "Freelance"
  ];

  List payees = [
    // "Zaheer", "Hassan", "Yaqoob"
  ];
  List reasonsForTimeSpent = [
    // "Freelance",
    // "Reasearch",
    // "Civil",
    // "Movie",
    // "Outing"
  ];
  List<Day> days = [];

  String _toJson() {
    var listOfJsonDayData = [];
    for (Day day in days) {
      listOfJsonDayData.add(day.toJson());
    }

    Map map = {
      "listOfJsonDayData": listOfJsonDayData,
      "reasonsForTransactions": reasonsForTransactions,
      "reasonsForTimeSpent": reasonsForTimeSpent,
      "payees": payees
    };

    return jsonEncode(map);
  }

  void saveFile() async {
    File file = File(await getFilePath()); // 1
    file.writeAsString(_toJson()); // 2
  }

  Future<bool> readFile() async {
    File file = File(await getFilePath());
    // try {
    if (file.existsSync()) {
      String fileContent = await file.readAsString();
      _loadJson(fileContent);
      // print(fileContent);
      // return true;
    }
    // } catch (e) {
    //   return false;
    // }
    return true;
  }

  void _loadJson(String encodedJson) {
    var decodedJson = jsonDecode(encodedJson);
    reasonsForTransactions = decodedJson["reasonsForTransactions"];
    reasonsForTimeSpent = decodedJson["reasonsForTimeSpent"];
    payees = decodedJson["payees"];

    List listOfJsonDayData = decodedJson["listOfJsonDayData"];
    for (var jsonDayData in listOfJsonDayData) {
      Day tDay = Day.fromJson(jsonDayData);
      if (tDay.transactions.isNotEmpty ||
          tDay.periods.isNotEmpty ||
          tDay.debts.isNotEmpty) {
        days.add(tDay);
      } else {
        continue;
      }
    }
  }

  List<Day> monthlyBarData(DateTime date) {
    List<Day> _monthlyBarData = [];
    for (Day element in days) {
      if (element.date.month == date.month && element.date.year == date.year) {
        _monthlyBarData.add(element);
      }
    }
    _monthlyBarData.sort((a, b) => a.date.day.compareTo(b.date.day));
    return _monthlyBarData;
  }

  double maxMonthlyTransaction(DateTime date, List<Day> montlyBarData) {
    List<Day> monthlyBarData = [];
    for (Day element in monthlyBarData) {
      if (element.date.month == date.month && element.date.year == date.year) {
        monthlyBarData.add(element);
      }
    }
    monthlyBarData.sort((a, b) => a.date.day.compareTo(b.date.day));
    double maxval = 0;
    for (Day element in days) {
      if (element.netTransaction.abs() > maxval) {
        maxval = element.netTransaction.abs();
      }
    }
    return maxval;
  }

  double maxMonthlyPeriod(DateTime date, List<Day> montlyBarData) {
    double maxval = 0;
    for (Day element in montlyBarData) {
      if (element.netWorkingPeriod.abs() > maxval) {
        maxval = element.netWorkingPeriod.abs();
      }
      if (element.netRelaxingPeriod.abs() > maxval) {
        maxval = element.netRelaxingPeriod.abs();
      }
    }
    return maxval;
  }

  Map allDebts() {
    Map netDebt = {};
    List payees = [];
    for (Day element in days) {
      for (Map map in element.debts) {
        String name = map["name"];
        payees.add(name);
      }
    }
    for (String payee in payees) {
      double debt = 0;
      for (Day element in days) {
        for (Map mdebt in element.debts) {
          if (mdebt["name"] == payee) {
            if (mdebt["type"] == TransactionType.Credit) {
              debt += mdebt["amount"];
            }
            if (mdebt["type"] == TransactionType.Debit) {
              debt -= mdebt["amount"];
            }
          }
        }
      }
      netDebt[payee] = debt;
    }
    return netDebt;
  }

  Map monthlyTransactionData(DateTime date) {
    Map monthlyTransactions = {};
    List tReasons = [];
    for (Day element in days) {
      for (Map map in element.transactions) {
        String reason = map["reason"];
        tReasons.add(reason);
      }
    }
    for (String reason in tReasons) {
      double amount = 0;
      for (Day element in days) {
        if (element.date.month == date.month &&
            element.date.year == date.year) {
          for (Map mtransaction in element.transactions) {
            if (mtransaction["reason"] == reason) {
              if (mtransaction["type"] == TransactionType.Credit) {
                amount += mtransaction["amount"];
              }
              if (mtransaction["type"] == TransactionType.Debit) {
                amount -= mtransaction["amount"];
              }
            }
          }
        }
      }
      if (amount != 0) monthlyTransactions[reason] = amount;
    }
    return monthlyTransactions;
  }

  Map monthlyPeriodData(DateTime date) {
    Map monthlyPeriods = {};
    List pReasons = [];
    for (Day element in days) {
      for (Map map in element.periods) {
        String reason = map["reason"];
        pReasons.add(reason);
      }
    }
    for (String reason in pReasons) {
      double amount = 0;
      for (Day element in days) {
        if (element.date.month == date.month &&
            element.date.year == date.year) {
          for (Map mperiod in element.periods) {
            if (mperiod["reason"] == reason) {
              if (mperiod["type"] == PeriodType.Work) {
                amount += mperiod["amount"];
              }
              if (mperiod["type"] == PeriodType.Relax) {
                amount -= mperiod["amount"];
              }
            }
          }
        }
      }
      if (amount != 0) monthlyPeriods[reason] = amount;
    }
    return monthlyPeriods;
  }

  double totalMonthlyCredit(DateTime date) {
    double val = 0;
    monthlyTransactionData(date).entries.forEach((element) {
      if (element.value > 0) {
        val += element.value;
      }
    });
    return val;
  }

  double totalMonthlyDebit(DateTime date) {
    double val = 0;
    monthlyTransactionData(date).entries.forEach((element) {
      if (element.value < 0) {
        val += element.value;
      }
    });
    return val;
  }

  double monthlyWorkingHours(DateTime date) {
    double val = 0;
    monthlyPeriodData(date).entries.forEach((element) {
      if (element.value > 0) {
        val += element.value;
      }
    });
    return val / 60;
  }
}
