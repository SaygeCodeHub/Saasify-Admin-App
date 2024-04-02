import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/models/pdf/billing_details_info_model.dart';
import 'package:saasify/models/pdf/business_info_model.dart';
import 'package:saasify/models/pdf/customer_info_model.dart';
import 'package:saasify/utils/pdf/widgets/inovice_items_list_section.dart';
import 'package:saasify/utils/pdf/widgets/invoice_amount_calculation_section.dart';
import 'package:saasify/utils/pdf/widgets/invoice_billing_info_section.dart';
import 'package:saasify/utils/pdf/widgets/invoice_customer_info_section.dart';
import 'package:saasify/utils/pdf/widgets/invoice_header_section.dart';

Future<void> generatePdf({
  required BusinessInfoModel businessInfoModel,
  required CustomerInfoModel customerInfoModel,
  required BillingInfoModel billingInfoModel,
  required List<Map<String, dynamic>> items,
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
            InvoiceItemsListSection(items: items),
            pw.Divider(),
            InvoiceAmountCalculationSection(billingInfoModel: billingInfoModel),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.Text('Licence Number: ${businessInfoModel.licenceNumber}'),
            pw.SizedBox(height: spacingSmallest),
            pw.Text('Thank You!'),
          ],
        );
      },
    ),
  );
  await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
}
