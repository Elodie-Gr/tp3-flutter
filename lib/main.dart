import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tp3/model/job.dart';
import 'package:tp3/page/proposition_page.dart';

Future <void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(PropositionAdapter());
  await Hive.openBox<Proposition>('Proposition');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Offres d\'emploi';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.purple),
    home: PropositionPage(),
  );
}
