import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_thermal_berdan/src/interfaces/print_thermal_service.dart';
import 'package:print_thermal_berdan/src/interfaces/text_generator_service.dart';
import 'package:print_thermal_berdan/src/models/order_receipt.dart';
import 'package:print_thermal_berdan/src/services/print_thermal_service.dart';
import 'package:print_thermal_berdan/src/services/text_generator_service.dart';
import 'package:thermal_printer/thermal_printer.dart';

class PrintThermalPresenter {
  late IPrintThermalService _printerService;
  late ITextGeneratorService _textService;
  late PrinterType typeConnection;

  PrintThermalPresenter(this.typeConnection) {
    _printerService = PrintThermalService();
    _textService = TextGeneratorService();
  }

  Stream<PrinterDevice> getDevices() {
    typeConnection = typeConnection;
    return _printerService.scanPrinters(
      type: typeConnection,
      isBle: false,
    );
  }

  Future<bool> connectDevice(PrinterDevice device) async {
    return await _printerService.connectPrinter(
      selectedPrinter: device,
      type: typeConnection,
      reconnect: true,
      isBle: true,
      ipAddress: device.address,
    );
  }

  Future<bool> disconnectDevice() async {
    return await _printerService.disconnectPrinter(type: typeConnection);
  }

  Future<bool> sendToPrinter(OrderReceipt order) async {
    await _textService.init(paperSize: PaperSize.mm80);
    var data = _textService.generateOrder(order: order);
    return await _printerService.sendToPrint(
      bytes: data,
      type: typeConnection,
    );
  }
}
