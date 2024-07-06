import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:print_thermal_berdan/print_thermal_berdan.dart';

abstract class ITextGeneratorService {
  Future<void> init({required PaperSize paperSize});
  Future<List<int>> generateOrder({required OrderReceipt order, String imageAsset = ""});
}
