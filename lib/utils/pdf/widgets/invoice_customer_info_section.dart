import 'package:pdf/widgets.dart' as pw;
import '../../../models/pdf/customer_info_model.dart';

class InvoiceCustomerInfoSection extends pw.StatelessWidget {
  final CustomerInfoModel customerInfoModel;

  InvoiceCustomerInfoSection({required this.customerInfoModel});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text('Name: ${customerInfoModel.name}'),
        pw.Text('Contact: ${customerInfoModel.customerContact}')
      ]),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text('Loyalty Points: ${customerInfoModel.loyaltyPoints}')
      ]),
    ]);
  }
}
