import 'package:pdf/widgets.dart' as pw;
import '../../../models/pdf/business_info_model.dart';

class InvoiceHeaderSection extends pw.StatelessWidget {
  final BusinessInfoModel businessInfoModel;

  InvoiceHeaderSection({required this.businessInfoModel});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(children: [
      pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [pw.Text('GST / EIN - ${businessInfoModel.gst}')]),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
        pw.Text('Restaurant Contact - ${businessInfoModel.companyContact}')
      ]),
      pw.Text('Address - ${businessInfoModel.companyAddress}'),
    ]);
  }
}
