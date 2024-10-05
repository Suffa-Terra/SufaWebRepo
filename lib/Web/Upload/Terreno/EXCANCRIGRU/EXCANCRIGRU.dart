import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TERRAINEXCANCRIGRUScreen extends StatefulWidget {
  const TERRAINEXCANCRIGRUScreen({Key? key}) : super(key: key);

  @override
  _TERRAINEXCANCRIGRUScreenState createState() => _TERRAINEXCANCRIGRUScreenState();
}

class _TERRAINEXCANCRIGRUScreenState extends State<TERRAINEXCANCRIGRUScreen> {
  List<Map<String, String>> rows = [];
  final databaseReference = FirebaseDatabase.instance
      .ref("Empresas/TerrawaSufalyng/Terrain/EXCANCRIGRU/");
  int currentPageEXCANCRIGRU = 0;
  final int itemsPerPageEXCANCRIGRU = 5;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void addRow() {
    setState(() {
      rows.add({'Piscinas': '', 'Hectareas': ''});
    });
  }

  void removeRow(int index) {
    setState(() {
      rows.removeAt(index);
    });
  }

  List<Map<String, String>> getCurrentPageEXCANCRIGRUItems() {
    int start = currentPageEXCANCRIGRU * itemsPerPageEXCANCRIGRU;
    int end = start + itemsPerPageEXCANCRIGRU;
    return rows.sublist(start, end > rows.length ? rows.length : end);
  }

  void nextPage() {
    if ((currentPageEXCANCRIGRU + 1) * itemsPerPageEXCANCRIGRU < rows.length) {
      setState(() {
        currentPageEXCANCRIGRU++;
      });
    }
  }

  void previousPage() {
    if (currentPageEXCANCRIGRU > 0) {
      setState(() {
        currentPageEXCANCRIGRU--;
      });
    }
  }

  void loadData() async {
    final snapshot = await databaseReference.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final loadedRows = (data['rows'] as List<dynamic>)
          .map((item) => Map<String, String>.from(item))
          .toList();
      setState(() {
        rows = loadedRows;
      });
    }
  }

  Future<void> saveData() async {
    final Map<String, Map<String, String>> data = {};
    for (int i = 0; i < rows.length; i++) {
      data[i.toString()] = {
        'Hectareas': rows[i]['Hectareas'] ?? '',
        'Piscinas': rows[i]['Piscinas'] ?? '',
      };
    }
    await databaseReference.set(data);
    print('Datos guardados correctamente');
  }

  Widget _buildTextField(String label, int index) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: rows[index][label],
              onChanged: (value) {
                setState(() {
                  rows[index][label] = value;
                });
              },
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => removeRow(index),
        color: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff4f4f4), Color(0xfff4f4f4)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffe2d7d4),
                      Color.fromARGB(255, 255, 251, 236)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                  ),
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
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.transparent,
                    ),
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'N°',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Hectáreas',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Piscinas',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Acciones',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0;
                          i < getCurrentPageEXCANCRIGRUItems().length;
                          i++)
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    (currentPageEXCANCRIGRU *
                                                itemsPerPageEXCANCRIGRU +
                                            i +
                                            1)
                                        .toString(), // Contador de filas
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (value) {
                                    rows[i +
                                            currentPageEXCANCRIGRU *
                                                itemsPerPageEXCANCRIGRU]
                                        ['Hectareas'] = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Hectareas',
                                  ),
                                  controller: TextEditingController(
                                      text: getCurrentPageEXCANCRIGRUItems()[i]
                                          ['Hectareas']),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: TextField(
                                    onChanged: (value) {
                                      rows[i +
                                              currentPageEXCANCRIGRU *
                                                  itemsPerPageEXCANCRIGRU]
                                          ['Piscinas'] = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Piscinas',
                                    ),
                                    controller: TextEditingController(
                                        text:
                                            getCurrentPageEXCANCRIGRUItems()[i]
                                                ['Piscinas']),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    removeRow(i);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: currentPageEXCANCRIGRU > 0 ? previousPage : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        currentPageEXCANCRIGRU > 0 ? null : Colors.white,
                    backgroundColor:
                        currentPageEXCANCRIGRU > 0 ? null : Colors.red,
                  ),
                  child: const Text('Anterior'),
                ),
                Text(
                  'Página ${currentPageEXCANCRIGRU + 1}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ), // Mostrar número de página
                ElevatedButton(
                  onPressed:
                      (currentPageEXCANCRIGRU + 1) * itemsPerPageEXCANCRIGRU <
                              rows.length
                          ? nextPage
                          : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        (currentPageEXCANCRIGRU + 1) * itemsPerPageEXCANCRIGRU <
                                rows.length
                            ? null
                            : Colors.white,
                    backgroundColor:
                        (currentPageEXCANCRIGRU + 1) * itemsPerPageEXCANCRIGRU <
                                rows.length
                            ? null
                            : Colors.red,
                  ),
                  child: const Text('Siguiente'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: addRow,
            tooltip: 'Agregar Fila',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: saveData,
            tooltip: 'Guardar',
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
