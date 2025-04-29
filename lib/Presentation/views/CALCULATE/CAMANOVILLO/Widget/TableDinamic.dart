import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sufaweb/env_loader.dart';


class TableDinamic extends StatefulWidget {
  final String id;

  const TableDinamic({super.key, required this.id});

  @override
  State<TableDinamic> createState() => _TableDinamicState();
}

class _TableDinamicState extends State<TableDinamic> {
  final Map<String, TextEditingController> _controllers = {
    'AcumuladoactualLBS': TextEditingController(),
    'Acumuladosemanal': TextEditingController(),
    'Aireadores': TextEditingController(),
    'pesoactualgdia': TextEditingController(),
    'Aireadoresdiesel': TextEditingController(),
    'Alimentoactualkg': TextEditingController(),
    'Capacidadcargaaireaccion': TextEditingController(),
    'Crecimientoactualgdia': TextEditingController(),
    'Crecimientoesperadogsem': TextEditingController(),
    'Densidadbiologoindm2': TextEditingController(),
    'Densidadconsumoim2': TextEditingController(),
    'DensidadporAtarraya': TextEditingController(),
    'Diferenciacampobiologo': TextEditingController(),
    'Domingodia7': TextEditingController(),
    'Edaddelcultivo': TextEditingController(),
    'FCACampo': TextEditingController(),
    'FCAConsumo': TextEditingController(),
    'Fechademuestreo': TextEditingController(),
    'Fechadesiembra': TextEditingController(),
    'Finca': TextEditingController(),
    'Hectareas': TextEditingController(),
    'HpHa': TextEditingController(),
    'Incrementogr': TextEditingController(),
    'Juevesdia4': TextEditingController(),
    'Kg100mil': TextEditingController(),
    'LBShaactualcampo': TextEditingController(),
    'LBShaconsumo': TextEditingController(),
    'LBStolva': TextEditingController(),
    'LBStolvaactualcampo': TextEditingController(),
    'Librastotalescampo': TextEditingController(),
    'Librastotalesconsumo': TextEditingController(),
    'LibrastotalesporAireador': TextEditingController(),
    'Lunesdia1': TextEditingController(),
    'MarcaAA': TextEditingController(),
    'Martesdia2': TextEditingController(),
    'Miercolesdia3': TextEditingController(),
    'Pesoactualgdia': TextEditingController(),
    'Pesoanterior': TextEditingController(),
    'Pesoproyectadogdia': TextEditingController(),
    'Pesosiembra': TextEditingController(),
    'Piscinas': TextEditingController(),
    'Recomendacionlbsha': TextEditingController(),
    'Recomendationsemana': TextEditingController(),
    'RendimientoLbsSaco': TextEditingController(),
    'Sabadodia6': TextEditingController(),
    'Sacosactuales': TextEditingController(),
    'TipoBalanceado': TextEditingController(),
    'Viernesdia5': TextEditingController(),
    'numeroAA': TextEditingController(),
  };
  late DatabaseReference _ref;
  final String _selectedFinca = 'CAMANOVILLO';
  String? basePath;

  @override
  void initState() {
    super.initState();
    basePath = EnvLoader.get('RESULT_ALIMENTATION');
    if (basePath == null) {
      throw Exception('RESULT_ALIMENTATION not found in .env');
    }
    _ref =
        FirebaseDatabase.instance.ref('$basePath/$_selectedFinca/${widget.id}');
    loadData();
  }

  Future<void> loadData() async {
    final snapshot = await _ref.get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        if (_controllers.containsKey(key)) {
          _controllers[key]?.text = value.toString();
        }
      });
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rowData1 = [
      _controllers['Piscinas']?.text ?? '',
      _controllers['Hectareas']?.text ?? '',
      _controllers['Fechadesiembra']?.text ?? '',
      _controllers['Fechademuestreo']?.text ?? '',
      _controllers['Pesosiembra']?.text ?? '',
      _controllers['Edaddelcultivo']?.text ?? '',
      _controllers['Crecimientoactualgdia']?.text ?? '',
      _controllers['Pesoanterior']?.text ?? '',
      _controllers['Incrementogr']?.text ?? '',
      _controllers['Pesoactualgdia']?.text ?? '',
    ];

    final rowData2 = [
      _controllers['Pesoproyectadogdia']?.text ?? '',
      _controllers['Crecimientoesperadogsem']?.text ?? '',
      _controllers['Kg100mil']?.text ?? '',
      _controllers['Alimentoactualkg']?.text ?? '',
      _controllers['Sacosactuales']?.text ?? '',
      _controllers['Densidadconsumoim2']?.text ?? '',
      _controllers['Densidadbiologoindm2']?.text ?? '',
      _controllers['DensidadporAtarraya']?.text ?? '',
      _controllers['Diferenciacampobiologo']?.text ?? '',
      '',
    ];

    final rowData3 = [
      _controllers['Lunesdia1']?.text ?? '',
      _controllers['Martesdia2']?.text ?? '',
      _controllers['Miercolesdia3']?.text ?? '',
      _controllers['Juevesdia4']?.text ?? '',
      _controllers['Viernesdia5']?.text ?? '',
      _controllers['Sabadodia6']?.text ?? '',
      _controllers['Domingodia7']?.text ?? '',
      _controllers['Recomendationsemana']?.text ?? '',
    ];

    final rowData4 = [
      _controllers['Acumuladosemanal']?.text ?? '',
      _controllers['TipoBalanceado']?.text ?? '',
      _controllers['AcumuladoactualLBS']?.text ?? '',
      _controllers['LBShaconsumo']?.text ?? '',
      _controllers['LBShaactualcampo']?.text ?? '',
      _controllers['FCACampo']?.text ?? '',
      _controllers['FCAConsumo']?.text ?? '',
      _controllers['RendimientoLbsSaco']?.text ?? '',
    ];

    final rowData5 = [
      _controllers['numeroAA']?.text ?? '',
      _controllers['MarcaAA']?.text ?? '',
      _controllers['LBStolvaactualcampo']?.text ?? '',
      _controllers['LBStolva']?.text ?? '',
      _controllers['Aireadores']?.text ?? '',
    ];
    final rowData6 = [
      _controllers['LibrastotalesporAireador']?.text ?? '',
      _controllers['HpHa']?.text ?? '',
      _controllers['Recomendacionlbsha']?.text ?? '',
      _controllers['Librastotalescampo']?.text ?? '',
      _controllers['Librastotalesconsumo']?.text ?? '',
    ];

    final row1 = [
      'Piscina',
      'Área (Ha)',
      'Fecha de siembra',
      'Fecha de muestreo',
      'Peso siembra',
      'Edad de cultivo',
      'Crecim actual g/día',
      'Peso Anterior',
      'Incremento gr',
      'Peso actual campo (g)',
    ];

    final row2 = [
      'Peso proyectado (g)',
      'Crecimiento esperado (g/sem)',
      'Kg/100 mil',
      'Alimento actual Campo (kg)',
      'Sacos Actuales',
      'Densidad por consumo (i/m2)',
      'Densidad Biólogo (ind/m2)',
      'Densidad por Atarraya',
      'Diferencia campo vs biólogo',
      '',
    ];

    final row3 = [
      'Lunesdia 1',
      'Martesdia 2',
      'Miercolesdia 3',
      'Juevesdia 4',
      'Viernesdia 5',
      'Sabadodia 6',
      'Domingodia 7',
      'Recomendación Semana',
    ];

    final row4 = [
      'Acumulado Semanal',
      'Tipo Balanceado',
      'Acumulado ActualLBS',
      'LBS/ha consumo',
      'LBS/ha actualcampo',
      'FCA Campo',
      'FCA Consumo',
      'Rendimiento Lbs/Saco',
    ];

    final row5 = [
      'Número AA',
      'Marca AA',
      'LBS tolva actual campo',
      'LBS tolva',
      'Aireadores',
    ];

    final row6 = [
      'Libras totales por Aireador',
      'Hp/Ha',
      'Recomendacion lbs/ha',
      'Libras totales campo',
      'Libras totales consumo',
    ];

    TableRow buildRow(List<String> values, Color color,
        {bool isHeader = false}) {
      return TableRow(
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
          color: isHeader
              ? color.withOpacity(0.1)
              : const Color.fromARGB(255, 155, 155, 155).withOpacity(0.1),
        ),
        children: values.map((value) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                    color: isHeader ? color : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                constrained: false,
                minScale: 0.5,
                maxScale: 3.0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 0,
                      maxHeight: 1200, // puedes ajustar este valor
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "📌 Datos Generales",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 126, 53, 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Table(
                            defaultColumnWidth: const FixedColumnWidth(140),
                            children: [
                              buildRow(row1, Colors.teal, isHeader: true),
                              buildRow(rowData1, Colors.transparent),
                              buildRow(row2, Colors.teal, isHeader: true),
                              buildRow(rowData2, Colors.transparent),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "🍤 Alimentación Semanal",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 126, 53, 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Table(
                            defaultColumnWidth: const FixedColumnWidth(140),
                            children: [
                              buildRow(row3, Colors.orange, isHeader: true),
                              buildRow(rowData3, Colors.transparent),
                              buildRow(row4, Colors.orange, isHeader: true),
                              buildRow(rowData4, Colors.transparent),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "💨 Aireadores",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 126, 53, 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Table(
                            defaultColumnWidth: const FixedColumnWidth(140),
                            children: [
                              buildRow(row5, Colors.blue, isHeader: true),
                              buildRow(rowData5, Colors.transparent),
                              buildRow(row6, Colors.blue, isHeader: true),
                              buildRow(rowData6, Colors.transparent),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
