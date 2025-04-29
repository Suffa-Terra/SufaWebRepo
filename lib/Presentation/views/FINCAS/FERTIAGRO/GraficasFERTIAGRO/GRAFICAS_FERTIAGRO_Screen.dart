// ignore_for_file: unused_local_variable, unnecessary_null_comparison, unused_import, camel_case_types

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

class GRAFICAS_FERTIAGRO_Screen extends StatefulWidget {
  const GRAFICAS_FERTIAGRO_Screen({Key? key}) : super(key: key);

  @override
  _GRAFICAS_FERTIAGRO_ScreenState createState() =>
      _GRAFICAS_FERTIAGRO_ScreenState();
}

class _GRAFICAS_FERTIAGRO_ScreenState extends State<GRAFICAS_FERTIAGRO_Screen> {
  final databaseReference = FirebaseDatabase.instance
      .ref("Empresas/TerrawaSufalyng/Result/Dato/FERTIAGRO");

  List<Map<String, dynamic>> resut_ = [];
  String selectedValue =
      'Consumo'; // Valor por defecto para mostrar en la gráfica
  Map<int, Color> barColors = {};

  @override
  void initState() {
    super.initState();
    listenForUpdates();
  }

  void listenForUpdates() {
    databaseReference.onValue.listen((DatabaseEvent snapshot) {
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
            'AnimalesM': (value['AnimalesM']?.toDouble() ?? 0),
            'Peso': (value['Peso']?.toDouble() ?? 0),
            'Hectareas': (value['Hectareas']?.toString() ?? 0),
            'FechaHora': (value['FechaHora'] != null
                ? DateTime.tryParse(value['FechaHora'].toString())
                : null),
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
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  // Ajustar la relación de aspecto según el tamaño de la pantalla
                  aspectRatio: isTablet ? 1.7 : 1.2,
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
                              width: isTablet
                                  ? 30
                                  : 20, // Ajusta el ancho de las barras
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
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
                                  'Pisc ${resut_[value.toInt()]['Piscina']}',
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
              const SizedBox(height: 10),
              // Botones para seleccionar el tipo de datos
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xfff3ece7), Color(0xffe9f0f0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              bottomLeft: Radius.circular(40.0),
                            ), // Opcional: bordes redondeados
                            boxShadow: [
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Hacer el fondo transparente
                              shadowColor:
                                  Colors.transparent, // Eliminar la sombra
                            ),
                            onPressed: () {
                              setState(() {
                                selectedValue = 'KGXHA';
                              });
                            },
                            child: const Text('KGXHA'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xfff3ece7), Color(0xffe9f0f0)],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                            ), // Opcional: bordes redondeados
                            boxShadow: [
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Hacer el fondo transparente
                              shadowColor:
                                  Colors.transparent, // Eliminar la sombra
                            ),
                            onPressed: () {
                              setState(() {
                                selectedValue = 'LibrasTotal';
                              });
                            },
                            child: const Text('LibrasTotal'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xfff3ece7), Color(0xffe9f0f0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              bottomLeft: Radius.circular(40.0),
                            ), // Opcional: bordes redondeados
                            boxShadow: [
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Hacer el fondo transparente
                              shadowColor:
                                  Colors.transparent, // Eliminar la sombra
                            ),
                            onPressed: () {
                              setState(() {
                                selectedValue = 'LibrasXHA';
                              });
                            },
                            child: const Text('LibrasXHA'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xfff3ece7), Color(0xffe9f0f0)],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                            ), // Opcional: bordes redondeados
                            boxShadow: [
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Hacer el fondo transparente
                              shadowColor:
                                  Colors.transparent, // Eliminar la sombra
                            ),
                            onPressed: () {
                              setState(() {
                                selectedValue = 'Error2';
                              });
                            },
                            child: const Text('Error2'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 2 : 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: isTablet
                        ? 1.5
                        : 1, // Ajustar la relación de aspecto para pantallas pequeñas
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: resut_.length,
                  itemBuilder: (context, index) {
                    var result = resut_[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: barColors[index],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(10, 10),
                                color: Color.fromARGB(80, 0, 0, 0),
                                blurRadius: 5,
                              ),
                              BoxShadow(
                                offset: Offset(-10, -10),
                                color: Color.fromARGB(150, 255, 255, 255),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'FechaHora: ${result['FechaHora'] ?? "N/A"}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Hectareas: ${result['Hectareas'] ?? "N/A"}'),
                                            const SizedBox(height: 5),
                                            Text(
                                                'Consumo: ${result['Consumo'].toStringAsFixed(2)}'),
                                            const SizedBox(height: 5),
                                            Text(
                                                'Peso: ${result['Peso'] ?? "N/A"}'),
                                            const SizedBox(height: 5),
                                            Text(
                                                'Rendimiento: ${result['Rendimiento'].toStringAsFixed(2)}'),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'KGXHA: ${result['KGXHA'].toStringAsFixed(2)}'),
                                            const SizedBox(height: 5),
                                            Text(
                                                'Libras Total: ${result['LibrasTotal'].toStringAsFixed(2)}'),
                                            const SizedBox(height: 5),
                                            Text(
                                                'LibrasXHA: ${(result['LibrasTotal'] / 11.19).toStringAsFixed(2)}'),
                                            const SizedBox(height: 5),
                                            Text(
                                                'Error2: ${result['Error2'].toStringAsFixed(2)}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'AnimalesM: ${result['AnimalesM']?.toStringAsFixed(2) ?? "N/A"}'),
                                ),
                              ],
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
