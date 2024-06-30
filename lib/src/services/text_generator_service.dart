import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';
import 'package:print_thermal_berdan/src/interfaces/text_generator_service.dart';
import 'package:print_thermal_berdan/src/models/exception_print_thermal.dart';
import 'package:print_thermal_berdan/src/models/order_receipt.dart';

class TextGeneratorService implements ITextGeneratorService {
  Generator? generator;

  @override
  Future<void> init({required PaperSize paperSize}) async {
    final profile = await CapabilityProfile.load();
    generator = Generator(paperSize, profile);
  }

  @override
  List<int> generateOrder({required OrderReceipt order}) {
    if (generator != null) {
      List<int> bytes = [];
      var dateFormat = DateFormat("dd-MM-yyyy hh:mm");

      // Company
      bytes += generator!.emptyLines(3);
      bytes += generator!.text(
        order.company.name,
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.text(
        order.company.address,
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.text(
        order.company.phone,
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.text(
        "CNPJ: ${order.company.cnpj}",
        styles: const PosStyles(
          align: PosAlign.center,
          underline: true,
        ),
      );

      // Avisos
      bytes += generator!.text(
        "IMPRESSO EM ${dateFormat.format(DateTime.now())}",
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.text(
        "SIMPLES CONFERÊNCIA DA CONTA",
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.text(
        "RELATÓRIO GERENCIAL",
        styles: const PosStyles(align: PosAlign.center),
        linesAfter: 1,
      );
      bytes += generator!.text(
        "*** NÃO É DOCUMENTO FISCAL ***",
        styles: const PosStyles(align: PosAlign.center),
        linesAfter: 1,
      );

      // Customer
      bytes += generator!.text(order.company.name);
      bytes += generator!.text(order.company.phone);
      bytes += generator!.text("(Entregar no endereço)");
      bytes += generator!.text(order.company.address, linesAfter: 1);

      bytes += generator!.text(
          order.order.deliveryType == "Berdan"
              ? "Entregador: Berdan"
              : "Entregador: Entrega Própria",
          linesAfter: 1);

      if (order.order.orderCode != null) {
        bytes += generator!.text("Número do pedido: ${order.order.orderCode!}", linesAfter: 1);
      }

      return bytes;
    } else {
      throw ExceptionPrintThermalBerdan("Serviço de texto não iniciado");
    }
  }
}
