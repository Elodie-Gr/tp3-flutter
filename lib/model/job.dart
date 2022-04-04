import 'package:hive/hive.dart';

part 'proposition.c.dart';

// Class Proposition

@HiveType(typeId: 0)
class Proposition extends HiveObject {
  @HiveField(0)
  late String entreprise;

  @HiveField(1)
  late double salaireBrut;

  @HiveField(2)
  late double salaireNet;

  @HiveField(3)
  late String statutPropose;

  @HiveField(4)
  late String monSentiment;


}
