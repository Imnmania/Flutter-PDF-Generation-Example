import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf_example_1/api/pdf_api.dart';
import 'package:pdf_example_1/model/invoice.dart';
import 'package:pdf_example_1/model/supplier.dart';
import 'package:pdf_example_1/utils/utils.dart';

import '../model/customer.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        build: (context) {
          return [
            buildHeader(invoice: invoice),
            SizedBox(height: 3 * PdfPageFormat.cm),
            buildTitle(invoice: invoice),
            buildInvoice(invoice: invoice),
            Divider(),
            buildTotal(invoice: invoice),
          ];
        },
        footer: (context) => buildFooter(invoice: invoice),
      ),
    );

    return PdfApi.saveDocument(
      name: 'My_Invoice_${DateTime.now()}',
      pdf: pdf,
    );
  }

  static Widget buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(children: [
        Expanded(child: Text(title, style: titleStyle)),
        Text(value, style: unite ? style : null),
      ]),
    );
  }

  static Widget buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static Widget buildTitle({
    required Invoice invoice,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'INVOICE',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
      Text(invoice.info.description),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
    ]);
  }

  static Widget buildSupplierAddress({
    required Supplier supplier,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          supplier.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(supplier.address),
      ],
    );
  }

  static Widget buildCustomerAddress({
    required Customer customer,
  }) {
    return Column(
      children: [
        Text(
          customer.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(customer.address),
      ],
    );
  }

  static Widget buildInvoiceInfo({
    required InvoiceInfo info,
  }) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number: ',
      'Invoice Date: ',
      'Payment Terms: ',
      'Due Date: ',
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(
          title: title,
          value: value,
          width: 200,
        );
      }),
    );
  }

  static Widget buildHeader({
    required Invoice invoice,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 1 * PdfPageFormat.cm,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildSupplierAddress(supplier: invoice.supplier),
            Container(
              height: 50,
              width: 50,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: invoice.info.number,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 1 * PdfPageFormat.cm,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [],
        ),
      ],
    );
  }

  static Widget buildInvoice({
    required Invoice invoice,
  }) {
    final headers = [
      'Description',
      'Date',
      'Quantity',
      'Unit Price',
      'VAT',
      'Total',
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.description,
        Utils.formatDate(item.date),
        '${item.quantity}',
        '\$ ${item.unitPrice}',
        '${item.vat}%',
        '\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal({
    required Invoice invoice,
  }) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);

    final vatPercent = invoice.items.first.vat;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'Vat ${vatPercent * 100} %',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter({
    required Invoice invoice,
  }) {
    return Column(children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildSimpleText(title: 'Address', value: invoice.supplier.address),
      SizedBox(height: 1 * PdfPageFormat.mm),
      buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
    ]);
  }
}
