import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:intl/intl.dart';
import 'package:print_thermal_berdan/src/interfaces/text_generator_service.dart';
import 'package:print_thermal_berdan/src/models/exception_print_thermal.dart';
import 'package:print_thermal_berdan/src/models/extends/ext_num.dart';
import 'package:print_thermal_berdan/src/models/extends/ext_string.dart';
import 'package:print_thermal_berdan/src/models/order_receipt.dart';

class TextGeneratorService implements ITextGeneratorService {
  Generator? generator;
  int lineLenght = 48;

  @override
  Future<void> init({required PaperSize paperSize}) async {
    final profile = await CapabilityProfile.load();
    generator = Generator(paperSize, profile);
    if (paperSize == PaperSize.mm72) {
      lineLenght = 42;
    }
    if (paperSize == PaperSize.mm58) {
      lineLenght = 32;
    }
  }

  String _createLine(String key, String value) {
    return "$key: $value";
  }

  @override
  List<int> generateOrder({required OrderReceipt order}) {
    if (generator != null) {
      List<int> bytes = [];
      var dateFormat = DateFormat("dd/MM/yyyy hh:mm");
      bytes += generator!.clearStyle();

      bytes += generator!.text(
        "+-------------| EMPRESA |----------------+",
      );

      // Company
      bytes += generator!.text(
        order.company.name.removeDiacritics(),
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.text(
        order.company.address.removeDiacritics(),
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

      bytes += generator!.hr(len: 42); // -------------------------------------

      // Avisos
      bytes += generator!.text(
        'IMPRESSO EM ${dateFormat.format(DateTime.now())}',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.text(
        'SIMPLES CONFERENCIA DA CONTA',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.text(
        'RELATORIO GERENCIAL',
        styles: const PosStyles(align: PosAlign.center),
        linesAfter: 1,
      );
      bytes += generator!.text(
        '*** NAO E DOCUMENTO FISCAL ***',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.hr(len: 42); // -------------------------------------
      bytes += generator!.text(
        "+-------------| CLIENTE |----------------+",
      );
      // Customer
      bytes += generator!.text(_createLine(
        "NOME",
        order.customer.name.removeDiacritics(),
      ));
      bytes += generator!.text(_createLine("CELULAR", order.customer.phone));
      bytes += generator!.text(_createLine(
        "ENDERECO",
        order.customer.address.removeDiacritics(),
      ));
      bytes += generator!.hr(len: 42); // -------------------------------------

      // Order
      bytes += generator!.text(
        order.order.deliveryType == 'Berdan'
            ? 'Entregador: Berdan'
            : 'Entregador: Entrega Propria',
        styles: const PosStyles(align: PosAlign.center),
      );

      if (order.order.orderCode != null) {
        bytes += generator!.text(
          'Numero do pedido: ${order.order.orderCode!}',
          styles: const PosStyles(align: PosAlign.center, bold: true),
        );
      }
      bytes += generator!.text(
        'Origem: ${order.order.origin..removeDiacritics()}',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.text(
        "+----------------------------------------+",
      );
      bytes += generator!.text(
        "PEDIDO",
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
        ),
      );
      bytes += generator!.text(
        "+----------------------------------------+",
      );

      bytes += generator!.row([
        PosColumn(
          text: 'QTD',
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: 'ITEM',
          width: 7,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: 'TOTAL',
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      for (var item in order.itemsOrder.cartList) {
        bytes += generator!.row([
          PosColumn(
            text: "${item.quantity}",
            width: 2,
          ),
          PosColumn(
            text: item.name.removeDiacritics(),
            width: 7,
          ),
          PosColumn(
            text: item.price.toBRL(),
            width: 3,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
        if (item.adicionais.isNotEmpty) {
          bytes += generator!.row([
            PosColumn(
              text:
                  '  Adicionaisssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss',
              width: 12,
              styles: const PosStyles(bold: true),
            ),
          ]);
          for (var adicional in item.adicionais) {
            bytes += generator!.row([
              PosColumn(
                text: "+ ${adicional.quantity}",
              ),
              PosColumn(
                text: adicional.adicional.removeDiacritics(),
                width: 7,
              ),
              PosColumn(
                text:
                    (adicional.price != null) ? adicional.price!.toBRL() : "--",
                width: 3,
                styles: const PosStyles(align: PosAlign.right),
              ),
            ]);
          }
        }
        if (item.opcionais.isNotEmpty) {
          bytes += generator!.row([
            PosColumn(
              text: '  Opcionais',
              width: 12,
              styles: const PosStyles(bold: true),
            ),
          ]);
          for (var opcional in item.opcionais) {
            bytes += generator!.row([
              PosColumn(
                text: "+",
              ),
              PosColumn(
                text: opcional.opcional.removeDiacritics(),
                width: 7,
              ),
              PosColumn(
                text: (opcional.price != null) ? opcional.price!.toBRL() : "--",
                width: 3,
                styles: const PosStyles(align: PosAlign.right),
              ),
            ]);
          }
        }
        bytes += generator!.text(
          "+----------------------------------------+",
        );
      }
      bytes += generator!.hr(ch: "=", len: 42);

      // Total
      bytes += generator!.row([
        PosColumn(
          text: "TOTAL:",
          width: 6,
        ),
        PosColumn(
          text: order.valuesOrder.subtotal.toString(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
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
          styles: const PosStyles(align: PosAlign.right),
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
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytes += generator!.row([
        PosColumn(
          text: "= TOTAL A PAGAR:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: " ${order.valuesOrder.priceTotal.toBRL()} ",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            reverse: true,
          ),
        ),
      ]);
      bytes += generator!.hr(ch: "=", len: 42);
      bytes += generator!.emptyLines(1);
      bytes += generator!.text("FORMA DE PAGAMENTO");
      bytes += generator!.text(
        order.valuesOrder.paymentForm.removeDiacritics(),
        styles: const PosStyles(
          bold: true,
        ),
      );
      // if (image != null) {
      //   bytes += generator!.emptyLines(2);
      //   bytes += generator!.imageRaster(image!, imageFn: PosImageFn.graphics);
      // }

      bytes += generator!.cut();

      return bytes;
    } else {
      throw ExceptionPrintThermalBerdan("Serviço de texto não iniciado");
    }
  }
}
