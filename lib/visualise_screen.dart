import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:saasify/models/supplier/add_supplier_model.dart';

import 'enums/hive_boxes_enum.dart';
import 'models/category/categories_model.dart';
import 'models/couponsAndDiscounts/coupons_and_discounts.dart';
import 'models/customer/add_customer_model.dart';
import 'models/product/products.dart';
import 'models/user/user_details.dart';

class HiveDataScreen extends StatefulWidget {
  @override
  _HiveDataScreenState createState() => _HiveDataScreenState();
}

class _HiveDataScreenState extends State<HiveDataScreen> {
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
      'products': Hive.box<Products>(HiveBoxes.products.boxName),
      'cartData': Hive.box<Map<String, dynamic>>('cartData'),
      'customers': Hive.box<AddCustomerModel>(HiveBoxes.customers.boxName),
      'suppliers': Hive.box<AddSupplierModel>(HiveBoxes.suppliers.boxName),
      'coupons': Hive.box<CouponsAndDiscountsModel>(HiveBoxes.coupons.boxName),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Data Viewer'),
        backgroundColor: Colors.deepPurple,  // Enhanced UI feature
      ),
      body: ListView.builder(  // Changed to ListView.builder for better performance
        itemCount: boxes.length,
        itemBuilder: (context, index) {
          String boxName = boxes.keys.elementAt(index);
          var box = boxes.values.elementAt(index);
          return Card(  // Using Card for better UI presentation
            child: ExpansionTile(
              initiallyExpanded: index == 0, // Automatically expand the first item
              title: Text('Box: $boxName', style: TextStyle(fontWeight: FontWeight.bold)),
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // to handle scrolling properly
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    var key = box.keys.elementAt(index);
                    var value = box.get(key);
                    return ListTile(
                      title: Text(key.toString(),style: TextStyle(color: Colors.pink),),
                      subtitle: Text(value.toString(), maxLines: 20, overflow: TextOverflow.ellipsis),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(  // Using FAB for clear action
        onPressed: () async {
          try {
            var categoriesBox = Hive.box<CategoriesModel>(HiveBoxes.categories.boxName);
            await categoriesBox.clear();
          } catch (e) {
            print('An error occurred while clearing Hive boxes: $e');
          }

        },
        child: Icon(Icons.delete_forever),
        tooltip: 'Clear All Data',
        backgroundColor: Colors.red,  // Red color to indicate a potentially destructive action
      ),
    );
  }
}
