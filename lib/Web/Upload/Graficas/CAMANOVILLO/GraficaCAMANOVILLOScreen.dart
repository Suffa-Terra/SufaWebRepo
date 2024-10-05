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
            'Piscina': value['Piscinas'] ??
                'Desconocida', // Obtener el número de la piscina
            'Consumo': (value['Consumo'] ?? 0).toDouble(),
            'Rendimiento': (value['Rendimiento'] ?? 0).toDouble(),
            'LibrasTotal': (value['LibrasTotal']?.toDouble() ?? 0),
            'KGXHA': (value['KGXHA']?.toDouble() ?? 0),
            'Error2': (value['Error2']?.toDouble() ?? 0),
          };
        }).toList();

        setState(() {
          resut_ =
              resultList.take(5).toList(); // Solo tomar los 5 más recientes
          // Colores pastel
          List<Color> pastelColors = [
            const Color(0xffaec6cf), // Azul pastel
            const Color(0xffffb3ba), // Rosa pastel
            const Color(0xffc6e2ff), // Lavanda pastel
            const Color(0xffd3ffce), // Verde pastel
            const Color(0xffffd1dc), // Coral pastel
          ];
          barColors = {
            for (int i = 0; i < resut_.length; i++)
              i: pastelColors[i % pastelColors.length]
          };
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff4f4f4), Color(0xfff4f4f4)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
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
                              color:
                                  Colors.transparent, // o el color que prefieras
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
              const SizedBox(height: 20),
              Row(
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
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: resut_.length,
                  itemBuilder: (context, index) {
                    var result = resut_[index];
                    return Card(
                      elevation: 4,
                      color: barColors[index],
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Piscina: ${result['Piscina']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('KGXHA: ${result['KGXHA'].toStringAsFixed(2)}'),
                            Text(
                                'Libras Total: ${result['LibrasTotal'].toStringAsFixed(2)}'),
                            Text(
                                'LibrasXHA: ${(result['LibrasTotal'] / 11.19).toStringAsFixed(2)}'),
                            Text(
                                'Error2: ${result['Error2'].toStringAsFixed(2)}'),
                            Text(
                                'Consumo: ${result['Consumo'].toStringAsFixed(2)}'),
                            Text(
                                'Rendimiento: ${result['Rendimiento'].toStringAsFixed(2)}'),
                          ],
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
      return 0; // Valor por defecto si no hay datos
    }
    double maxValue = resut_
        .map((data) => _getBarValue(data))
        .reduce((value, element) => value > element ? value : element);
    return maxValue * 1.2;
  }
}
