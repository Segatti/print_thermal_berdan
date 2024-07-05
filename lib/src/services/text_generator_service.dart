import 'dart:convert';

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:intl/intl.dart';
import 'package:print_thermal_berdan/src/interfaces/text_generator_service.dart';
import 'package:print_thermal_berdan/src/models/exception_print_thermal.dart';
import 'package:print_thermal_berdan/src/models/order_receipt.dart';

class TextGeneratorService implements ITextGeneratorService {
  Generator? generator;

  @override
  Future<void> init({required PaperSize paperSize}) async {
    final profile = await CapabilityProfile.load();
    generator = Generator(paperSize, profile, codec: const Utf8Codec());
    generator!.setGlobalCodeTable("CP860");
  }

  @override
  List<int> generateOrder({required OrderReceipt order}) {
    if (generator != null) {
      List<int> bytes = [];
      var dateFormat = DateFormat("dd/MM/yyyy hh:mm");

      // Company
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
        'CNPJ: ${order.company.cnpj}',
        styles: const PosStyles(align: PosAlign.center),
      );

      bytes += generator!.hr();

      // Avisos
      bytes += generator!.text(
        'IMPRESSO EM ${dateFormat.format(DateTime.now())}',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.text(
        'SIMPLES CONFERÊNCIA DA CONTA',
        styles: const PosStyles(
          align: PosAlign.center,
          codeTable: "CP860",
        ),
      );
      bytes += generator!.text(
        'RELATÓRIO GERENCIAL',
        styles: const PosStyles(align: PosAlign.center),
        linesAfter: 1,
      );
      bytes += generator!.text(
        '*** NÃO É DOCUMENTO FISCAL ***',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.hr();
      bytes += generator!.emptyLines(1);

      // Customer
      bytes += generator!.text(order.company.name);
      bytes += generator!.text(order.company.phone);
      bytes += generator!.text('(Entregar no endereço)');
      bytes += generator!.text(order.company.address);
      bytes += generator!.hr();
      bytes += generator!.emptyLines(1);

      // Order
      bytes += generator!.text(
          order.order.deliveryType == 'Berdan'
              ? 'Entregador: Berdan'
              : 'Entregador: Entrega Própria',
          linesAfter: 1);

      if (order.order.orderCode != null) {
        bytes += generator!.text(
          'Número do pedido: ${order.order.orderCode!}',
          linesAfter: 1,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        );
      }
      bytes += generator!.text(
        'Origem: ${order.order.origin}',
        linesAfter: 1,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += generator!.emptyLines(1);
      bytes += generator!.row([
        PosColumn(
          text: 'QTD',
          width: 2,
          styles: const PosStyles(underline: true),
        ),
        PosColumn(
          text: 'ITEM',
          width: 7,
          styles: const PosStyles(underline: true),
        ),
        PosColumn(
          text: 'TOTAL',
          width: 3,
          styles: const PosStyles(underline: true),
        ),
      ]);
      for (var item in order.itemsOrder.cartList) {
        bytes += generator!.row([
          PosColumn(
            text: item.quantity.toString(),
            width: 2,
          ),
          PosColumn(
            text: item.name,
            width: 7,
          ),
          PosColumn(
            text: (item.price * item.quantity).toString(),
            width: 3,
          ),
        ]);
        if (item.adicionais.isNotEmpty) {
          bytes += generator!.row([
            PosColumn(
              text: 'Adicionais',
              width: 12,
              styles: const PosStyles(bold: true),
            ),
          ]);
          for (var adicional in item.adicionais) {
            bytes += generator!.row([
              PosColumn(
                text: "+ ${adicional.quantity}",
                width: 2,
              ),
              PosColumn(
                text: adicional.adicional,
                width: 7,
              ),
              PosColumn(
                text: (adicional.price != null)
                    ? (adicional.price! * adicional.quantity).toString()
                    : "--",
                width: 3,
              ),
            ]);
          }
        }
        if (item.opcionais.isNotEmpty) {
          bytes += generator!.row([
            PosColumn(
              text: 'Opcionais',
              width: 12,
              styles: const PosStyles(bold: true),
            ),
          ]);
          for (var opcional in item.opcionais) {
            bytes += generator!.row([
              PosColumn(
                text: "+",
                width: 2,
              ),
              PosColumn(
                text: opcional.opcional,
                width: 7,
              ),
              PosColumn(
                text: (opcional.price != null)
                    ? (opcional.price!).toString()
                    : "--",
                width: 3,
              ),
            ]);
          }
        }
        bytes += generator!.emptyLines(1);
      }
      bytes += generator!.hr();

      // Total
      bytes += generator!.row([
        PosColumn(
          text: "TOTAL:",
          width: 6,
        ),
        PosColumn(
          text: order.valuesOrder.priceTotal.toString(),
          width: 6,
        ),
      ]);
      bytes += generator!.row([
        PosColumn(
          text: "- DESCONTO:",
          width: 6,
        ),
        PosColumn(
          text: order.valuesOrder.discount.toString(),
          width: 6,
        ),
      ]);
      bytes += generator!.row([
        PosColumn(
          text: "+ ENTREGA:",
          width: 6,
        ),
        PosColumn(
          text: order.valuesOrder.deliveryFee.toString(),
          width: 6,
        ),
      ]);
      bytes += generator!.row([
        PosColumn(
          text: "= TOTAL A PAGAR:",
          width: 6,
        ),
        PosColumn(
          text: order.valuesOrder.subtotal.toString(),
          width: 6,
        ),
      ]);
      bytes += generator!.emptyLines(1);
      bytes += generator!.text("FORMA DE PAGAMENTO");
      bytes += generator!.text(
        order.valuesOrder.paymentForm,
        styles: const PosStyles(
          bold: true,
        ),
      );
      // if (image != null) {
      //   bytes += generator!.emptyLines(2);
      //   bytes += generator!.imageRaster(image!, imageFn: PosImageFn.graphics);
      // }

      bytes += generator!.emptyLines(2);
      bytes += generator!.cut();
      bytes += generator!.beep(n: 2);

      return bytes;
    } else {
      throw ExceptionPrintThermalBerdan("Serviço de texto não iniciado");
    }
  }
}
