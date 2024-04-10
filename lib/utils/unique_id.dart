import 'package:uuid/uuid.dart';

class IDUtil {
  static String generateUUID() {
    var uuid = const Uuid();
    return uuid.v4(); // Generates a version 4 UUID
  }
}
