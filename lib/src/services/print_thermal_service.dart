import 'dart:io';

import 'package:print_thermal_berdan/src/interfaces/print_thermal_service.dart';
import 'package:thermal_printer/thermal_printer.dart';

import '../models/exception_print_thermal.dart';

class PrintThermalService implements IPrintThermalService {
  final _printer = PrinterManager.instance;

  @override
  Stream<PrinterDevice> scanPrinters({
    required PrinterType type,
    required bool isBle,
  }) {
    return _printer.discovery(type: type, isBle: isBle);
  }

  @override
  Future<bool> connectPrinter({
    required PrinterDevice selectedPrinter,
    required PrinterType type,
    required bool reconnect,
    required bool isBle,
    String? ipAddress,
  }) async {
    switch (type) {
      // only windows and android
      case PrinterType.usb:
        if (Platform.isAndroid || Platform.isWindows) {
          return await _printer.connect(
            type: type,
            model: UsbPrinterInput(
              name: selectedPrinter.name,
              productId: selectedPrinter.productId,
              vendorId: selectedPrinter.vendorId,
            ),
          );
        } else {
          throw ExceptionPrintThermalBerdan(
            "Conexão USB somente para Windows e Android",
          );
        }
      // only iOS and android
      case PrinterType.bluetooth:
        if (Platform.isAndroid || Platform.isIOS) {
          return await _printer.connect(
            type: type,
            model: BluetoothPrinterInput(
              name: selectedPrinter.name,
              address: selectedPrinter.address!,
              isBle: isBle,
              autoConnect: reconnect,
            ),
          );
        } else {
          throw ExceptionPrintThermalBerdan(
            "Conexão Bluetooth somente para iOS e Android",
          );
        }
      case PrinterType.network:
        return await _printer.connect(
          type: type,
          model: TcpPrinterInput(
            ipAddress: ipAddress ?? selectedPrinter.address!,
          ),
        );
      default:
        throw ExceptionPrintThermalBerdan(
          "PrinterType Inválido",
        );
    }
  }

  @override
  Future<bool> disconnectPrinter({required PrinterType type}) async {
    return await _printer.disconnect(type: type);
  }

  @override
  Future<bool> sendToPrint({
    required List<int> bytes,
    required PrinterType type,
  }) {
    return _printer.send(type: type, bytes: bytes);
  }
}
