import 'package:hive/hive.dart';
import 'package:tp3/model/job.dart';

class Boxes {
  static Box<Proposition> getProposition() =>
      Hive.box<Proposition>('Proposition');
}
