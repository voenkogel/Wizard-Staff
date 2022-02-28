import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'KlokDataPoint.dart';
import 'Onboarding.dart';
import 'Session.dart';
import 'globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  runApp(RestartWidget());
}

bool hiveInitialized = false;
initHive() async {
  if (hiveInitialized) return;
  await Hive.initFlutter();
  hiveInitialized = true;
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SessionAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(KlokDataPointAdapter());
  }

  await Hive.openBox('settings');
  await Hive.openBox('session');

  //default values
  if (Hive.box('settings').get('darkMode') == null) {
    //get system dark mode
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    bool systemDarkMode = brightness == Brightness.dark;
    Hive.box('settings').put('darkMode', systemDarkMode);
  }
  if (Hive.box('settings').get('addDelay') == null) {
    Hive.box('settings').put('addDelay', true);
  }
  if (Hive.box('settings').get('donationReminder') == null) {
    Hive.box('settings').put('donationReminder', true);
  }
  if (Hive.box('settings').get('activeSession') == null) {
    Hive.box('settings').put('activeSession', false);
  }
  if (Hive.box('settings').get('bossLevelInterval') == null) {
    Hive.box('settings').put('bossLevelInterval', 4);
  }
  if (Hive.box('settings').get('enableBossFights') == null) {
    Hive.box('settings').put('enableBossFights', true);
  }
  refreshThemeGlobal();
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({Key? key}) : super(key: key);

  static void restartApp(BuildContext context) {
    pageIndex = 0;
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return KeyedSubtree(
      key: key,
      child: MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatefulWidget {
  const MyMaterialApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshThemeGlobal = refreshTheme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WizardStafMeister',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: getTheme(),
      home: const MyStartPage(title: 'Klokjes Counter'),
    );
  }

  ThemeMode themeMode = ThemeMode.dark;
  refreshTheme() {
    setState(() {
      themeMode = Hive.box('settings').get('darkMode')
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  getTheme() {
    return themeMode;
  }
}
