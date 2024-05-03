// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:aron_invoice/invoice.dart';

Future<void> generateInvoice(Invoice invoice) async {
  final font = await PdfGoogleFonts.robotoRegular();
  final fontBold = await PdfGoogleFonts.robotoBold();

  final textStyle = pw.TextStyle(font: font);
  final boldTextStyle = pw.TextStyle(font: fontBold);

  text(String text, {bool bold = false}) {
    return pw.Text(text, style: bold ? boldTextStyle : textStyle);
  }

  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          mainAxisSize: pw.MainAxisSize.max,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 60,
                      child: text('Faktura ${invoice.invoiceNumber}', bold: true),
                    ),
                    pw.Expanded(
                      flex: 40,
                      child: pw.Column(
                        children: [
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              text('Data sprzedaży:'),
                              text(invoice.saleDate, bold: true),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              text('Data wystawienia:'),
                              text(invoice.issueDate, bold: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 50.0),
                text('Sprzedawca', bold: true),
                pw.SizedBox(height: 8.0),
                text(invoice.seller),
                pw.SizedBox(height: 20.0),
                text('Nabywca', bold: true),
                pw.SizedBox(height: 8.0),
                text(invoice.buyer),
                pw.SizedBox(height: 50.0),
                pw.TableHelper.fromTextArray(
                  context: context,
                  cellStyle: textStyle,
                  headerStyle: boldTextStyle,
                  cellAlignment: pw.Alignment.topCenter,
                  headerAlignment: pw.Alignment.topCenter,
                  data: <List<String>>[
                    <String>[
                      'Opis',
                      'Kwota netto',
                      'Stawka VAT',
                      'Kwota VAT',
                      'Kwota brutto',
                    ],
                    ...invoice.productList.map(
                      (product) => <String>[
                        product.description,
                        '${product.netPrice.toStringAsFixed(2)} ${product.currency}',
                        '${product.vatRate}%',
                        '${product.vatPrice.toStringAsFixed(2)} ${product.currency}',
                        '${product.grossPrice.toStringAsFixed(2)} ${product.currency}'
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 50.0),
                text('Uwagi:', bold: true),
                text(invoice.additionalDescription),
              ],
            ),
            text('Wygenerowano przez aroninvoice.web.app'),
          ],
        );
      },
    ),
  );

  var savedFile = await pdf.save();

  List<int> fileInts = List.from(savedFile);

  String filename = "${DateTime.now().millisecondsSinceEpoch}.pdf";

  AnchorElement(href: "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
    ..setAttribute("download", filename)
    ..click();
}
