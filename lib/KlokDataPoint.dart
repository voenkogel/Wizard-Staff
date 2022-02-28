import 'package:hive/hive.dart';

part 'KlokDataPoint.g.dart';

@HiveType(typeId: 1)
class KlokDataPoint extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final DateTime dateTime;

  KlokDataPoint({
    required this.id,
    required this.dateTime,
  });
}
