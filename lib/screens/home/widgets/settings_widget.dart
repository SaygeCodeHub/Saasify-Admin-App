import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/models/pdf/billing_details_info_model.dart';
import 'package:saasify/models/pdf/business_info_model.dart';
import 'package:saasify/models/pdf/customer_info_model.dart';
import '../../../utils/pdf/generate_pdf_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          generatePdf(
              businessInfoModel: const BusinessInfoModel(
                  '9786247171',
                  '76868751381581',
                  'G779AZ69777301',
                  'Vievkanand Nagar, Nagpur - 440015'),
              customerInfoModel: const CustomerInfoModel(
                  'Joey Tribbiani', '9786247171', '27', ''),
              billingInfoModel: BillingInfoModel(
                  'Gunther',
                  DateTime.now().toString(),
                  '1766',
                  'Cash',
                  23,
                  1000,
                  100,
                  1.80,
                  1.80,
                  903),
              items: [
                {'name': 'Jeans', 'qty': 25, 'price': 45.00, 'amount': 1125.00},
              ]);
        },
        icon: const Icon(Icons.settings, color: AppColors.darkBlue));
  }
}
