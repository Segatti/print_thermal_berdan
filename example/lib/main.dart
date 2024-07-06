import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:print_thermal_berdan/print_thermal_berdan.dart';

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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final String response =
                await rootBundle.loadString('lib/data.json');
            final data = await json.decode(response);
            if (printerSelected != null) {
              // var order = const OrderReceipt(
              //   company: DataCompany(
              //     address: "São Paulo",
              //     cnpj: "123456789",
              //     name: "Berdan",
              //     phone: "999999999",
              //   ),
              //   customer: DataCustomer(
              //     address: "Cuiabá, Mato Grosso",
              //     instructions:
              //         "Ao chegar, por favor ligar no interfone o numero X",
              //     name: "Vittor",
              //     phone: "9999999999",
              //   ),
              //   itemsOrder: DataItemsOrder(
              //     cartList: [
              //       DataItem(
              //         name: "Hamburguer",
              //         price: 30,
              //         quantity: 2,
              //         adicionais: [
              //           DataItemAdicional(
              //             adicional: "Bacon",
              //             price: 5,
              //             quantity: 2,
              //           ),
              //           DataItemAdicional(
              //             adicional: "Carne",
              //             price: 10,
              //             quantity: 1,
              //           ),
              //         ],
              //         opcionais: [
              //           DataItemOpcional(
              //             opcional: "Batata Frita",
              //             price: 20,
              //           ),
              //           DataItemOpcional(
              //             opcional: "Doce",
              //             price: 15,
              //           ),
              //         ],
              //       ),
              //       DataItem(
              //         name: "Coca cola 2L",
              //         price: 15,
              //         quantity: 1,
              //       ),
              //     ],
              //   ),
              //   order: DataOrder(
              //     deliveryType: "Berdan",
              //     orderCode: "4004",
              //     origin: "berdan",
              //   ),
              //   valuesOrder: DataValuesOrder(
              //     deliveryFee: 10,
              //     discount: 5,
              //     paymentMethod: "Cartão Débito",
              //     priceTotal: 105,
              //     subtotal: 100,
              //     isPaid: true,
              //   ),
              // );
              var orderJson = OrderReceipt.fromMap(data[2]);
              await printer.sendToPrinter(
                orderJson,
                imageAsset: "assets/logo.webp",
              );
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
