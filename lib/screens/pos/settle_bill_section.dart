import 'package:flutter/material.dart';
import 'package:saasify/cache/company_cache.dart';
import 'package:saasify/cache/user_cache.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/models/pdf/billing_details_info_model.dart';
import 'package:saasify/models/pdf/business_info_model.dart';
import 'package:saasify/models/pdf/customer_info_model.dart';
import 'package:saasify/models/pos_model.dart';
import 'package:saasify/screens/billing/select_payment_method.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/pdf/generate_pdf_service.dart';

class SettleBillSection extends StatelessWidget {
  final List<PosModel> posDataList;
  final BillDetails billDetails = getIt<BillDetails>();

  SettleBillSection({super.key, required this.posDataList});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                onPressed: () async {
                  generatePdf(
                      businessInfoModel: BusinessInfoModel(
                          await CompanyCache.getUserContact() ?? '',
                          await CompanyCache.getCompanyLicenseNo() ?? '',
                          await CompanyCache.getCompanyGstNo() ?? '',
                          await CompanyCache.getUserAddress() ?? ''),
                      customerInfoModel: CustomerInfoModel(
                          name: await UserCache.getUsername() ?? '',
                          customerContact:
                              await CompanyCache.getUserContact() ?? '',
                          customerAddress:
                              await CompanyCache.getUserAddress() ?? '',
                          loyaltyPoints: '0'),
                      billingInfoModel: BillingInfoModel(
                          await UserCache.getUsername() ?? '',
                          DateTime.now().toString(),
                          '1766',
                          billDetails.selectedPaymentMethod,
                          23,
                          billDetails.subTotal,
                          billDetails.discount ?? 0,
                          billDetails.taxPercentage ?? 0,
                          billDetails.taxPercentage ?? 0,
                          billDetails.grandTotal),
                      items: posDataList);
                },
                child: const Text('Print KOT'))),
        const SizedBox(width: spacingSmall),
        Expanded(
            child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SelectPaymentMethod(
                            totalAmount: billDetails.grandTotal!,
                            posDataList: posDataList);
                      });
                },
                child: const Text('Settle Bill'))),
      ],
    );
  }
}
