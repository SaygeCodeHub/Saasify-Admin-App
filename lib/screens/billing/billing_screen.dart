import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../configs/app_spacing.dart';
import '../../models/pos_model.dart';
import '../../models/category/categories_model.dart';
import '../../models/product/products.dart';
import 'cart_screen.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  late String _selectedCategory;
  late List<CategoriesModel> _categories;
  List<PosModel> cart = [];
  Map<String, dynamic> cartDetailsMap = {};
  final productsBox = Hive.box<Products>('products');
  final TextEditingController _searchController = TextEditingController();
  List<Products> filteredProducts = [];

  Map getAmountAndQuantity(cart) {
    Map map = {'cost': 0.00};
    for (var cartItem in cart) {
      map['cost'] += cartItem.cost;
    }
    return map;
  }

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = productsBox.values.toList();
      } else {
        filteredProducts = productsBox.values
            .where((product) =>
                product.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    _categories = Hive.box<CategoriesModel>('categories').values.toList();
    _selectedCategory = _categories.isNotEmpty ? _categories.first.name! : '';
    filteredProducts = productsBox.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Search'),
              onChanged: (value) {
                setState(() {
                  filterProducts(value);
                });
              },
            ),
          ),
          const SizedBox(height: spacingStandard),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: mobileBodyPadding),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.name,
                  child: Text(category.name!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
          const SizedBox(height: spacingLarger),
          Visibility(
            visible: productsBox.isNotEmpty,
            replacement: const Text('No Products!'),
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: spacingStandard, horizontal: mobileBodyPadding),
                child: ValueListenableBuilder<Box<Products>>(
                  valueListenable: productsBox.listenable(),
                  builder: (context, box, _) {
                    final filteredProducts = box.values.where((product) {
                      return product.categoryId == _selectedCategory;
                    }).toList();
                    return GridView.extent(
                      maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: spacingSmall,
                      mainAxisSpacing: spacingSmall,
                      shrinkWrap: true,
                      children: List.generate(filteredProducts.length, (index) {
                        return InkWell(
                          onTap: () {},
                          child: const Card(
                            child: Padding(
                              padding: EdgeInsets.all(spacingSmall),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Widget contents here
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          ),
          const Divider(height: 0),
          Visibility(
            visible: cart.isNotEmpty,
            child: Container(
              padding: const EdgeInsets.all(spacingSmallest),
              child: Row(
                children: [
                  Text('Total: ${getAmountAndQuantity(cart)['cost'] ?? 0.00}'),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen(cart: cart)));
                      },
                      child: const Text('Settle Bill'))
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
