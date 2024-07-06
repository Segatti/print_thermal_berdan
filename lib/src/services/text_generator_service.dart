import 'package:flutter/services.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:print_thermal_berdan/src/interfaces/text_generator_service.dart';
import 'package:print_thermal_berdan/src/models/exception_print_thermal.dart';
import 'package:print_thermal_berdan/src/models/extends/ext_num.dart';
import 'package:print_thermal_berdan/src/models/extends/ext_string.dart';
import 'package:print_thermal_berdan/src/models/order_receipt.dart';

class TextGeneratorService implements ITextGeneratorService {
  Generator? generator;

  @override
  Future<void> init({required PaperSize paperSize}) async {
    final profile = await CapabilityProfile.load();
    generator = Generator(paperSize, profile);
  }

  String _createLine(String key, String value) {
    return "$key: $value";
  }

  String getPaymentText(String value) {
    switch (value) {
      case "pix":
        return "Pix";
      case "cashback":
        return "Cashback";
      case "creditcard":
        return "Cartao de Credito";
      case "multi":
        return "Multiplas Formas";
      default:
        return "---";
    }
  }

  List<int> createTitle(String title) {
    var bytes = <int>[];
    bytes += generator!.text(
      "+----------------------------------------+",
    );
    bytes += generator!.text(
      title,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
      ),
    );
    bytes += generator!.text(
      "+----------------------------------------+",
    );
    return bytes;
  }

  @override
  Future<List<int>> generateOrder(
      {required OrderReceipt order, String imageAsset = ""}) async {
    if (generator != null) {
      List<int> bytes = [];
      var dateFormat = DateFormat("dd/MM/yyyy hh:mm");
      bytes += generator!.clearStyle();

      bytes +=
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

      bytes += generator!.emptyLines(1);

      bytes += generator!.text(
        "+----------------EMPRESA----------------+",
        linesAfter: 1,
        styles: const PosStyles(align: PosAlign.center),
      );

      // Company
      bytes += generator!.text(
        order.company.name.removeDiacritics(),
        styles: const PosStyles(align: PosAlign.center, bold: true),
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

      bytes += generator!.emptyLines(1);
      bytes += generator!.text(
        "+----------------CLIENTE----------------+",
        linesAfter: 1,
        styles: const PosStyles(align: PosAlign.center),
      );

      // Customer
      bytes += generator!.text(
        _createLine(
          "NOME",
          order.customer.name.removeDiacritics(),
        ),
        styles: const PosStyles(),
      );
      bytes += generator!.text(
        _createLine("CELULAR", order.customer.phone),
        styles: const PosStyles(),
      );
      bytes += generator!.text(
        _createLine(
          "ENDERECO",
          order.customer.address.removeDiacritics(),
        ),
        styles: const PosStyles(),
      );
      if (order.customer.instructions?.isNotEmpty ?? false) {
        bytes += generator!.text(
          _createLine(
            "INSTRUCAO",
            order.customer.instructions!.removeDiacritics(),
          ),
          styles: const PosStyles(),
        );
      }

      bytes += generator!.emptyLines(1);
      bytes += generator!.text(
        "+----------------ENTREGA----------------+",
        linesAfter: 1,
        styles: const PosStyles(align: PosAlign.center),
      );

      // Order
      bytes += generator!.text(
        order.order.deliveryType == 'Berdan'
            ? 'Entregador: Berdan'
            : 'Entregador: Entrega Propria',
        styles: const PosStyles(align: PosAlign.center),
      );

      if (order.order.orderCode?.isNotEmpty ?? false) {
        bytes += generator!.text(
          'Numero do pedido: ${order.order.orderCode!}',
          styles: const PosStyles(align: PosAlign.center, reverse: true),
        );
      }
      bytes += generator!.text(
        'Origem: ${order.order.origin..removeDiacritics()}',
        styles: const PosStyles(align: PosAlign.center),
      );
      bytes += generator!.emptyLines(1);
      bytes += generator!.text(
        "+---------------PEDIDO----------------+",
        linesAfter: 1,
        styles: const PosStyles(align: PosAlign.center),
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
      for (var i = 0; i < order.itemsOrder.cartList.length; i++) {
        bytes += generator!.row([
          PosColumn(
            text: "${order.itemsOrder.cartList[i].quantity}x",
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: order.itemsOrder.cartList[i].name.removeDiacritics(),
            width: 7,
          ),
          PosColumn(
            text: order.itemsOrder.cartList[i].price.toBRL(),
            width: 3,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
        if (order.itemsOrder.cartList[i].opcionais.isNotEmpty) {
          bytes += generator!.row([
            PosColumn(width: 1),
            PosColumn(
              text: 'Opcionais',
              width: 11,
              styles: const PosStyles(bold: true),
            ),
          ]);
          for (var opcional in order.itemsOrder.cartList[i].opcionais) {
            bytes += generator!.row([
              PosColumn(width: 1),
              PosColumn(
                textEncoded: Uint8List.fromList(
                  generator!.text("- ${opcional.opcional.removeDiacritics()}"),
                ),
                width: 8,
              ),
              PosColumn(
                text: (opcional.price != null) ? opcional.price!.toBRL() : "--",
                width: 3,
                styles: const PosStyles(align: PosAlign.right),
              ),
            ]);
          }
        }

        if (order.itemsOrder.cartList[i].adicionais.isNotEmpty) {
          bytes += generator!.row([
            PosColumn(width: 1),
            PosColumn(
              text: 'Adicionais',
              width: 11,
              styles: const PosStyles(bold: true),
            ),
          ]);
          for (var adicional in order.itemsOrder.cartList[i].adicionais) {
            bytes += generator!.row([
              PosColumn(width: 1),
              PosColumn(
                textEncoded: Uint8List.fromList(
                  generator!.text(
                    "+${adicional.quantity}x ${adicional.adicional.removeDiacritics()}",
                  ),
                ),
                width: 8,
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

        if ((i + 1) < order.itemsOrder.cartList.length) {
          bytes += generator!.hr(len: 42);
        }
      }

      bytes += generator!.hr(ch: "=", len: 42);
      // Total
      bytes += generator!.row([
        PosColumn(
          text: "TOTAL:",
          width: 6,
        ),
        PosColumn(
          text: order.valuesOrder.subtotal.toBRL(),
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
          text: order.valuesOrder.discount.toBRL(),
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
          text: order.valuesOrder.deliveryFee.toBRL(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytes += generator!.row([
        PosColumn(
          text: "= TOTAL:",
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
      bytes += generator!.emptyLines(1);
      bytes += generator!.text("FORMA DE PAGAMENTO");
      bytes += generator!.text(
        getPaymentText(order.valuesOrder.paymentMethod),
        styles: const PosStyles(bold: true),
      );
      bytes += generator!.text(
        order.valuesOrder.isPaid ? "PAGO" : "A PAGAR",
        styles: const PosStyles(reverse: true),
      );
      bytes += generator!.emptyLines(1);
      if (imageAsset.isNotEmpty) {
        final ByteData data = await rootBundle.load(imageAsset);
        final Uint8List bytes = data.buffer.asUint8List();
        final Image? image = decodeImage(bytes);
        // Using `ESC *`
        if (image != null) {
          generator!.image(image);
        }
      }

      bytes += generator!.cut(mode: PosCutMode.partial);

      return bytes;
    } else {
      throw ExceptionPrintThermalBerdan("Serviço de texto não iniciado");
    }
  }
}
