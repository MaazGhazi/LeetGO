import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 0)
class Message {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime timestamp;

  Message({required this.id, required this.content, required this.timestamp});
}
