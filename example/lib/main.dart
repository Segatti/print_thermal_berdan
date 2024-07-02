import 'dart:async';

import 'package:elgin/elgin.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:print_thermal_berdan/print_thermal_berdan.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final printer = PrintThermalPresenter(PrinterType.network);
  List<PrinterDevice> devices = [];
  late StreamSubscription<PrinterDevice> streamDevices;
  PrinterDevice? printerSelected;
  final ipPrinter = TextEditingController();

  void connectElgin() async {
    final driver = ElginPrinter(
      type: ElginPrinterType.TCP,
      model: ElginPrinterModel.MP4200,
      connection: ipPrinter.text,
      parameter: 9100,
    );

    try {
      final int? result = await Elgin.printer
          .connect(driver: driver)
          .timeout(const Duration(seconds: 5))
          .catchError((_) {
        return null;
      });
      print("-------------------------------------------------- $result");
      if (result != null) {
        if (result == 0) {
          await Elgin.printer.printString('HELLO PRINTER');
          await Elgin.printer.feed(2);
          await Elgin.printer.cut(lines: 2);
          await Elgin.printer.disconnect();
        }
      }
    } on ElginException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.error.message)));
    }
  }

  void showMessage(String text) {
    var snack = SnackBar(
      content: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  @override
  void initState() {
    super.initState();
    streamDevices = printer.getDevices().listen((device) {
      setState(() {
        devices.add(device);
      });
    });
  }

  @override
  void dispose() {
    streamDevices.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: devices.length,
                separatorBuilder: (_, __) => const Divider(
                  color: Colors.white,
                  height: 1,
                ),
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    if (printerSelected == devices[index]) {
                      await printer.disconnectDevice();
                      setState(() {
                        printerSelected = null;
                      });
                    } else {
                      if (printerSelected != null) {
                        await printer.disconnectDevice();
                      }
                      await printer.connectDevice(devices[index]).then((value) {
                        if (value) {
                          setState(() {
                            printerSelected = devices[index];
                          });
                        } else {
                          showMessage("Falha ao tentar se conectar");
                        }
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    color: (printerSelected == devices[index])
                        ? Colors.amber
                        : Colors.grey,
                    child: Center(
                      child: Text(devices[index].name.toString()),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
                  final pdf = pw.Document();

                  pdf.addPage(
                    pw.Page(
                      pageFormat: PdfPageFormat.roll80,
                      build: (context) {
                        return pw.Center(
                          child: pw.SizedBox(
                            width: 80 * PdfPageFormat.mm,
                            height: 300 * PdfPageFormat.mm,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Text(
                                  'Nota Fiscal',
                                  style: pw.TextStyle(
                                      fontSize: 24,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(height: 10),
                                pw.Text('Data: ${DateTime.now()}'),
                                pw.SizedBox(height: 10),
                                pw.Text('Cliente: João da Silva'),
                                pw.Text('Endereço: Rua das Flores, 123'),
                                pw.SizedBox(height: 10),
                                pw.Table.fromTextArray(
                                  headers: ['Item', 'Qtd', 'Preço', 'Total'],
                                  data: [
                                    [
                                      'Produto 1',
                                      '2',
                                      'R\$ 10,00',
                                      'R\$ 20,00'
                                    ],
                                    [
                                      'Produto 2',
                                      '1',
                                      'R\$ 15,00',
                                      'R\$ 15,00'
                                    ],
                                  ],
                                ),
                                pw.SizedBox(height: 10),
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text('Subtotal:'),
                                    pw.Text('R\$ 35,00'),
                                  ],
                                ),
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text('Desconto:'),
                                    pw.Text('R\$ 5,00'),
                                  ],
                                ),
                                pw.Divider(),
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text(
                                      'Total:',
                                      style: pw.TextStyle(
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                    pw.Text(
                                      'R\$ 30,00',
                                      style: pw.TextStyle(
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  ],
                                ),
                                pw.SizedBox(height: 20),
                                pw.Text(
                                  'Obrigado pela preferência!',
                                  textAlign: pw.TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );

                  return pdf.save();
                });
              },
              child: const Text("Tentar como PDF"),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: ipPrinter,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Ex: 10.0.0.102",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                connectElgin();
              },
              child: const Text("Tentar com ElginLib"),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (printerSelected != null) {
              var order = const OrderReceipt(
                company: DataCompany(
                  address: "address",
                  cnpj: "cnpj",
                  name: "name",
                  phone: "phone",
                ),
                customer: DataCustomer(
                  address: "address",
                  instructions: "instructions",
                  name: "name",
                  phone: "phone",
                ),
                itemsOrder: DataItemsOrder(
                  cartList: [
                    DataItem(
                      name: "name",
                      price: 20,
                      quantity: 2,
                      adicionais: [
                        DataItemAdicional(
                          adicional: "adicional",
                          price: 20,
                          quantity: 1,
                        ),
                      ],
                      opcionais: [
                        DataItemOpcional(
                          opcional: "opcional",
                          price: 2,
                        ),
                      ],
                    ),
                  ],
                ),
                order: DataOrder(
                  deliveryType: "deliveryType",
                  orderCode: "orderCode",
                  origin: "origin",
                ),
                valuesOrder: DataValuesOrder(
                  deliveryFee: 10,
                  discount: 5,
                  paymentForm: "Cartão Débito",
                  priceTotal: 105,
                  subtotal: 100,
                ),
              );
              await printer.sendToPrinter(order);
              showMessage("Foi enviado!");
            } else {
              showMessage("Escolha uma impressora");
            }
          },
          tooltip: 'Send data',
          child: const Icon(Icons.send),
        ),
      ),
    );
  }
}
