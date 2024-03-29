import 'package:pdf/widgets.dart' as pw;
import 'package:saasify/models/pdf/billing_details_info_model.dart';

import '../../../configs/app_spacing.dart';

class InvoiceAmountCalculationSection extends pw.StatelessWidget {
  final BillingInfoModel billingInfoModel;

  InvoiceAmountCalculationSection({required this.billingInfoModel});

  @override
  pw.Widget build(pw.Context context) {
    const amountWidth = 200.0;

    return pw.Column(children: [
      _buildAmountRow('SubTotal',
          billingInfoModel.subTotalAmount!.toStringAsFixed(2), amountWidth),
      _buildAmountRow('Discount',
          billingInfoModel.discountAmount!.toStringAsFixed(2), amountWidth),
      _buildAmountRow(
          'SGST', billingInfoModel.sgstAmount!.toStringAsFixed(2), amountWidth),
      _buildAmountRow(
          'CGST', billingInfoModel.cgstAmount!.toStringAsFixed(2), amountWidth),
      pw.Divider(),
      _buildAmountRow('Round off', '00.00', amountWidth),
      _buildAmountRow('Grand Total',
          billingInfoModel.grandTotalAmount!.toStringAsFixed(2), amountWidth,
          isBold: true),
    ]);
  }

  pw.Widget _buildAmountRow(String label, String amount, double amountWidth,
      {bool isBold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Text(label,
              style: pw.TextStyle(
                fontSize: spacingSmall,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              )),
        ),
        pw.SizedBox(width: spacingXXXLarge),
        pw.Container(
          width: amountWidth,
          alignment: pw.Alignment.centerRight,
          child: pw.Text(amount,
              style: pw.TextStyle(
                fontSize: spacingSmall,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              )),
        ),
      ],
    );
  }
}
