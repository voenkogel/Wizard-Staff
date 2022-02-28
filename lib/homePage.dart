import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:confetti/confetti.dart' as confetti;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:kutten_met_flutter/Onboarding.dart';
import 'package:kutten_met_flutter/kutten_met_charts.dart';
import 'package:kutten_met_flutter/globals.dart' as globals;
import 'KlokDataPoint.dart';
import 'Session.dart';
import 'globals.dart';
import 'main.dart';
import 'settings.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late confetti.ConfettiController victory;
  //late TooltipBehavior tooltip;

  @override
  void initState() {
    super.initState();
    //tooltip = TooltipBehavior(enable: true);
    victory = confetti.ConfettiController(duration: const Duration(seconds: 2));
    //globals.refreshThemeGlobal();
  }

  @override
  void dispose() {
    victory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(getSession().groupName),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => MySettings(
                      title: 'Settings',
                    ),
                    //transitionsBuilder: slideTransition,
                  ))
                  .then((value) => setState(() {}));
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Put here all widgets that are not slivers.
          ListView(
            padding: const EdgeInsets.all(15.0),
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Beer cans',
                              style: TextStyle(
                                color: Hive.box('settings').get('darkMode')
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              getSession().klokData.length.toString() +
                                  ' / ' +
                                  (getSession().height / getSession().canHeight)
                                      .ceil()
                                      .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Hive.box('settings').get('darkMode')
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Length',
                              style: TextStyle(
                                color: Hive.box('settings').get('darkMode')
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              (getSession().klokData.length *
                                          getSession().canHeight)
                                      .toInt()
                                      .toString() +
                                  ' / ' +
                                  getSession().height.toString() +
                                  ' cm',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Hive.box('settings').get('darkMode')
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              if (getSession().goalReached())
                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                        text: 'Completed Wizard Staff in ',
                        style: TextStyle(
                            color: Hive.box('settings').get('darkMode')
                                ? Colors.white
                                : Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                        children: <InlineSpan>[
                          TextSpan(
                            text: globals.formatDuration(
                                getSession().getCompletionTime()),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ]),
                  ),
                ),
              if (getSession().goalReached())
                const SizedBox(
                  height: 10,
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                height: 10,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: getSession().klokData.length /
                        (getSession().height / getSession().canHeight).ceil(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              BeerChart(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                TextButton(
                  child: Text(
                    getSession().goalReached() ? 'Finish' : 'End Session',
                    style: TextStyle(
                        color: getSession().goalReached() ? null : Colors.red,
                        fontWeight: FontWeight.bold,
                        height: 0.1),
                    textScaleFactor: 1.3,
                  ),
                  onPressed: () => {confirmEndSession(context)},
                ),
                const SizedBox(
                  width: 7,
                )
              ]),
              const SizedBox(height: 10),
              ruleList(),
              const SizedBox(height: 70),
            ],
          ),

          Align(
            alignment: Alignment.topCenter,
            child: confetti.ConfettiWidget(
              confettiController: victory,
              blastDirection: pi / 2,
              maxBlastForce: 5, // set a lower max blast force
              minBlastForce: 2, // set a lower min blast force
              emissionFrequency: 0.05,
              numberOfParticles: 30, // a lot of particles at once
              gravity: 0.3,
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 175,
        height: 60,
        child: FloatingActionButton.extended(
            label: const Text(
              'Level Up',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: addOneBeer,
            tooltip: 'Emptied 1 beer can',
            icon: const ImageIcon(
              AssetImage('images/icons/BeerCan.png'),
              size: 35,
            )),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget ruleList() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, bottom: 5),
            child: Text(
              'Special Rules',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                  color: Hive.box('settings').get('darkMode')
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          ),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  items[index].name,
                  style: TextStyle(
                    color: Hive.box('settings').get('darkMode')
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                trailing: const Icon(
                  Icons.article,
                  color: Colors.grey,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(items[index].name),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      content: Text(items[index].content),
                      actions: [
                        TextButton(
                            style: TextButton.styleFrom(primary: Colors.black),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Ok')),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  DateTime lastPressed = DateTime(1993, 9, 7, 17, 30);
  static const int beerDelay = 10;

  addOneBeer() async {
    //cancel function if pressed recently
    if (Hive.box('settings').get('addDelay')) {
      var diff = lastPressed.difference(DateTime.now());
      if (diff.inSeconds.abs() < beerDelay) {
        Fluttertoast.showToast(
            msg: 'Not so fast',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
    }
    lastPressed = DateTime.now();

    //save data
    Session session = getSession();
    KlokDataPoint newPoint = KlokDataPoint(
        id: session.klokData.length + 1, dateTime: DateTime.now());
    session.klokData.add(newPoint);
    saveSession(session);

    setState(() {
      var session = getSession();
      if (session.goalReachedExactly()) {
        victory.play();
        session.completionTime = DateTime.now();
        saveSession(session);
        Fluttertoast.showToast(
            msg: 'Congrats on completing your Wizard Staff!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      //trigger donation reminders
      if (session.donationReminderTime()) {
        donationReminder(context);
      }

      //trigger boss fights
      int interval = Hive.box('settings').get('bossLevelInterval').toInt();
      bool bossFightEnabled = Hive.box('settings').get('enableBossFights');
      bool bossFightTime = session.klokData.length % interval == 0;
      if (bossFightTime && bossFightEnabled && !session.goalReached()) {
        bossFight(context);
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Added one beer can'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            Undo(context);
          });
        },
      ),
    ));
  }
}

void Undo(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  Session session = getSession();
  session.klokData.removeLast();
  saveSession(session);
}

void confirmEndSession(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('End current session'),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: const Text('Are you sure? This action cannot be undone'),
      actions: [
        TextButton(
            style: TextButton.styleFrom(primary: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: getSession().goalReached() ? null : Colors.red),
            onPressed: () {
              //END THE SESSION
              Session session = Session();
              saveSession(session);
              Hive.box('settings').put('activeSession', false);
              initHive();
              globals.refreshThemeGlobal();
              RestartWidget.restartApp(context);
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => const MyStartPage(title: 'Onboarding'),
              //   //transitionsBuilder: slideTransition,
              // ));
            },
            child: const Text('Yes')),
      ],
    ),
  );
}

void donationReminder(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Enjoying the app?'),
      content: const Text(
          'Consider donating a few bucks to help the developers continue their work'),
      actions: [
        TextButton(
            style: TextButton.styleFrom(primary: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(primary: null),
            onPressed: openDonation,
            child: const Text('Yes')),
      ],
    ),
  );
}

void bossFight(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Boss Fight!'),
      content: Text(
          'You have survived (another) ${Hive.box('settings').get('bossLevelInterval').toInt().toString()} levels, time to take a shot!'),
      actions: [
        TextButton(
            style: TextButton.styleFrom(primary: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Done')),
      ],
    ),
  );
}
