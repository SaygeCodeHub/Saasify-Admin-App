import 'package:flutter/material.dart';

import '../../configs/app_colors.dart';
import '../category/add_category_screen.dart';
import '../category/view_category_screen.dart';
import '../products/add_product_screen.dart';
import '../products/view_product_screen.dart';
import 'avtar.dart';
import 'grid_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> cardColors = [
      AppColors.ghostwhite,
      AppColors.honeydew,
      AppColors.flowlwewhitw,
      AppColors.antiwhite
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0), // Add padding from the top
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi Ashish,',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1234.00',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CircularAvatarWidget(
                    labelText: 'Add New',
                    iconData: Icons.add,
                  ),
                  SizedBox(width: 8),
                  CircularAvatarWidget(
                    labelText: 'Jane Doe',
                    iconData: Icons.person,
                  ),
                  SizedBox(width: 8),
                  CircularAvatarWidget(
                    labelText: 'Alice Smith',
                    iconData: Icons.person,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0), // Add padding
              child: Text(
                'Here are some things you can do', // New text
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                padding: const EdgeInsets.all(16.0),
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: [
                  GridItem(
                    icon: Icons.category_outlined,
                    label: 'Add New Category',
                    screen: AddCategoryScreen(),
                    color: cardColors[0],
                  ),
                  GridItem(
                    icon: Icons.add_box_outlined,
                    label: 'Add New Product',
                    screen: AddProductScreen(),
                    color: cardColors[1],
                  ),
                  GridItem(
                    icon: Icons.view_list_outlined,
                    label: 'View All Categories',
                    screen: const ViewCategoryScreen(),
                    color: cardColors[2],
                  ),
                  GridItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'View All Products',
                    screen: const AllProductsScreen(),
                    color: cardColors[3],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
