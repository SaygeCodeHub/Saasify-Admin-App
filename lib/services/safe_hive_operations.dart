import 'dart:io';

import 'package:hive/hive.dart';

Future<dynamic> safeHiveOperation(
    Box box, Future<dynamic> Function(Box) operation) async {
  try {
    return await operation(box);
  } on FileSystemException catch (e) {
    throw Exception(
        'Failed to access or modify the Hive database file: ${e.message}');
  } on HiveError catch (e) {
    throw Exception('Hive database error: ${e.message}');
  } catch (e) {
    throw Exception('An unexpected error occurred: ${e.toString()}');
  }
}
