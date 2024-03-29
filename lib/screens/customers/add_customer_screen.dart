import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/form_widgets.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  AddCustomerScreenState createState() => AddCustomerScreenState();
}

class AddCustomerScreenState extends State<AddCustomerScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController dobController =
      TextEditingController(); // For date of birth
  final TextEditingController loyaltyPointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SkeletonScreen(
        appBarTitle: 'Add Customer',
        bottomBarButtons: _buildBottomBarButtons(context),
        bodyContent: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: _buildFormBody(),
          ),
        ));
  }

  Widget _buildFormBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildTextField(nameController, 'Name', Icons.person, true),
        buildTextField(emailController, 'Email', Icons.email, true),
        buildTextField(contactController, 'Contact', Icons.phone, true),
        buildTextField(dobController, 'Date of Birth', Icons.cake, false),
        buildTextField(
            loyaltyPointsController, 'Loyalty Points', Icons.star, false),
      ],
    );
  }

  List<Widget> _buildBottomBarButtons(BuildContext context) {
    return [
      PrimaryButton(
        buttonTitle: 'Save Customer',
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            await addCustomer(
              nameController.text,
              emailController.text,
              contactController.text,
              dobController.text,
              int.tryParse(loyaltyPointsController.text) ?? 0,
            );
          }
        },
      ),
    ];
  }

  Future<void> addCustomer(String name, String email, String contact,
      String dob, int loyaltyPoints) async {
    final customersRef = FirebaseFirestore.instance.collection('customers');
    await customersRef.add({
      'name': name,
      'email': email,
      'contact': contact,
      'dateOfBirth': dob,
      'loyaltyPoints': loyaltyPoints,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
