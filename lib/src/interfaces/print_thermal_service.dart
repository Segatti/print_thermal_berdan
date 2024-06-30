import 'package:thermal_printer/thermal_printer.dart';

abstract class IPrintThermalService {
  Stream<PrinterDevice> scanPrinters({
    required PrinterType type,
    required bool isBle,
  });
  Future<bool> connectPrinter({
    required PrinterDevice selectedPrinter,
    required PrinterType type,
    required bool reconnect,
    required bool isBle,
    String? ipAddress,
  });

  Future<bool> disconnectPrinter({required PrinterType type});
  
  Future<bool> sendToPrint({
    required List<int> bytes,
    required PrinterType type,
  });
}
