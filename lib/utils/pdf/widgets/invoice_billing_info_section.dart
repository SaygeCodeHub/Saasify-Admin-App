import 'package:pdf/widgets.dart' as pw;
import 'package:saasify/models/pdf/billing_details_info_model.dart';

class InvoiceBillingInfoSection extends pw.StatelessWidget {
  final BillingInfoModel billingInfoModel;

  InvoiceBillingInfoSection({required this.billingInfoModel});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text('Date: ${billingInfoModel.dateAndTime}'),
        pw.Text('Contact: ${billingInfoModel.billNumber}')
      ]),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text('Cashier: ${billingInfoModel.cashierName}'),
        pw.Text('Payment Type: ${billingInfoModel.paymentType}')
      ]),
    ]);
  }
}
