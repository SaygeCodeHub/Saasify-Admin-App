 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class BugReportUtil {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> reportBug({
    required String errorDescription,
    String? userId,
    String? screenOrFeature,
    String? actionTaken,
  }) async {
    final bugReport = {
      'timestamp': Timestamp.now(),
      'userId': userId ?? 'Anonymous',
      'errorDescription': errorDescription,
      'screenOrFeature': screenOrFeature,
      'actionTaken': actionTaken,
      'deviceInformation': 'Device info',
      'appVersion': 'App version',
    };

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await _firestore.collection('bugReports').add(bugReport);
        FirebaseCrashlytics.instance.log(errorDescription);
        await _uploadStoredLogs();
      } else {
        _storeLogLocally(bugReport);
      }
    } on SocketException catch (_) {
      _storeLogLocally(bugReport);
    } on PlatformException {
      _storeLogLocally(bugReport);
    }
  }

  static Future<void> _storeLogLocally(Map<String, dynamic> log) async {
    final file = await _localLogFile;
    List<dynamic> logs = json.decode(await file.readAsString()) ?? [];
    logs.add(log);
    await file.writeAsString(json.encode(logs));
  }

  static Future<File> get _localLogFile async {
    final path = await _localPath;
    return File('$path/errorLogs.json');
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<void> _uploadStoredLogs() async {
    final file = await _localLogFile;
    if (await file.exists()) {
      List<dynamic> logs = json.decode(await file.readAsString());
      for (var log in logs) {
        await _firestore.collection('bugReports').add(log);
        FirebaseCrashlytics.instance.log(log['errorDescription']);
      }
      await file.writeAsString(json.encode([]));
    }
  }
}
