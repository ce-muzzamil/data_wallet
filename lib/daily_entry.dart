import 'package:flutter/material.dart';
import 'package:my_wallet/data.dart';
import 'package:my_wallet/day.dart';

class CardList extends StatefulWidget {
  Data data;
  Function addAndSave;
  Day day;
  CardList(this.data, this.day, this.addAndSave);
  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  var currentPage = 3 - 1.0;
  TextEditingController transactionalTextController = TextEditingController();
  TransactionType transactionType = TransactionType.None;
  String transactionReason = "Misc";

  TextEditingController periodTextController = TextEditingController();
  PeriodType periodType = PeriodType.None;
  String timeSpentReason = "";

  TextEditingController debtTextController = TextEditingController();
  TransactionType debtTransactionType = TransactionType.None;
  String debtTo = "";

  Container transactionalDataEntry(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      height: 230,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6 - 15,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      height: 75,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: transactionalTextController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  color: transactionType ==
                                          TransactionType.Credit
                                      ? Colors.green
                                      : transactionType == TransactionType.Debit
                                          ? Colors.red
                                          : Colors.black54,
                                  fontSize: 24),
                            ),
                            margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                            width:
                                (MediaQuery.of(context).size.width * 0.6 - 15) *
                                        0.5 -
                                    5,
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    transactionType = TransactionType.Credit;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  width:
                                      (MediaQuery.of(context).size.width * 0.6 -
                                                  15) *
                                              0.5 -
                                          20,
                                  height: 70 / 2 - 7.5,
                                  child: Center(
                                    child: Text(
                                      "Credit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: transactionType ==
                                                TransactionType.Credit
                                            ? Colors.green
                                            : Colors.black38,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white70,
                                        offset: Offset(-4, -4),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(4, 4),
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    transactionType = TransactionType.Debit;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 10),
                                  width:
                                      (MediaQuery.of(context).size.width * 0.6 -
                                                  15) *
                                              0.5 -
                                          20,
                                  height: 70 / 2 - 7.5,
                                  child: Center(
                                    child: Text(
                                      "Debit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: transactionType ==
                                                TransactionType.Debit
                                            ? Colors.red
                                            : Colors.black38,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white70,
                                        offset: Offset(-4, -4),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(4, 4),
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6 - 50,
                      height: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white70,
                              offset: Offset(-2, -2),
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(2, 2),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                      height: 10,
                      child: Container(),
                    ),
                    Container(
                      height: 110,
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: SingleChildScrollView(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          runSpacing: 2,
                          spacing: 2,
                          children: [
                            ...[
                              ...widget.data.reasonsForTransactions.map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      transactionReason = e;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: transactionReason == e
                                          ? transactionType ==
                                                  TransactionType.Credit
                                              ? Colors.green
                                              : transactionType ==
                                                      TransactionType.Debit
                                                  ? Colors.red
                                                  : Colors.grey[600]
                                          : Colors.grey[600],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController
                                          reasonTextController =
                                          TextEditingController();
                                      return AlertDialog(
                                        title: Text("Add a reason"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller:
                                                    reasonTextController,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      widget.data
                                                          .reasonsForTransactions
                                                          .add(
                                                              reasonTextController
                                                                  .text);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Icon(Icons
                                                        .done_outline_rounded),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.add_circle,
                                color: Colors.grey[600]!,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Delete"),
                                        content: SingleChildScrollView(
                                          child: Wrap(
                                            alignment: WrapAlignment.center,
                                            runSpacing: 2,
                                            spacing: 2,
                                            children: [
                                              ...widget
                                                  .data.reasonsForTransactions
                                                  .map(
                                                (e) => GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      widget.data
                                                          .reasonsForTransactions
                                                          .remove(e);
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: transactionReason ==
                                                              e
                                                          ? transactionType ==
                                                                  TransactionType
                                                                      .Credit
                                                              ? Colors.green
                                                              : transactionType ==
                                                                      TransactionType
                                                                          .Debit
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .grey[600]
                                                          : Colors.grey[600]!,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      child: Text(
                                                        e,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.grey[600]!,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 2,
                height: 150,
                child: Container(
                  // color: Constant.darkDividerColor,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white70,
                        offset: Offset(-2, -2),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(2, 2),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4 - 17,
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 2,
                    spacing: 2,
                    children: [
                      ...[
                        ...widget.day.transactions.map(
                          (e) => GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "${e['reason']}",
                                        style: TextStyle(
                                            color: e['type'] ==
                                                    TransactionType.Credit
                                                ? Colors.green[500]
                                                : Colors.red[500]),
                                      ),
                                      content: Text(
                                        "${e['amount']}",
                                        style: TextStyle(
                                            color: e['type'] ==
                                                    TransactionType.Credit
                                                ? Colors.green[500]
                                                : Colors.red[500]),
                                      ),
                                      backgroundColor: Colors.grey[300],
                                      elevation: 40,
                                    );
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: e['type'] == TransactionType.Credit
                                    ? Colors.green[500]
                                    : Colors.red[500],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: Text(
                                  "${e['reason']} | ${e['amount'].ceil()}",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Delete"),
                                  content: SingleChildScrollView(
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      runSpacing: 2,
                                      spacing: 2,
                                      children: [
                                        ...[
                                          ...widget.day.transactions.map(
                                            (e) => GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  widget.day.removeTransaction(
                                                      widget.day.date, e["id"]);
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: e['type'] ==
                                                          TransactionType.Credit
                                                      ? Colors.green[500]
                                                      : Colors.red[500],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(6),
                                                  child: Text(
                                                    "${e['reason']} | ${e['amount']}",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.grey[600]!,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(
                Icons.done,
                color: transactionType == TransactionType.None ||
                        transactionalTextController.text == ""
                    ? Colors.grey[300]!
                    : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  if (transactionType != TransactionType.None &&
                      transactionalTextController.text != "") {
                    double amount = 0;
                    try {
                      amount = double.parse(transactionalTextController.text);
                    } catch (e) {
                      transactionalTextController.text = 0.toString();
                      amount = double.parse(transactionalTextController.text);
                    }
                    widget.day.addTransaction(
                        transactionType, amount.abs(), transactionReason);

                    transactionType = TransactionType.None;
                    transactionReason = "Misc";
                    widget.addAndSave.call();
                  }
                });
              },
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white70,
            offset: Offset(-4, -4),
            blurRadius: 5,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: Offset(4, 4),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Container debtDataEntry(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      height: 230,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6 - 15,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      height: 75,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: debtTextController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  color: debtTransactionType ==
                                          TransactionType.Credit
                                      ? Colors.green
                                      : debtTransactionType ==
                                              TransactionType.Debit
                                          ? Colors.red
                                          : Colors.black54,
                                  fontSize: 24),
                            ),
                            margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                            width:
                                (MediaQuery.of(context).size.width * 0.6 - 15) *
                                        0.5 -
                                    5,
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    debtTransactionType =
                                        TransactionType.Credit;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  width:
                                      (MediaQuery.of(context).size.width * 0.6 -
                                                  15) *
                                              0.5 -
                                          20,
                                  height: 70 / 2 - 7.5,
                                  child: Center(
                                    child: Text(
                                      "Credit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: debtTransactionType ==
                                                TransactionType.Credit
                                            ? Colors.green
                                            : Colors.black38,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white70,
                                        offset: Offset(-4, -4),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(4, 4),
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    debtTransactionType = TransactionType.Debit;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 10),
                                  width:
                                      (MediaQuery.of(context).size.width * 0.6 -
                                                  15) *
                                              0.5 -
                                          20,
                                  height: 70 / 2 - 7.5,
                                  child: Center(
                                    child: Text(
                                      "Debit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: debtTransactionType ==
                                                TransactionType.Debit
                                            ? Colors.red
                                            : Colors.black38,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white70,
                                        offset: Offset(-4, -4),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(4, 4),
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6 - 50,
                      height: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white70,
                              offset: Offset(-2, -2),
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(2, 2),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                      height: 10,
                      child: Container(),
                    ),
                    Container(
                      height: 110,
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: SingleChildScrollView(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          runSpacing: 2,
                          spacing: 2,
                          children: [
                            ...[
                              ...widget.data.payees.map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      debtTo = e;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: debtTo == e
                                          ? debtTransactionType ==
                                                  TransactionType.Credit
                                              ? Colors.green
                                              : debtTransactionType ==
                                                      TransactionType.Debit
                                                  ? Colors.red
                                                  : Colors.grey[600]
                                          : Colors.grey[600]!,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController
                                          reasonTextController =
                                          TextEditingController();
                                      return AlertDialog(
                                        title: Text("Add a reason"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller:
                                                    reasonTextController,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      widget.data.payees.add(
                                                          reasonTextController
                                                              .text);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Icon(Icons
                                                        .done_outline_rounded),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.add_circle,
                                color: Colors.grey[600]!,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Delete"),
                                        content: SingleChildScrollView(
                                          child: Wrap(
                                            alignment: WrapAlignment.center,
                                            runSpacing: 2,
                                            spacing: 2,
                                            children: [
                                              ...widget.data.payees.map(
                                                (e) => GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      widget.data.payees
                                                          .remove(e);
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: debtTo == e
                                                          ? debtTransactionType ==
                                                                  TransactionType
                                                                      .Credit
                                                              ? Colors.green
                                                              : debtTransactionType ==
                                                                      TransactionType
                                                                          .Debit
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .grey[600]
                                                          : Colors.grey[600]!,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      child: Text(
                                                        e,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.grey[600]!,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 2,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white70,
                        offset: Offset(-2, -2),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(2, 2),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4 - 17,
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 2,
                    spacing: 2,
                    children: [
                      ...[
                        ...widget.day.debts.map(
                          (e) => GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "${e['name']}",
                                        style: TextStyle(
                                            color: e['type'] ==
                                                    TransactionType.Credit
                                                ? Colors.green[500]
                                                : Colors.red[500]),
                                      ),
                                      content: Text(
                                        "${e['amount']}",
                                        style: TextStyle(
                                            color: e['type'] ==
                                                    TransactionType.Credit
                                                ? Colors.green[500]
                                                : Colors.red[500]),
                                      ),
                                      backgroundColor: Colors.grey[300],
                                      elevation: 40,
                                    );
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: e['type'] == TransactionType.Credit
                                    ? Colors.green[500]
                                    : Colors.red[500],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: Text(
                                  "${e['name']} | ${e['amount'].ceil()}",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Delete"),
                                  content: SingleChildScrollView(
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      runSpacing: 2,
                                      spacing: 2,
                                      children: [
                                        ...[
                                          ...widget.day.debts.map(
                                            (e) => GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  widget.day.removeDebt(
                                                      widget.day.date, e["id"]);
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: e['type'] ==
                                                          TransactionType.Credit
                                                      ? Colors.green[500]
                                                      : Colors.red[500],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(6),
                                                  child: Text(
                                                    "${e['name']} | ${e['amount']}",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.grey[600]!,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(
                Icons.done,
                color: debtTransactionType == TransactionType.None ||
                        debtTextController.text == "" ||
                        debtTo == ""
                    ? Colors.grey[300]!
                    : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  if (debtTransactionType != TransactionType.None &&
                      debtTextController.text != "" &&
                      debtTo != "") {
                    double amount = 0;
                    try {
                      amount = double.parse(debtTextController.text);
                    } catch (e) {
                      debtTextController.text = 0.toString();
                      amount = double.parse(debtTextController.text);
                    }
                    widget.day
                        .addDebt(debtTransactionType, amount.abs(), debtTo);

                    debtTransactionType = TransactionType.None;
                    debtTo = "";
                    widget.addAndSave.call();
                  }
                });
              },
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white70,
            offset: Offset(-4, -4),
            blurRadius: 5,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: Offset(4, 4),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Container periodDataEntry(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      height: 230,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6 - 15,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      height: 75,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: periodTextController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  color: periodType == PeriodType.Work
                                      ? Colors.green
                                      : periodType == PeriodType.Relax
                                          ? Colors.red
                                          : Colors.black54,
                                  fontSize: 24),
                            ),
                            margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                            width:
                                (MediaQuery.of(context).size.width * 0.6 - 15) *
                                        0.5 -
                                    5,
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    periodType = PeriodType.Work;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  width:
                                      (MediaQuery.of(context).size.width * 0.6 -
                                                  15) *
                                              0.5 -
                                          20,
                                  height: 70 / 2 - 7.5,
                                  child: Center(
                                    child: Text(
                                      "Work",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: periodType == PeriodType.Work
                                            ? Colors.green
                                            : Colors.black38,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white70,
                                        offset: Offset(-4, -4),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(4, 4),
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    periodType = PeriodType.Relax;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 10),
                                  width:
                                      (MediaQuery.of(context).size.width * 0.6 -
                                                  15) *
                                              0.5 -
                                          20,
                                  height: 70 / 2 - 7.5,
                                  child: Center(
                                    child: Text(
                                      "Relax",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: periodType == PeriodType.Relax
                                            ? Colors.red
                                            : Colors.black38,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white70,
                                        offset: Offset(-4, -4),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(4, 4),
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6 - 50,
                      height: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white70,
                              offset: Offset(-2, -2),
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(2, 2),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                      height: 10,
                      child: Container(),
                    ),
                    Container(
                      height: 110,
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: SingleChildScrollView(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          runSpacing: 2,
                          spacing: 2,
                          children: [
                            ...[
                              ...widget.data.reasonsForTimeSpent.map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      timeSpentReason = e;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: timeSpentReason == e
                                          ? periodType == PeriodType.Work
                                              ? Colors.green
                                              : periodType == PeriodType.Relax
                                                  ? Colors.red
                                                  : Colors.grey[600]
                                          : Colors.grey[600]!,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController
                                          reasonTextController =
                                          TextEditingController();
                                      return AlertDialog(
                                        title: Text("Add a reason"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller:
                                                    reasonTextController,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      widget.data
                                                          .reasonsForTimeSpent
                                                          .add(
                                                              reasonTextController
                                                                  .text);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Icon(Icons
                                                        .done_outline_rounded),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.add_circle,
                                color: Colors.grey[600]!,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Delete"),
                                        content: SingleChildScrollView(
                                          child: Wrap(
                                            alignment: WrapAlignment.center,
                                            runSpacing: 2,
                                            spacing: 2,
                                            children: [
                                              ...widget.data.reasonsForTimeSpent
                                                  .map(
                                                (e) => GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      widget.data
                                                          .reasonsForTimeSpent
                                                          .remove(e);
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: timeSpentReason ==
                                                              e
                                                          ? periodType ==
                                                                  PeriodType
                                                                      .Work
                                                              ? Colors.green
                                                              : periodType ==
                                                                      PeriodType
                                                                          .Relax
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .grey[600]
                                                          : Colors.grey[600]!,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      child: Text(
                                                        e,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.grey[600]!,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 2,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white70,
                        offset: Offset(-2, -2),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(2, 2),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4 - 17,
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 2,
                    spacing: 2,
                    children: [
                      ...[
                        ...widget.day.periods.map(
                          (e) => GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "${e['reason']}",
                                        style: TextStyle(
                                            color: e['type'] == PeriodType.Work
                                                ? Colors.green[500]
                                                : Colors.red[500]),
                                      ),
                                      content: Text(
                                        "${e['amount']}",
                                        style: TextStyle(
                                            color: e['type'] == PeriodType.Work
                                                ? Colors.green[500]
                                                : Colors.red[500]),
                                      ),
                                      backgroundColor: Colors.grey[300],
                                      elevation: 40,
                                    );
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: e['type'] == PeriodType.Work
                                    ? Colors.green[500]
                                    : Colors.red[500],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: Text(
                                  "${e['reason']} | ${e['amount'].ceil()}",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Delete"),
                                  content: SingleChildScrollView(
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      runSpacing: 2,
                                      spacing: 2,
                                      children: [
                                        ...[
                                          ...widget.day.periods.map(
                                            (e) => GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  widget.day.removePeriod(
                                                      widget.day.date, e["id"]);
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: e['type'] ==
                                                          PeriodType.Work
                                                      ? Colors.green[500]
                                                      : Colors.red[500],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(6),
                                                  child: Text(
                                                    "${e['reason']} | ${e['amount']}",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.grey[600]!,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(
                Icons.done,
                color: periodType == PeriodType.None ||
                        periodTextController.text == "" ||
                        timeSpentReason == ""
                    ? Colors.grey[300]!
                    : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  if (periodType != PeriodType.None &&
                      periodTextController.text != "" &&
                      timeSpentReason != "") {
                    double amount = 0;
                    try {
                      amount = double.parse(periodTextController.text);
                    } catch (e) {
                      periodTextController.text = 0.toString();
                      amount = double.parse(periodTextController.text);
                    }
                    widget.day
                        .addPeriod(periodType, amount.abs(), timeSpentReason);

                    periodType = PeriodType.None;
                    timeSpentReason = "";
                    widget.addAndSave.call();
                  }
                });
              },
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white70,
            offset: Offset(-4, -4),
            blurRadius: 5,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: Offset(4, 4),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 3 - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page!;
      });
    });
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 250,
            child: PageView.builder(
              itemCount: 3,
              controller: controller,
              reverse: true,
              itemBuilder: (context, index) {
                return index == 2
                    ? transactionalDataEntry(context)
                    : index == 1
                        ? periodDataEntry(context)
                        : index == 0
                            ? debtDataEntry(context)
                            : Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
