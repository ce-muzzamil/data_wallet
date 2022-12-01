import 'package:flutter/material.dart';
import 'package:my_wallet/daily_entry.dart';
import 'package:my_wallet/data.dart';
import 'package:my_wallet/day.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp(
    data: Data(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.data}) : super(key: key);
  final Data data;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Stats',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'My Stats',
        data: data,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.data})
      : super(key: key);
  final Data data;
  final String title;
  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  DateTime date = DateTime.now();
  Day? day;
  double netTransaction = 0;
  double netPeriod = 0;
  final format = NumberFormat("#,###", "en_US");
  bool isLoaded = false;

  void addAndSave() {
    setState(() {
      widget.data.saveFile();
      netTransaction = day!.netTransaction;
      netPeriod = day!.netWorkingPeriod;
    });
  }

  void ini() {
    bool isFromData = false;
    for (Day element in widget.data.days) {
      if (date.day == element.date.day &&
          date.month == element.date.month &&
          date.year == element.date.year) {
        day = element;
        isFromData = true;
      }
    }

    if (!isFromData) {
      day = Day(date);
      widget.data.days.add(day!);
    }
    netTransaction = day!.netTransaction;
    netPeriod = day!.netWorkingPeriod;
  }

  @override
  initState() {
    super.initState();
    widget.data.readFile().then(
          (value) => setState(
            () {
              isLoaded = value;
              ini();
            },
          ),
        );
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        // widget.data.saveFile();
        break;
      case AppLifecycleState.inactive:
        // widget.data.saveFile();
        break;
      case AppLifecycleState.paused:
        widget.data.saveFile();
        break;
      case AppLifecycleState.detached:
        widget.data.saveFile();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // widget.data.days = [];
    // widget.data.saveFile();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    List<Day> monthlyBarData = widget.data.monthlyBarData(date);
    double monthlyBarChartInterval =
        widget.data.maxMonthlyTransaction(date, monthlyBarData) / 4;
    double monthlyPeriodBarCharInterval =
        widget.data.maxMonthlyPeriod(date, monthlyBarData) / 4;
    return isLoaded
        ? SafeArea(
            child: Scaffold(
              body: LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TableCalendar(
                            firstDay: DateTime.utc(1950, 01, 01),
                            lastDay: DateTime.utc(2050, 01, 01),
                            focusedDay: DateTime.now(),
                            availableCalendarFormats: const {
                              CalendarFormat.month: "Month"
                            },
                            selectedDayPredicate: (selectedDate) {
                              return isSameDay(selectedDate, date)
                                  ? true
                                  : false;
                            },
                            calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                  color: Colors.blue[300]!,
                                  shape: BoxShape.circle),
                            ),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                date = selectedDay;

                                bool isFromData = false;
                                for (Day element in widget.data.days) {
                                  if (date.day == element.date.day &&
                                      date.month == element.date.month &&
                                      date.year == element.date.year) {
                                    day = element;
                                    isFromData = true;
                                  }
                                }

                                if (!isFromData) {
                                  day = Day(date);
                                  widget.data.days.add(day!);
                                }
                                netTransaction = day!.netTransaction;

                                netPeriod = day!.netWorkingPeriod;
                                widget.data.saveFile();
                              });
                            },
                          ),
                        ),
                        Stack(
                          fit: StackFit.loose,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: CardList(widget.data, day!, addAndSave),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 15, 0, 0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                padding:
                                                    const EdgeInsets.all(0),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[900],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white12,
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
                                                child: const Padding(
                                                  child: Text(
                                                    "Payments",
                                                    style: TextStyle(
                                                      color: Colors.white60,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(7),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 10, 0, 0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[900],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white12,
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
                                                child: const Padding(
                                                  child: Text(
                                                    "Time",
                                                    style: TextStyle(
                                                      color: Colors.white60,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4 -
                                                15,
                                            height: 70,
                                            margin: const EdgeInsets.fromLTRB(
                                                10, 15, 15, 15),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[900],
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(60),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white12,
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
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.only(top: 8),
                                                    child: Text(
                                                      netTransaction
                                                          .abs()
                                                          .ceil()
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          color: netTransaction >
                                                                  0
                                                              ? Colors.green
                                                              : netTransaction <
                                                                      0
                                                                  ? Colors.red
                                                                  : Colors.grey[
                                                                      300]),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4 *
                                                      0.6,
                                                  height: 2,
                                                  child: Container(
                                                    color: Colors.white12,
                                                  ),
                                                ),
                                                Container(
                                                  child: Container(
                                                    child: Text(
                                                      netPeriod
                                                          .ceil()
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          color: netPeriod > 0
                                                              ? Colors.green
                                                              : Colors
                                                                  .grey[300]),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          runSpacing: 2,
                                          spacing: 2,
                                          children: [
                                            ...widget.data
                                                .allDebts()
                                                .entries
                                                .map((e) {
                                              return e.value != 0
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        color: e.value > 0
                                                            ? Colors.green[500]
                                                            : Colors.red[500],
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(6),
                                                        child: Text(
                                                          "${e.key} | ${e.value.abs()}",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 0,
                                                      height: 0,
                                                    );
                                            }),
                                          ],
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width -
                                          15 -
                                          15,
                                      height: 100 - 10 - 10,
                                      margin:
                                          EdgeInsets.fromLTRB(15, 10, 15, 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white12,
                                            offset: Offset(-4, -4),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          ),
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(4, 4),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                //
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 450, 0, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 510,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 15, 15, 15),
                                          child: BarChart(
                                            BarChartData(
                                              titlesData: FlTitlesData(
                                                bottomTitles: SideTitles(
                                                  showTitles: true,
                                                  getTextStyles:
                                                      (BuildContext context,
                                                              double val) =>
                                                          TextStyle(
                                                              color: Colors
                                                                  .blueGrey),
                                                ),
                                                rightTitles: SideTitles(
                                                    showTitles: false),
                                                topTitles: SideTitles(
                                                    showTitles: false),
                                                leftTitles: SideTitles(
                                                  reservedSize: 50,
                                                  interval:
                                                      monthlyBarChartInterval >
                                                              5
                                                          ? monthlyBarChartInterval
                                                          : 5,
                                                  showTitles: true,
                                                  getTextStyles:
                                                      (BuildContext context,
                                                              double val) =>
                                                          TextStyle(
                                                              color: Colors
                                                                  .grey[600]),
                                                ),
                                              ),
                                              gridData: FlGridData(show: false),
                                              borderData: FlBorderData(
                                                border: const Border(
                                                  top: BorderSide.none,
                                                  right: BorderSide.none,
                                                  left: BorderSide.none,
                                                  bottom: BorderSide.none,
                                                ),
                                              ),
                                              groupsSpace: 1,
                                              barGroups: [
                                                ...monthlyBarData.map(
                                                  (e) => BarChartGroupData(
                                                    x: e.date.day,
                                                    barRods: [
                                                      BarChartRodData(
                                                        y: e.netTransaction
                                                            .abs(),
                                                        colors: [
                                                          e.netTransaction > 0
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        margin:
                                            EdgeInsets.fromLTRB(15, 15, 15, 5),
                                        height: 210,
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
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 15, 15, 15),
                                          child: BarChart(
                                            BarChartData(
                                              titlesData: FlTitlesData(
                                                bottomTitles: SideTitles(
                                                  showTitles: true,
                                                  getTextStyles:
                                                      (BuildContext context,
                                                              double val) =>
                                                          TextStyle(
                                                              color: Colors
                                                                  .blueGrey),
                                                ),
                                                rightTitles: SideTitles(
                                                    showTitles: false),
                                                topTitles: SideTitles(
                                                    showTitles: false),
                                                leftTitles: SideTitles(
                                                  reservedSize: 50,
                                                  interval:
                                                      monthlyPeriodBarCharInterval >
                                                              5
                                                          ? monthlyPeriodBarCharInterval
                                                          : 5,
                                                  showTitles: true,
                                                  getTextStyles:
                                                      (BuildContext context,
                                                              double val) =>
                                                          TextStyle(
                                                              color: Colors
                                                                  .grey[600]),
                                                ),
                                              ),
                                              gridData: FlGridData(show: false),
                                              borderData: FlBorderData(
                                                border: const Border(
                                                  top: BorderSide.none,
                                                  right: BorderSide.none,
                                                  left: BorderSide.none,
                                                  bottom: BorderSide.none,
                                                ),
                                              ),
                                              groupsSpace: 2,
                                              barGroups: [
                                                ...monthlyBarData.map(
                                                  (e) => BarChartGroupData(
                                                    x: e.date.day,
                                                    barRods: [
                                                      BarChartRodData(
                                                        y: e.netWorkingPeriod
                                                            .abs(),
                                                        colors: [Colors.green],
                                                      ),
                                                      BarChartRodData(
                                                        y: e.netRelaxingPeriod
                                                            .abs(),
                                                        colors: [Colors.red],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        margin:
                                            EdgeInsets.fromLTRB(15, 5, 15, 15),
                                        height: 210,
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 905, 0, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: PieChart(
                                              PieChartData(
                                                sections: [
                                                  ...widget.data
                                                      .monthlyTransactionData(
                                                          date)
                                                      .entries
                                                      .map(
                                                        (e) => PieChartSectionData(
                                                            value:
                                                                e.value.abs(),
                                                            title: e.key,
                                                            color: e.value > 0
                                                                ? Colors
                                                                    .green[400]
                                                                : Colors
                                                                    .red[400]),
                                                      )
                                                ],
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                15 -
                                                5,
                                            margin: EdgeInsets.fromLTRB(
                                                15, 15, 5, 15),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[900],
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white12,
                                                  offset: Offset(-4, -4),
                                                  blurRadius: 5,
                                                  spreadRadius: 1,
                                                ),
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  offset: Offset(4, 4),
                                                  blurRadius: 5,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: PieChart(
                                              PieChartData(
                                                sections: [
                                                  ...widget.data
                                                      .monthlyPeriodData(date)
                                                      .entries
                                                      .map(
                                                        (e) => PieChartSectionData(
                                                            value:
                                                                e.value.abs(),
                                                            title: e.key,
                                                            color: e.value > 0
                                                                ? Colors
                                                                    .green[400]
                                                                : Colors
                                                                    .red[400]),
                                                      )
                                                ],
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                15 -
                                                5,
                                            margin: EdgeInsets.fromLTRB(
                                                5, 15, 15, 15),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[900],
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white12,
                                                  offset: Offset(-4, -4),
                                                  blurRadius: 5,
                                                  spreadRadius: 1,
                                                ),
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  offset: Offset(4, 4),
                                                  blurRadius: 5,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    format
                                                        .format(widget.data
                                                            .totalMonthlyCredit(
                                                                date)
                                                            .ceil()
                                                            .abs())
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 24,
                                                        color:
                                                            Colors.green[300]),
                                                  ),
                                                ),
                                              ),
                                              margin: EdgeInsets.fromLTRB(
                                                  15, 0, 7.5, 0),
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90) /
                                                  3,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[900],
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white12,
                                                    offset: Offset(-4, -4),
                                                    blurRadius: 5,
                                                    spreadRadius: 1,
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(4, 4),
                                                    blurRadius: 5,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    format
                                                        .format(widget.data
                                                            .totalMonthlyDebit(
                                                                date)
                                                            .abs()
                                                            .ceil())
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 24,
                                                        color: Colors.red[300]),
                                                  ),
                                                ),
                                              ),
                                              margin: EdgeInsets.fromLTRB(
                                                  7.5, 0, 7.5, 0),
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90) /
                                                  3,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[900],
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white12,
                                                    offset: Offset(-4, -4),
                                                    blurRadius: 5,
                                                    spreadRadius: 1,
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(4, 4),
                                                    blurRadius: 5,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    widget.data
                                                        .monthlyWorkingHours(
                                                            date)
                                                        .ceil()
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 24,
                                                        color:
                                                            Colors.green[300]),
                                                  ),
                                                ),
                                              ),
                                              margin: EdgeInsets.fromLTRB(
                                                  7.5, 0, 15, 0),
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90) /
                                                  3,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[900],
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white12,
                                                    offset: Offset(-4, -4),
                                                    blurRadius: 5,
                                                    spreadRadius: 1,
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(4, 4),
                                                    blurRadius: 5,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        height:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                45,
                                        margin:
                                            EdgeInsets.fromLTRB(15, 0, 15, 15),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white12,
                                              offset: Offset(-4, -4),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            ),
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(4, 4),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey[300],
            body: Column(
              children: [
                Container(
                  child: Center(
                    child: Image(
                      image: const AssetImage("assets/images/splash.png"),
                      width: MediaQuery.of(context).size.width / 2 - 30,
                      height: MediaQuery.of(context).size.width / 2 - 30,
                      // color: Colors.blue,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.width / 2,
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 4,
                      100,
                      MediaQuery.of(context).size.width / 4,
                      100),
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
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Daily Stats",
                      style: TextStyle(
                        fontFamily: "SmoochSans",
                        color: Colors.blueGrey,
                        fontSize: 24,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 4,
                      0,
                      MediaQuery.of(context).size.width / 4,
                      100),
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
                )
              ],
            ),
          );
  }
}
