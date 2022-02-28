import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'Session.dart';
import 'globals.dart';
import 'main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class MySettings extends StatefulWidget {
  MySettings({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFF00F260),
                Color(0xFF0575E6),
              ],
              begin: FractionalOffset(1.0, 0.0),
              end: FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                const SizedBox(
                  height: 230,
                ),
                Expanded(
                  child: Container(
                    color: Hive.box('settings').get('darkMode')
                        ? const Color(0xFF141414)
                        : const Color(0xFFdddddd),
                  ),
                ),
              ],
            ),
            ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            SizedBox(
                              width: 12,
                            ),
                            Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                                child: Text(
                              'Back',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 20),
                            )),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 40),
                            )),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 10, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Enable Boss Fights",
                                    style: TextStyle(
                                      color:
                                          Hive.box('settings').get('darkMode')
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                  Switch(
                                    value: Hive.box('settings')
                                        .get('enableBossFights'),
                                    onChanged: (value) {
                                      setState(() {
                                        Hive.box('settings')
                                            .put('enableBossFights', value);
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            if (Hive.box('settings').get('enableBossFights'))
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 10, top: 15, bottom: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Boss fight will occur every ",
                                      style: TextStyle(
                                        color:
                                            Hive.box('settings').get('darkMode')
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      height: 28,
                                      width: 28,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(9)),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      child: Center(
                                        child: Text(
                                            Hive.box('settings')
                                                .get('bossLevelInterval')
                                                .toInt()
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17)),
                                      ),
                                    ),
                                    Text(
                                      ' levels',
                                      style: TextStyle(
                                        color:
                                            Hive.box('settings').get('darkMode')
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (Hive.box('settings').get('enableBossFights'))
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10, top: 0, bottom: 5),
                                  child: Slider(
                                    max: 8,
                                    min: 1,
                                    divisions: 7,
                                    value: Hive.box('settings')
                                        .get('bossLevelInterval')
                                        .toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        Hive.box('settings')
                                            .put('bossLevelInterval', value);
                                      });
                                    },
                                  )),
                          ],
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 10, top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Dark Mode",
                                    style: TextStyle(
                                      color:
                                          Hive.box('settings').get('darkMode')
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                  Switch(
                                    value: Hive.box('settings').get('darkMode'),
                                    onChanged: (value) {
                                      setState(() {
                                        Hive.box('settings')
                                            .put('darkMode', value);
                                        refreshThemeGlobal();
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 10, top: 10, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Level up cooldown",
                                    style: TextStyle(
                                      color:
                                          Hive.box('settings').get('darkMode')
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                  Switch(
                                    value: Hive.box('settings').get('addDelay'),
                                    onChanged: (value) {
                                      setState(() {
                                        Hive.box('settings')
                                            .put('addDelay', value);
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 10, top: 10, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Donation reminder enabled",
                                    style: TextStyle(
                                      color:
                                          Hive.box('settings').get('darkMode')
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                  Switch(
                                    value: Hive.box('settings')
                                        .get('donationReminder'),
                                    onChanged: (value) {
                                      setState(() {
                                        Hive.box('settings')
                                            .put('donationReminder', value);
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: shareWithFriends,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 15, top: 20, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Play with your friends",
                                      style: TextStyle(
                                        color:
                                            Hive.box('settings').get('darkMode')
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.share,
                                        color: Colors.grey,
                                        size: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: leaveAReview,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 15, top: 20, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Leave a Review",
                                      style: TextStyle(
                                        color:
                                            Hive.box('settings').get('darkMode')
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey,
                                        size: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 15, top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Support the Development",
                                    style: TextStyle(
                                      color:
                                          Hive.box('settings').get('darkMode')
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: null,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    onPressed: openDonation,
                                    child: SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          Icon(Icons.attach_money),
                                          Text(
                                            'Donate',
                                            textScaleFactor: 1.1,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void openDonation() async {
  var url = 'https://www.paypal.com/donate/?hosted_button_id=N78F23UAF855A';
  if (!await launch(url, forceWebView: true, enableJavaScript: true)) {
    throw 'Could not launch $url';
  }
}

void leaveAReview() async {
  var url =
      'https://play.google.com/store/apps/details?id=com.RocketWings.WizardStaff';
  if (!await launch(url, forceWebView: false, enableJavaScript: true)) {
    throw 'Could not launch $url';
  }
}

void shareWithFriends() {
  WcFlutterShare.share(
      sharePopupTitle: 'Let\'s play Wizard Staff together!',
      subject: 'Let\'s play Wizard Staff together!',
      text:
          'Let\'s play Wizard Staff together! Get drunk by building your Wizard Staff out of empty beer cans, download for free: https://play.google.com/store/apps/details?id=com.RocketWings.WizardStaff',
      mimeType: 'text/plain');
}
