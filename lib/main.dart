import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/note.dart';
import 'models/pin.dart';
import 'pages/pin_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(PinAdapter());
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Pin>('pinBox');
  
  var pinBox = Hive.box<Pin>('pinBox');
  bool isFirstTime = pinBox.isEmpty;

  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  MyApp({required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PinPage(isFirstTime: isFirstTime),
    );
  }
}
