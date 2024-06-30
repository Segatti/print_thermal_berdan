import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_thermal_berdan/print_thermal_berdan.dart';

abstract class ITextGeneratorService {
  Future<void> init({required PaperSize paperSize});
  List<int> generateOrder({required OrderReceipt order});
}
