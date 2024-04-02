import 'package:pdf/widgets.dart' as pw;
import 'package:saasify/configs/app_spacing.dart';

class InvoiceItemsListSection extends pw.StatelessWidget {
  List<Map<String, dynamic>> items;
  InvoiceItemsListSection({required this.items});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(children: [
      pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(children: [pw.Text('Item')]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [pw.Text('Qty')],
                  ),
                  pw.SizedBox(width: spacingXXXLarge),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [pw.Text('Price')],
                  ),
                  pw.SizedBox(width: spacingXXXLarge),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [pw.Text('Amount')],
                  )
                ])
          ]),
      pw.Divider(indent: 1, endIndent: 1, thickness: 0.75),
    ]);
  }
}
