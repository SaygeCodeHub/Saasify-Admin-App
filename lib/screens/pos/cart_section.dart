import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/pos_bloc.dart';
import 'package:saasify/bloc/pos/pos_states.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/pos/add_to_cart_section.dart';
import 'package:saasify/screens/pos/cart_billing_section.dart';
import 'package:saasify/screens/pos/clear_cart_label.dart';
import 'package:saasify/screens/pos/settle_bill_section.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/utils/progress_bar.dart';

import '../../configs/app_colors.dart';
import '../../configs/app_spacing.dart';
import '../widgets/label_and_textfield_widget.dart';

class CartSection extends StatelessWidget {
  const CartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PosBloc, PosState>(listener: (context, state) {
      if (state is PlacingOrder) {
        ProgressBar.show(context);
      } else if (state is OrderPlaced) {
        ProgressBar.dismiss(context);
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return CustomDialogs().showSuccessDialog(
                  context, state.successMessage, onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              });
            });
      } else if (state is OrderNotPlaced) {
        ProgressBar.dismiss(context);
        showDialog(
            context: context,
            builder: (context) {
              return CustomDialogs().showAlertDialog(
                  context, state.errorMessage,
                  onPressed: () => Navigator.pop(context));
            });
      }
    }, builder: (context, state) {
      if (state is PosDataFetched) {
        if (context.read<PosBloc>().showCart) {
          return Padding(
              padding: const EdgeInsets.all(spacingSmall),
              child: Column(children: [
                const LabelAndTextFieldWidget(
                  label: 'Customer Number',
                ),
                const SizedBox(height: spacingSmall),
                ClearCartLabel(posDataList: state.posDataList),
                AddToCartSection(posDataList: state.posDataList),
                CartBillingSection(posDataList: state.posDataList),
                const SizedBox(height: spacingSmall),
                const DottedLine(dashColor: AppColors.darkGrey),
                const SizedBox(height: spacingSmall),
                SettleBillSection(posDataList: state.posDataList)
              ]));
        } else {
          return const SizedBox.shrink();
        }
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
