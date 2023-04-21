import 'package:flutter/material.dart';
import 'package:pdf_example_1/model/customer.dart';
import 'package:pdf_example_1/model/invoice.dart';
import 'package:pdf_example_1/model/supplier.dart';

import 'api/pdf_api.dart';
import 'api/pdf_invoice_api.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.picture_as_pdf_rounded,
                size: 100,
              ),
              const SizedBox(height: 30),
              const Text(
                'Generate Invoice',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 30),
              MaterialButton(
                minWidth: double.infinity,
                color: Colors.orange.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
                child: const Text('Invoice PDF'),
                onPressed: () async {
                  final date = DateTime.now();
                  final dueDate = date.add(const Duration(days: 7));

                  final invoice = Invoice(
                    supplier: const Supplier(
                      name: 'Niloy Biswas',
                      address: 'Moghbazar vodro ln',
                      paymentInfo: 'https://www.google.com',
                    ),
                    info: InvoiceInfo(
                      date: date,
                      dueDate: dueDate,
                      description: 'Apple Street, California',
                      number: '88372099056',
                    ),
                    items: <InvoiceItem>[
                      InvoiceItem(
                        description: 'Coffee',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 5.99,
                      ),
                      InvoiceItem(
                        description: 'Tea',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 6.99,
                      ),
                      InvoiceItem(
                        description: 'Cookies',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 7.99,
                      ),
                      InvoiceItem(
                        description: 'iPhone',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 8.99,
                      ),
                      InvoiceItem(
                        description: 'Macbook',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 9.99,
                      ),
                      InvoiceItem(
                        description: 'Underwear',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 99.99,
                      ),
                      InvoiceItem(
                        description: 'Cookies',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 7.99,
                      ),
                      InvoiceItem(
                        description: 'iPhone',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 8.99,
                      ),
                      InvoiceItem(
                        description: 'Macbook',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 9.99,
                      ),
                      InvoiceItem(
                        description: 'Underwear',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 99.99,
                      ),
                      InvoiceItem(
                        description: 'Cookies',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 7.99,
                      ),
                      InvoiceItem(
                        description: 'iPhone',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 8.99,
                      ),
                      InvoiceItem(
                        description: 'Macbook',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 9.99,
                      ),
                      InvoiceItem(
                        description: 'Underwear',
                        date: date,
                        quantity: 3,
                        vat: 0.10,
                        unitPrice: 99.99,
                      ),
                    ],
                    customer: const Customer(
                      name: 'Amit',
                      address: '123 street',
                    ),
                  );

                  final pdfFile = await PdfInvoiceApi.generate(invoice);

                  await PdfApi.openFile(pdfFile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
