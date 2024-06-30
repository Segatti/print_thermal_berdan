import 'dart:async';

import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.separated(
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
            var p = await printer.sendToPrinter(order);
            print(p);
            showMessage("Foi enviado!");
          } else {
            showMessage("Escolha uma impressora");
          }
        },
        tooltip: 'Send data',
        child: const Icon(Icons.send),
      ),
    );
  }
}
