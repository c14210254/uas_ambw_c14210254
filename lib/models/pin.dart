import 'package:hive/hive.dart';

part 'pin.g.dart';

@HiveType(typeId: 1)
class Pin extends HiveObject {
  @HiveField(0)
  String pin;

  Pin({required this.pin});
}
