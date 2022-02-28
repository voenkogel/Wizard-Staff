import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'Session.dart';
import 'globals.dart';
import 'homePage.dart';
import 'main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

int pageIndex = 0;
const int pageCount = 5;

PageController pageController = PageController(
  initialPage: 0,
);

class MyStartPage extends StatefulWidget {
  const MyStartPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyStartPage> createState() => _MyStartPageState();
}

class _MyStartPageState extends State<MyStartPage> {
  @override
  void initState() {
    super.initState();

    resumeSession();
  }

  void resumeSession() async {
    Future.delayed(
      const Duration(microseconds: 400),
      () {
        if (Hive.box('settings').get('activeSession') == true) {
          String groupName = getSession().groupName;
          print('FOUND PREVIOUS SESSION: ' + groupName);
          refreshThemeGlobal();
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    MyHomePage(
                      title: groupName,
                    )
                //transitionsBuilder: slideTransition,
                ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Session session = Session();
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          children: [
            Expanded(
              child: PageView(
                  onPageChanged: (int page) {
                    setState(() {
                      pageIndex = page;
                    });
                  },
                  controller: pageController,
                  children: [
                    tutorialPage(
                        context,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(
                                width: 300,
                                height: 230,
                                image: AssetImage('images/mainLogo.png')),
                            Text('Welcome to the Wizard Staff drinking game!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            SizedBox(
                              height: 30,
                            ),
                            Text('Swipe left to get started',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        )),
                    tutorialPage(
                        context,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                                'The goal of Wizard Staffing is to build your Wizard Staff as tall as possible',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            SizedBox(height: 20),
                            Text(
                                'Drink and stack the empty beer cans on top of each other using duct tape, to create a Staff',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            SizedBox(
                              height: 40,
                            ),
                            Image(
                                width: 200,
                                height: 185,
                                image: AssetImage(
                                    'images/WizardStaffTutorial.png')),
                          ],
                        )),
                    tutorialPage(
                        context,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                                'Each time you finish a beer can, you level up',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Boss fights occur every few levels',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            SizedBox(height: 70),
                            Image(
                                width: 140,
                                height: 100,
                                image: AssetImage('images/Shot.png')),
                          ],
                        )),
                    tutorialPage(
                        context,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                                'When your Wizard Staff is taller than yourself, you win the game!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            SizedBox(
                              height: 70,
                            ),
                            Image(
                                width: 200,
                                height: 150,
                                image: AssetImage(
                                    'images/WizardStaffTutorial2.png')),
                          ],
                        )),
                    LoginPage(
                      session: session,
                      refreshTheme: refreshThemeGlobal,
                    ),
                  ]),
            ),
            SmoothPageIndicator(
                controller: pageController, // PageController
                count: 5,
                effect: const WormEffect(
                    spacing: 12,
                    radius: 20,
                    dotColor: Color(0xAAb7b7b7),
                    activeDotColor: Colors.white), // your preferred effect
                onDotClicked: (index) {
                  pageController.animateTo(
                      MediaQuery.of(context).size.width * index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget tutorialPage(BuildContext context, Widget child) {
    return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 20),
        decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: child,
        ));
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.session, required this.refreshTheme})
      : super(key: key);

  final Session session;
  Function refreshTheme;

  @override
  State<LoginPage> createState() => _LoginPageState(refreshTheme);
}

class _LoginPageState extends State<LoginPage> {
  Function RefreshTheme;

  _LoginPageState(this.RefreshTheme);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 90),
            const Image(
              image: AssetImage('images/mainLogo.png'),
              width: 280,
            ),
            const SizedBox(height: 40),
            Card(
              color: lightTheme.canvasColor,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Login",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.5,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        decoration: const InputDecoration(labelText: 'Name'),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null) {
                            return 'You must fill in your name';
                          }
                          if (value == "") {
                            return 'You must fill in your name';
                          }
                        },
                        onChanged: (value) => widget.session.groupName = value),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Length (cm)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null) {
                          return 'You must fill in your length';
                        }
                        if (value == "") {
                          return 'You must fill in your length';
                        }
                        if (int.parse(value) < 100 || int.parse(value) > 250) {
                          return 'Please fill in realistic values';
                        }
                      },
                      onChanged: (value) {
                        if (value != "") {
                          int? heightVal = int.tryParse(value);
                          if (heightVal != null) {
                            widget.session.height = heightVal;
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Type of can: '),
                        DropdownButton<String>(
                          value:
                              canHeightToDisplayName(widget.session.canHeight),
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: null,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              if (newValue != null) {
                                widget.session.canHeight =
                                    displayNameToCanHeight(newValue);
                              }
                            });
                          },
                          items: List<DropdownMenuItem<String>>.generate(
                              blikjes.length, (index) {
                            return DropdownMenuItem(
                              value: blikjes[index].displayName,
                              child: Text(blikjes[index].displayName),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text("Next"),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (widget.session.klokData.isEmpty) {
                            widget.session.startTime = DateTime.now();
                          }
                          saveSession(widget.session);
                          Hive.box('settings').put('activeSession', true);
                          refreshThemeGlobal();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => MyHomePage(
                              title: widget.session.groupName,
                            ),
                            //transitionsBuilder: slideTransition,
                          ));
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
