import 'package:flutter/material.dart';

class DeviceUtils {
  static bool isMobile(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 600;  // You can adjust the threshold as needed
  }
}
