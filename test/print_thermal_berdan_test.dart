import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:print_thermal_berdan/print_thermal_berdan.dart';

import 'print_thermal_berdan_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PrintThermalPresenter>()])
void main() {
  // TODO: Para testes mais complexos, implementar injeção de dependencia!
  group("Mock", () {
    late MockPrintThermalPresenter service;
    setUpAll(() {
      service = MockPrintThermalPresenter();
    });
    group("success", () {
      test("scan devices", () async {
        when(service.getDevices()).thenAnswer(
          (_) => Stream.value(
            PrinterDevice(
              name: "name",
              address: "123",
            ),
          ),
        );

        var devices = <PrinterDevice>[];
        var stream = service.getDevices().listen((device) {
          devices.add(device);
        });

        await Future.delayed(Durations.short1);

        expect(devices.isNotEmpty, true);
        expect(devices.first.name, "name");
        expect(devices.first.address, "123");
        stream.cancel();
      });

      test("connect device", () async {
        when(service.connectDevice(any)).thenAnswer((_) => Future.value(true));

        var result = await service.connectDevice(
          PrinterDevice(name: "name", address: "123"),
        );

        expect(result, true);
      });

      test("disconnect device", () async {
        when(service.disconnectDevice()).thenAnswer((_) => Future.value(true));

        var result = await service.disconnectDevice();

        expect(result, true);
      });

      test("send to printer", () async {
        when(service.sendToPrinter(any)).thenAnswer((_) => Future.value(true));

        var result = await service.sendToPrinter(const OrderReceipt());

        expect(result, true);
      });
    });

    group("fails", () {
      test("scan devices", () async {
        when(service.getDevices()).thenAnswer(
          (_) => const Stream.empty(),
        );

        var devices = <PrinterDevice>[];
        var stream = service.getDevices().listen(
              (device) => devices.add(device),
            );

        await Future.delayed(Durations.short1);

        expect(devices.isEmpty, true);
        stream.cancel();
      });

      test("connect device", () async {
        when(service.connectDevice(any)).thenAnswer((_) => Future.value(false));

        var result = await service.connectDevice(
          PrinterDevice(name: "name", address: "123"),
        );

        expect(result, false);
      });

      test("disconnect device", () async {
        when(service.disconnectDevice()).thenAnswer((_) => Future.value(false));

        var result = await service.disconnectDevice();

        expect(result, false);
      });

      test("send to printer", () async {
        when(service.sendToPrinter(any)).thenAnswer((_) => Future.value(false));

        var result = await service.sendToPrinter(const OrderReceipt());

        expect(result, false);
      });
    });
  });
}
