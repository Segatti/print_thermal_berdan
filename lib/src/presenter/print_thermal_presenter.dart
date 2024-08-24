import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
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

  PrintThermalPresenter(
    /// Tipo de Conexão (USB, Network, Bluetooth)
    this.typeConnection,
  ) {
    _printerService = PrintThermalService();
    _textService = TextGeneratorService();
  }

  /// Scaneia as impressoras
  ///
  /// Retorno: Stream<PrinterDevice>
  Stream<PrinterDevice> getDevices() {
    typeConnection = typeConnection;
    return _printerService.scanPrinters(
      type: typeConnection,
      isBle: true,
    );
  }

  /// Conecta a uma impressora
  ///
  /// Retorno: true == sucesso | false == falha
  ///
  /// Exception: ExceptionPrintThermalBerdan(message)
  Future<bool> connectDevice(PrinterDevice device) async {
    return await _printerService.connectPrinter(
      selectedPrinter: device,
      type: typeConnection,
      reconnect: true,
      isBle: true,
      ipAddress: device.address,
    );
  }

  /// Disconecta a impresora atual
  ///
  /// Retorno: true == sucesso | false == falha
  Future<bool> disconnectDevice() async {
    return await _printerService.disconnectPrinter(type: typeConnection);
  }

  /// Enviar uma ordem para impressão
  ///
  /// Retorno: true == sucesso | false == falha
  Future<bool> sendToPrinter(
    /// Dados para impressão
    OrderReceipt order, {
    /// Logo armazenada dentro do projeto
    String imageAsset = "",

    /// Tamanho do papel da maquina.
    ///
    /// CUIDADO: Caso configurado errado irá imprimir errado!
    PaperSize paperSize = PaperSize.mm72,
  }) async {
    await _textService.init(paperSize: paperSize);
    var data = await _textService.generateOrder(
      order: order,
      imageAsset: imageAsset,
    );
    return await _printerService.sendToPrint(
      bytes: data,
      type: typeConnection,
    );
  }
}
