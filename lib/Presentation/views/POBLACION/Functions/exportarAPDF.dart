// ignore_for_file: unused_local_variable, deprecated_member_use

import 'dart:html' as html; // SOLO para Flutter Web
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:sufaweb/Presentation/views/POBLACION/Widgets/resultado_data.dart';

Future<void> exportarAPDF(
  List<ResultadoData> data,
) async {
  final font = pw.Font.ttf(
    await rootBundle.load('assets/fonts/static/NotoSans-Regular.ttf'),
  );

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Table.fromTextArray(
          headers: ['Campo', 'Valor'],
          data: data.map((e) => [e.campo, e.valor]).toList(),
          headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(font: font),
          cellAlignment: pw.Alignment.centerLeft,
        );
      },
    ),
  );

  final Uint8List bytes = await pdf.save();

  if (kIsWeb) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "resultado.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/resultado.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    await OpenFile.open(filePath);
  }
}
