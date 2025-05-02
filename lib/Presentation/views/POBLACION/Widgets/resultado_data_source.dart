import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'resultado_data.dart';

class ResultadoDataGridSource extends DataGridSource {
  ResultadoDataGridSource(List<ResultadoData> data) {
    _rows = data
        .map<DataGridRow>((item) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'nombre', value: item.nombre),
              DataGridCell<String>(columnName: 'valor', value: item.valor),
            ]))
        .toList();
  }

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}
