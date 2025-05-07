// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:sufaweb/Presentation/views/POBLACION/Widgets/resultado_data.dart';
import 'package:flutter/foundation.dart'; // para kIsWeb

// Solo se importa en web
// ignora advertencias si estás en móvil
import 'dart:html' as html;

Future<void> exportarAExcel(List<ResultadoData> data) async {
  final xlsio.Workbook workbook = xlsio.Workbook();
  final xlsio.Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName('A1').setText('Campo');
  sheet.getRangeByName('B1').setText('Valor');

  for (int i = 0; i < data.length; i++) {
    sheet.getRangeByIndex(i + 2, 1).setText(data[i].campo);
    sheet.getRangeByIndex(i + 2, 2).setText(data[i].valor);
  }

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  if (kIsWeb) {
    final content = Uint8List.fromList(bytes);
    final blob = html.Blob([content]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "resultado.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // Para móvil / escritorio
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/resultado.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    await OpenFile.open(filePath);
  }
}
