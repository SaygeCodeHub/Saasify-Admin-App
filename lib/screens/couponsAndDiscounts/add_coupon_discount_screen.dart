import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saasify/bloc/couponsAndDiscounts/coupons_and_discounts_bloc.dart';
import 'package:saasify/bloc/couponsAndDiscounts/coupons_and_discounts_event.dart';
import 'package:saasify/bloc/couponsAndDiscounts/coupons_and_discounts_state.dart';
import 'package:saasify/models/couponsAndDiscounts/coupons_and_discounts.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/utils/progress_bar.dart';
import 'package:saasify/utils/responsive_form.dart';
import '../../../configs/app_spacing.dart';
import '../widgets/custom_radio_button.dart';
import '../widgets/date_picker.dart';
import '../widgets/label_and_textfield_widget.dart';
import '../widgets/skeleton_screen.dart';
import '../widgets/buttons/primary_button.dart';

class AddCouponDiscountScreen extends StatefulWidget {
  const AddCouponDiscountScreen({super.key});

  @override
  State<AddCouponDiscountScreen> createState() =>
      _AddCouponDiscountScreenState();
}

class _AddCouponDiscountScreenState extends State<AddCouponDiscountScreen> {
  final formKey = GlobalKey<FormState>();
  final couponCodeNameController = TextEditingController();
  final couponValueController = TextEditingController();
  final validityController = TextEditingController();
  final maximumAmountController = TextEditingController();
  String? _selectedOption = 'Flat Amount';

  @override
  Widget build(BuildContext context) {
    return SkeletonScreen(
      appBarTitle: 'Add Coupon / Discount',
      bodyContent: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: spacingLarge),
                ResponsiveForm(formWidgets: _buildFormWidgets())
              ],
            )),
      ),
      bottomBarButtons: _buildBottomBarButtons(),
    );
  }

  List<Widget> _buildFormWidgets() {
    return [
      LabelAndTextFieldWidget(
        prefixIcon: const Icon(Icons.discount),
        label: 'Coupon Code',
        isRequired: true,
        textFieldController: couponCodeNameController,
      ),
      CustomDatePickerWidget(
          label: 'Valid Till', dateController: validityController),
      CustomRadioButton<String>(
        label: 'Select Coupon Type',
        options: const ['Flat Amount', 'By Percentage'],
        selectedValue: _selectedOption,
        onValueChanged: (newValue) =>
            setState(() => _selectedOption = newValue),
      ),
      LabelAndTextFieldWidget(
        prefixIcon: _selectedOption == 'Flat Amount'
            ? const Icon(Icons.currency_rupee_outlined)
            : const Icon(Icons.percent),
        label: _selectedOption == 'Flat Amount' ? 'Amount' : 'Percentage',
        isRequired: true,
        textFieldController: couponValueController,
      ),
      if (_selectedOption != 'Flat Amount')
        LabelAndTextFieldWidget(
          prefixIcon: const Icon(Icons.discount),
          label: 'Maximum Amount',
          isRequired: true,
          textFieldController: maximumAmountController,
        ),
    ];
  }

  List<Widget> _buildBottomBarButtons() {
    return [
      BlocListener<CouponsAndDiscountsBloc, CouponsAndDiscountsStates>(
        listener: (context, state) {
          if (state is AddingCoupon) {
            ProgressBar.show(context);
          } else if (state is CouponAdded) {
            ProgressBar.dismiss(context);
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogs().showSuccessDialog(
                      context, 'Coupon added successfully!',
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen())));
                });
          } else if (state is CouponNotAdded) {
            ProgressBar.dismiss(context);
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogs().showAlertDialog(
                      context, state.errorMessage,
                      onPressed: () => Navigator.pop(context));
                });
          }
        },
        child: PrimaryButton(
          buttonTitle: 'Add Coupon',
          onPressed: () => _addCoupon(),
        ),
      ),
    ];
  }

  void _addCoupon() async {
    if (formKey.currentState!.validate()) {
      final couponValidityDate =
          DateFormat('dd/MM/yyyy').parseStrict(validityController.text);
      context.read<CouponsAndDiscountsBloc>().add(AddCoupon(
            addCouponMap: CouponsAndDiscountsModel(
              couponCode: couponCodeNameController.text,
              amount: double.tryParse(couponValueController.text),
              maximumAmount: double.tryParse(maximumAmountController.text),
              couponType: _selectedOption,
              validTill: couponValidityDate,
            ),
          ));
    }
  }
}
