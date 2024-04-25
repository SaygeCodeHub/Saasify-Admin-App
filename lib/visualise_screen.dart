import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saasify/models/supplier/add_supplier_model.dart';
import 'package:saasify/utils/progress_bar.dart';

import 'configs/hive_setup.dart';
import 'enums/hive_boxes_enum.dart';
import 'models/category/categories_model.dart';
import 'models/couponsAndDiscounts/coupons_and_discounts.dart';
import 'models/customer/add_customer_model.dart';
import 'models/product/product_model.dart';
import 'models/user/user_details.dart';

class HiveDataScreen extends StatefulWidget {
  const HiveDataScreen({super.key});

  @override
  HiveDataScreenState createState() => HiveDataScreenState();
}

class HiveDataScreenState extends State<HiveDataScreen> {
  Future<void> clearAllData() async {
    for (var boxName in [
      'userDetails',
      HiveBoxes.categories.boxName,
      HiveBoxes.products.boxName,
      'cartData',
      HiveBoxes.customers.boxName,
      HiveBoxes.suppliers.boxName,
      HiveBoxes.coupons.boxName,
    ]) {
      await Hive.box(boxName).clear();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final boxes = {
      'userDetails': Hive.box<UserDetails>('userDetails'),
      'categories': Hive.box<CategoriesModel>(HiveBoxes.categories.boxName),
      'products': Hive.box<ProductsModel>(HiveBoxes.products.boxName),
      'cartData': Hive.box<Map<String, dynamic>>('cartData'),
      'customers': Hive.box<AddCustomerModel>(HiveBoxes.customers.boxName),
      'suppliers': Hive.box<AddSupplierModel>(HiveBoxes.suppliers.boxName),
      'coupons': Hive.box<CouponsAndDiscountsModel>(HiveBoxes.coupons.boxName),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Hive Data Viewer')),
      body: ListView.builder(
        itemCount: boxes.length,
        itemBuilder: (context, index) {
          String boxName = boxes.keys.elementAt(index);
          var box = boxes.values.elementAt(index);
          return Card(
            child: ExpansionTile(
              initiallyExpanded: index == 0,
              title: Text('Box: $boxName',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    var key = box.keys.elementAt(index);
                    var value = box.get(key);
                    return ListTile(
                      title: Text(
                        key.toString(),
                        style: const TextStyle(color: Colors.pink),
                      ),
                      subtitle: Text(value.toString(),
                          maxLines: 20, overflow: TextOverflow.ellipsis),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Using FAB for clear action
        onPressed: () async {
          try {} catch (e) {
            print('An error occurred while clearing Hive boxes: $e');
          }
        },
        tooltip: 'Clear All Data',
        backgroundColor: Colors.red,
        child: const Icon(Icons
            .delete_forever), // Red color to indicate a potentially destructive action
      ),
    );
  }

  Future<void> clearHiveAndReinitialize() async {
    // Show the loader
    ProgressBar.show(
        context); // Replace YourLoaderWidget with your actual loader

    try {
      // Close all open Hive boxes
      print('Closing all Hive boxes...');
      await Hive.close();

      // Get the application documents directory
      final appDocumentDir = await getApplicationDocumentsDirectory();
      final hiveDirectory = '${appDocumentDir.path}/hive';
      final hiveDir = Directory(hiveDirectory);

      // Check if the Hive directory exists
      if (hiveDir.existsSync()) {
        print('Deleting Hive directory at: $hiveDirectory');
        // Delete the Hive directory and its contents
        await hiveDir.delete(recursive: true);
        print('Hive directory deleted successfully.');
      } else {
        print('Hive directory not found at: $hiveDirectory');
      }

      // Reinitialize Hive
      print('Reinitializing Hive...');
      await Hive.initFlutter(); // If you're using Hive for Flutter
      print('Hive reinitialized successfully.');

      // Call setupHive function to reinitialize all your boxes and data
      print('Setting up Hive...');
      await setupHive();
      print('Hive setup complete.');
    } catch (e) {
      // Handle exceptions
      print('An error occurred during clearHiveAndReinitialize: $e');
    } finally {
      // Hide the loader once the operation is complete
      ProgressBar.dismiss(
          context); // Replace YourLoaderWidget with your actual loader
    }
  }
}
