import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'resultado_data_source.dart';

class TablaDinamicaResultado extends StatelessWidget {
  final ResultadoDataGridSource dataSource;

  const TablaDinamicaResultado({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: dataSource,
      allowSorting: true,
      allowEditing: false,
      allowFiltering: true,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'nombre',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('Campo', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        GridColumn(
          columnName: 'valor',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('Valor', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
