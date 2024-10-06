import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficaCAMANOVILLOScreen extends StatefulWidget {
  const GraficaCAMANOVILLOScreen({Key? key}) : super(key: key);

  @override
  _GraficaCAMANOVILLOScreenState createState() =>
      _GraficaCAMANOVILLOScreenState();
}

class _GraficaCAMANOVILLOScreenState extends State<GraficaCAMANOVILLOScreen> {
  final databaseReference = FirebaseDatabase.instance
      .ref("Empresas/TerrawaSufalyng/Result/Dato/CAMANOVILLO");

  List<Map<String, dynamic>> resut_ = [];
  String selectedValue =
      'Consumo'; // Valor por defecto para mostrar en la gráfica
  Map<int, Color> barColors = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    databaseReference.once().then((DatabaseEvent snapshot) {
      final data = snapshot.snapshot.value;
      if (data != null) {
        final resultList = (data as Map).entries.map((entry) {
          final value = entry.value as Map<dynamic, dynamic>;
          return {
            'Piscina': value['Piscinas'] ?? 'Desconocida',
            'Consumo': (value['Consumo'] ?? 0).toDouble(),
            'Rendimiento': (value['Rendimiento'] ?? 0).toDouble(),
            'LibrasTotal': (value['LibrasTotal']?.toDouble() ?? 0),
            'KGXHA': (value['KGXHA']?.toDouble() ?? 0),
            'Error2': (value['Error2']?.toDouble() ?? 0),
          };
        }).toList();

        setState(() {
          resut_ = resultList.take(5).toList();
          List<Color> pastelColors = [
            const Color(0xffaec6cf),
            const Color(0xffffb3ba),
            const Color(0xffc6e2ff),
            const Color(0xffd3ffce),
            const Color(0xffffd1dc),
          ];
          barColors = {
            for (int i = 0; i < resut_.length; i++)
              i: pastelColors[i % pastelColors.length]
          };
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Envolvemos todo el contenido en un SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(),
                      barGroups: resut_.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: _getBarValue(data),
                              color: barColors[index],
                              width: 30,
                              borderRadius: BorderRadius.circular(4),
                              rodStackItems: [],
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: _getBarValue(data),
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                          showingTooltipIndicators: [0],
                        );
                      }).toList(),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < resut_.length) {
                                return Text(
                                  'Piscina ${resut_[value.toInt()]['Piscina']}',
                                  style: const TextStyle(fontSize: 12),
                                );
                              }
                              return const Text('');
                            },
                            reservedSize: 42,
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedValue = 'KGXHA';
                        });
                      },
                      child: const Text('KGXHA'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedValue = 'LibrasTotal';
                        });
                      },
                      child: const Text('LibrasTotal'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedValue = 'LibrasXHA';
                        });
                      },
                      child: const Text('LibrasXHA'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedValue = 'Error2';
                        });
                      },
                      child: const Text('Error2'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600
                        ? 2
                        : 1, // 2 columnas en pantallas grandes, 1 en pantallas pequeñas
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5, // Ajusta según el tamaño que quieras
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: resut_.length,
                  itemBuilder: (context, index) {
                    var result = resut_[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: barColors[index],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40.0),
                                bottomRight: Radius.circular(40.0),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(5, 5),
                                  color: Color.fromARGB(80, 0, 0, 0),
                                  blurRadius: 5,
                                ),
                                BoxShadow(
                                    offset: Offset(-5, -5),
                                    color: Color.fromARGB(150, 255, 255, 255),
                                    blurRadius: 5),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Piscina: ${result['Piscina']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'AnimalesM: ${result['AnimalesM']?.toStringAsFixed(2) ?? "N/A"}\n\n'
                                    'Consumo: ${result['Consumo'].toStringAsFixed(2)}\n\n'
                                    'Error2: ${result['Error2'].toStringAsFixed(2)}\n\n'
                                    'FechaHora: ${result['FechaHora'] ?? "N/A"}\n\n'
                                    'Hectareas: ${result['Hectareas'] ?? "N/A"}\n\n'
                                    'KGXHA: ${result['KGXHA'].toStringAsFixed(2)}\n\n'
                                    'Libras Total: ${result['LibrasTotal'].toStringAsFixed(2)}\n\n'
                                    'LibrasXHA: ${(result['LibrasTotal'] / 11.19).toStringAsFixed(2)}\n\n'
                                    'Peso: ${result['Peso'] ?? "N/A"}\n\n'
                                    'Rendimiento: ${result['Rendimiento'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize:
                                            14), // Puedes ajustar el tamaño de la fuente aquí
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getBarValue(Map<String, dynamic> data) {
    switch (selectedValue) {
      case 'KGXHA':
        return double.parse(data['KGXHA'].toStringAsFixed(2));
      case 'LibrasTotal':
        return double.parse(data['LibrasTotal'].toStringAsFixed(2));
      case 'LibrasXHA':
        return double.parse((data['LibrasTotal'] / 11.19).toStringAsFixed(2));
      case 'Error2':
        return double.parse(data['Error2'].toStringAsFixed(2));
      default:
        return double.parse(data['Consumo'].toStringAsFixed(2));
    }
  }

  double _getMaxY() {
    if (resut_.isEmpty) {
      return 0;
    }
    double maxValue = resut_
        .map((data) => _getBarValue(data))
        .reduce((value, element) => value > element ? value : element);
    return maxValue * 1.2;
  }
}
