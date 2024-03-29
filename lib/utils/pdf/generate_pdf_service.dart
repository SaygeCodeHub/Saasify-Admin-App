import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/models/pdf/billing_details_info_model.dart';
import 'package:saasify/models/pdf/business_info_model.dart';
import 'package:saasify/models/pdf/customer_info_model.dart';
import 'package:saasify/utils/pdf/widgets/invoice_billing_info_section.dart';
import 'package:saasify/utils/pdf/widgets/invoice_customer_info_section.dart';
import 'package:saasify/utils/pdf/widgets/invoice_header_section.dart';

Future<void> generatePdf({
  required BusinessInfoModel businessInfoModel,
  required CustomerInfoModel customerInfoModel,
  required BillingInfoModel billingInfoModel,
  required List<Map<String, dynamic>> items,
  required int totalQty,
  required double subtotal,
  required double grandTotal,
}) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            InvoiceHeaderSection(businessInfoModel: businessInfoModel),
            pw.Divider(),
            InvoiceCustomerInfoSection(customerInfoModel: customerInfoModel),
            pw.Divider(),
            InvoiceBillingInfoSection(billingInfoModel: billingInfoModel),
            pw.Divider(),
            _buildItemTable(items),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Qty: $totalQty'),
                pw.Text('Subtotal: $subtotal'),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Grand Total: $grandTotal'),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.Text('FSSAI Lic No.:${businessInfoModel.licenceNumber}'),
            pw.SizedBox(height: spacingSmallest),
            pw.Text('Thank You!'),
          ],
        );
      },
    ),
  );

  // Save the document
  await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
}

pw.Widget _buildItemTable(List<Map<String, dynamic>> items) {
  return pw.Table(
    border: pw.TableBorder.all(),
    children: items
        .map(
          (item) => pw.TableRow(
            children: [
              pw.Text(item['name']),
              pw.Text('${item['qty']}'),
              pw.Text('${item['price']}'),
              pw.Text('${item['amount']}'),
            ],
          ),
        )
        .toList(),
  );
}
