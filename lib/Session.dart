import 'package:hive/hive.dart';

import 'KlokDataPoint.dart';

part 'Session.g.dart';

@HiveType(typeId: 0)
class Session extends HiveObject {
  @HiveField(0)
  int height = 99;
  @HiveField(1)
  double canHeight = 17.5;
  @HiveField(2)
  String groupName = "Wie dit leest trekt een adt";
  @HiveField(3)
  DateTime startTime = DateTime(1990, 12, 30);
  @HiveField(4)
  List<dynamic> klokData = [];
  @HiveField(5)
  DateTime completionTime = DateTime(1990, 12, 30);

  Session();

  bool goalReached() {
    return klokData.length >= (height / canHeight).ceil();
  }

  bool goalReachedExactly() {
    return klokData.length == (height / canHeight).ceil();
  }

  bool donationReminderTime() {
    if (!Hive.box('settings').get('donationReminder')) return false;
    return klokData.length == (height / canHeight).ceil() - 3;
  }

  Duration getCompletionTime() {
    if (!goalReached()) {
      return const Duration(days: 99, hours: 99, minutes: 99);
    }

    return startTime.difference(completionTime);
  }
}

void saveSession(Session session) {
  Box sessionBox = Hive.box('session');
  //hive.box('session').put('mainSession', session);
  sessionBox.put('height', session.height);
  sessionBox.put('groupName', session.groupName);
  sessionBox.put('canHeight', session.canHeight);
  sessionBox.put('startTime', session.startTime);
  sessionBox.put('klokData', session.klokData);
  sessionBox.put('completionTime', session.completionTime);
  sessionBox.flush();
}

Session getSession() {
  //return Hive.box('session').get('mainSession');
  Session output = Session();
  Box sessionBox = Hive.box('session');
  output.height = sessionBox.get('height');
  output.groupName = sessionBox.get('groupName');
  output.canHeight = sessionBox.get('canHeight');
  output.startTime = sessionBox.get('startTime');
  output.completionTime = sessionBox.get('completionTime');
  output.klokData = sessionBox.get('klokData');
  return output;
}
