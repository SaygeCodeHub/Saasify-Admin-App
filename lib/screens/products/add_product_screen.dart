import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/bloc/imagePicker/image_picker_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/models/product/products.dart';
import 'package:saasify/screens/category/add_category_screen.dart';
import 'package:saasify/screens/products/add_product_section.dart';
import 'package:saasify/screens/products/product_detail.dart';
import 'package:saasify/screens/widgets/buttons/primary_button.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/utils/error_display.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/utils/progress_bar.dart';
import 'package:saasify/utils/retrieve_image_from_firebase.dart';
import '../../bloc/product/product_event.dart';
import '../../models/category/product_categories.dart';
import '../widgets/skeleton_screen.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  static List<ProductCategories> categories = [];
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _minStockLevelController =
      TextEditingController();

  static String image = '';

  getImage() async {
    image = await RetrieveImageFromFirebase().getImage(AddProductSection.image);
  }

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(FetchCategories());
    context.read<ImagePickerBloc>().imagePath = '';
    return SkeletonScreen(
        appBarTitle: 'Add Product',
        bodyContent: Form(
          key: formKey,
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is FetchingCategories) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoriesFetched) {
                categories = state.categories;
                return SingleChildScrollView(
                    child: _buildForm(context, state.imagePath));
              } else if (state is CategoriesNotFetched) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.sizeOf(context).width * 0.2),
                    child: Center(
                      child: ErrorDisplay(
                        text: state.errorMessage,
                        buttonText: 'Add Category',
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddCategoryScreen()));
                        },
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        bottomBarButtons: [
          BlocListener<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is AddingProduct) {
                  ProgressBar.show(context);
                } else if (state is ProductAdded) {
                  ProgressBar.dismiss(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialogs().showSuccessDialog(
                            context, state.successMessage, onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      });
                } else if (state is ProductNotAdded) {
                  ProgressBar.dismiss(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialogs().showSuccessDialog(
                            context, state.errorMessage,
                            onPressed: () => Navigator.pop(context));
                      });
                }
              },
              child: PrimaryButton(
                buttonTitle: 'Add Product',
                onPressed: () async {
                  if (kIsOfflineModule) {
                    if (context
                        .read<CategoryBloc>()
                        .selectedCategory
                        .isNotEmpty) {
                      final product = Products(
                        productId: '0',
                        name: _nameController.text,
                        category: context.read<CategoryBloc>().selectedCategory,
                        description: _descriptionController.text,
                        imageUrl: '',
                        supplier: _supplierController.text,
                        tax: double.tryParse(_taxController.text) ?? 0,
                        minStockLevel:
                            int.tryParse(_minStockLevelController.text) ?? 0,
                        dateAdded: DateTime.now(),
                        isActive: true,
                        variants: [],
                      );
                      final productsBox = Hive.box<Products>('products');
                      productsBox.add(product);
                      if (productsBox.isNotEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialogs().showSuccessDialog(
                                  context, 'Product added successfully',
                                  onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialogs().showSuccessDialog(
                                  context, 'Failed to add product.',
                                  onPressed: () => Navigator.pop(context));
                            });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Select a category!')));
                    }
                  } else {
                    if (formKey.currentState!.validate()) {
                      if (context
                          .read<CategoryBloc>()
                          .selectedCategory
                          .isNotEmpty) {
                        getImage();
                        context.read<ProductBloc>().add(AddProduct(
                            product: Products(
                              productId: '0',
                              name: _nameController.text,
                              category:
                                  context.read<CategoryBloc>().selectedCategory,
                              description: _descriptionController.text,
                              imageUrl: image,
                              supplier: _supplierController.text,
                              tax: double.tryParse(_taxController.text) ?? 0,
                              minStockLevel:
                                  int.tryParse(_minStockLevelController.text) ??
                                      0,
                              dateAdded: DateTime.now(),
                              isActive: true,
                              variants: [],
                            ),
                            categories: categories));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Select a category!')));
                      }
                    }
                  }
                },
              ))
        ]);
  }

  Widget _buildForm(BuildContext context, String imagePath) {
    return AddProductSection(
        categories: categories,
        nameController: _nameController,
        descriptionController: _descriptionController,
        supplierController: _supplierController,
        taxController: _taxController,
        minStockLevelController: _minStockLevelController);
  }
}
