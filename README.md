
# Print Thermal Berdan

Esse lib foi criada para dar suporte a impressão de cupom fiscal no ecosistema da Berdan, que é impresso usando impressoras termicas. Dentre os modelos mais utilizados nos seu cliente (atualmente 07/2024) são o modelo Bematech MP 4200 Th 80mm.

## Autores

- [@Segatti](https://www.github.com/segatti)


## Funcionalidades

- Scanear as impressoras de acordo com o tipo de conexão
- Conectar a uma impressora
- Disconectar da ultima impressora
- Enviar um pedido para impressão do cupom


## ATENÇÃO

1 ) Para a impressão ser efetuada corretamente é preciso configurar corretamente a impressora para ter suporte ao padrão de dados **ESC/POS**.

2 ) Se a **impressão estever mal formatada**, tente mudar o tamanho do paper na função sendToPrinter, no parâmetro *"paperSize"* para o tamanho que melhor se adaptar a sua maquina.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.

3 ) **Durante os testes com dispositivos reais, o padrão ESC/POS no aparelho Bematech MP 4200 Th 80mm só imprimiu corretamente com o tamanho 72mm.**
## Uso/Exemplos

#### Listando impressoras
```dart
import 'package:print_thermal_berdan/print_thermal_berdan.dart';

void main() async {
  // Passe o tipo de conexão
  final printer = PrintThermalPresenter(PrinterType.network);
  late StreamSubscription<PrinterDevice> streamDevices;
  List<PrinterDevice> devices = [];

  // Buscar as impressoras
  streamDevices = printer.getDevices().listen((device) {
    devices.add(device);
  });

  await Future.delayed(Durations.long4);

  // Lembre-se de fechar o stream quando não for mais utilizar
  streamDevices.cancel();
}
```

#### Selecionando uma impressora
```dart
import 'package:print_thermal_berdan/print_thermal_berdan.dart';

void main() async {
  // Passe o tipo de conexão
  final printer = PrintThermalPresenter(PrinterType.network);
  List<PrinterDevice> devices; // Lista preenchida com o exemplo anterior

  // Conectando a impressora
  await printer.connectDevice(devices[index]).then((value) {
    if (value) {
      printerSelected = devices[index];
    } else {
      print("Falha ao tentar se conectar");
    }
  });
}
```

#### Desconectando a impressora
```dart
import 'package:print_thermal_berdan/print_thermal_berdan.dart';

void main() async {
  // Passe o tipo de conexão
  final printer = PrintThermalPresenter(PrinterType.network);

  // Desconectar a impressora
  await printer.disconnectDevice();
}
```

#### Enviando dados para impressão
```dart
import 'package:print_thermal_berdan/print_thermal_berdan.dart';

void main() async {
  // Passe o tipo de conexão
  final printer = PrintThermalPresenter(PrinterType.network);
  // Nesse exemplo considere que já foi selecionado a impressora
  PrinterDevice? printerSelected; 

  // Dados sendo carregados do arquivo json
  final String response = await rootBundle.loadString('lib/data.json');
  final data = await json.decode(response);

  if (printerSelected != null) {
    var orderJson = OrderReceipt.fromMap(data[0]);
    await printer.sendToPrinter(
      orderJson,
      // Você pode adicionar uma logo ao final do cupom, passando 
      // uma imagem do seu asset!
      imageAsset: "assets/logo.webp",
      // Aqui você pode configurar o tamanho do papel de impressão, padrão é 72mm
      paperSize: PaperSize.mm72,
    );
    print("Foi enviado!");
  } else {
    print("Escolha uma impressora");
  }
}
```
