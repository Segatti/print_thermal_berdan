// Mocks generated by Mockito 5.4.4 from annotations
// in print_thermal_berdan/test/print_thermal_berdan_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:print_thermal_berdan/src/models/order_receipt.dart' as _i5;
import 'package:print_thermal_berdan/src/presenter/print_thermal_presenter.dart'
    as _i2;
import 'package:thermal_printer/thermal_printer.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [PrintThermalPresenter].
///
/// See the documentation for Mockito's code generation for more information.
class MockPrintThermalPresenter extends _i1.Mock
    implements _i2.PrintThermalPresenter {
  @override
  _i3.PrinterType get typeConnection => (super.noSuchMethod(
        Invocation.getter(#typeConnection),
        returnValue: _i3.PrinterType.bluetooth,
        returnValueForMissingStub: _i3.PrinterType.bluetooth,
      ) as _i3.PrinterType);

  @override
  set typeConnection(_i3.PrinterType? _typeConnection) => super.noSuchMethod(
        Invocation.setter(
          #typeConnection,
          _typeConnection,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Stream<_i3.PrinterDevice> getDevices() => (super.noSuchMethod(
        Invocation.method(
          #getDevices,
          [],
        ),
        returnValue: _i4.Stream<_i3.PrinterDevice>.empty(),
        returnValueForMissingStub: _i4.Stream<_i3.PrinterDevice>.empty(),
      ) as _i4.Stream<_i3.PrinterDevice>);

  @override
  _i4.Future<bool> connectDevice(_i3.PrinterDevice? device) =>
      (super.noSuchMethod(
        Invocation.method(
          #connectDevice,
          [device],
        ),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<bool> disconnectDevice() => (super.noSuchMethod(
        Invocation.method(
          #disconnectDevice,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<bool> sendToPrinter(
    _i5.OrderReceipt? order, {
    String? imageAsset = r'',
    _i6.PaperSize? paperSize = _i6.PaperSize.mm72,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendToPrinter,
          [order],
          {
            #imageAsset: imageAsset,
            #paperSize: paperSize,
          },
        ),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}