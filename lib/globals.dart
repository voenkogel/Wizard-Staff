import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kutten_met_flutter/KlokDataPoint.dart';
import 'package:kutten_met_flutter/Session.dart';
import 'package:kutten_met_flutter/main.dart';

MaterialColor myKlokGroen = const MaterialColor(0xFF01a87b, {
  50: Color.fromRGBO(1, 168, 125, .1),
  100: Color.fromRGBO(1, 168, 125, .2),
  200: Color.fromRGBO(1, 168, 125, .3),
  300: Color.fromRGBO(1, 168, 125, .4),
  400: Color.fromRGBO(1, 168, 125, .5),
  500: Color.fromRGBO(1, 168, 125, .6),
  600: Color.fromRGBO(1, 168, 125, .7),
  700: Color.fromRGBO(1, 168, 125, .8),
  800: Color.fromRGBO(1, 168, 125, .9),
  900: Color.fromRGBO(1, 168, 125, 1),
});

final formKey = GlobalKey<FormState>();
Function refreshThemeGlobal = () {};

ThemeData darkTheme = ThemeData(
  primarySwatch: myKlokGroen,
  scaffoldBackgroundColor: const Color(0xFF1c1c1c),
  cardColor: const Color(0xFF333333),
);

ThemeData lightTheme = ThemeData(
    primarySwatch: myKlokGroen,
    scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 245, 1),
    cardColor: Colors.white);

Widget slideTransition(context, animation, secondaryAnimation, child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  final tween = Tween(begin: begin, end: end);
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

/// Returns a formatted string for the given Duration [d] to be DD:HH:mm:ss
/// and ignore if 0.
String formatDuration(Duration d) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (days != 0) {
    tokens.add('${days}d');
  }
  if (tokens.isNotEmpty || hours != 0) {
    tokens.add('${hours}h');
  }
  if (tokens.isNotEmpty || minutes != 0) {
    tokens.add('${minutes}m');
  }
  tokens.add('${seconds}s');
  String output = tokens.join();
  output = output.replaceAll('-', '');
  return output;
}

//
List<BlikConfig> blikjes = [
  BlikConfig('33CL Cans', 11.5),
  BlikConfig('50CL Cans', 17.5)
];

String canHeightToDisplayName(double height) {
  for (int i = 0; i < blikjes.length; i++) {
    if (blikjes[i].canHeight == height) return blikjes[i].displayName;
  }
  return 'error';
}

double displayNameToCanHeight(String name) {
  for (int i = 0; i < blikjes.length; i++) {
    if (blikjes[i].displayName == name) return blikjes[i].canHeight;
  }
  return 0.0;
}

class BlikConfig {
  late String displayName;
  late double canHeight;

  BlikConfig(this.displayName, this.canHeight);
}

final List<Rule> items = [
  Rule('Dueling Wizards',
      'Duels. Once you achieve level 10, you can challenge any other wizard above level 10 to a Staff Duel. The duel ends when someone’s staff breaks, and that wizard’s punishment is to drop to the level of his longest staff piece… and the shame of having a poor quality staff in front of the entire Council. Commanding Voice. Any wizard over level 10 can command another wizard under level 3 to do his bidding. Once you reach level 3 you are immune to the Commanding Voice spell. Broken Staff. If your staff breaks due to your incompetence, i.e. poor taping or dropping it, you are reduced to the level of the longest piece.'),
  Rule('The Die of Fate',
      'You will need a D20 and a larger assortment of liquors. Assign each liquor a number. When a person battles a “boss”, they roll the die of fate and drink whatever number challenge they rolled.')
];

class Rule {
  String name;
  String content;

  Rule(this.name, this.content);
}
