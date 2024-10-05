import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TERRAINTIERRAVIDScreen extends StatefulWidget {
  const TERRAINTIERRAVIDScreen({Key? key}) : super(key: key);

  @override
  _TERRAINTIERRAVIDScreenState createState() => _TERRAINTIERRAVIDScreenState();
}

class _TERRAINTIERRAVIDScreenState extends State<TERRAINTIERRAVIDScreen> {
  List<Map<String, String>> rows = [];
  final databaseReference = FirebaseDatabase.instance
      .ref("Empresas/TerrawaSufalyng/Terrain/TIERRAVID/");

  int currentPageTIERRAVID = 0;
  final int itemsPerPageTIERRAVID = 5;

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

  List<Map<String, String>> getCurrentPageTIERRAVIDItems() {
    int start = currentPageTIERRAVID * itemsPerPageTIERRAVID;
    int end = start + itemsPerPageTIERRAVID;
    return rows.sublist(start, end > rows.length ? rows.length : end);
  }

  void nextPage() {
    if ((currentPageTIERRAVID + 1) * itemsPerPageTIERRAVID < rows.length) {
      setState(() {
        currentPageTIERRAVID++;
      });
    }
  }

  void previousPage() {
    if (currentPageTIERRAVID > 0) {
      setState(() {
        currentPageTIERRAVID--;
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
                    colors: [Color(0xfff5ede3), Color(0xfff6f2f0)],
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
                          i < getCurrentPageTIERRAVIDItems().length;
                          i++)
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    (currentPageTIERRAVID *
                                                itemsPerPageTIERRAVID +
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
                                            currentPageTIERRAVID *
                                                itemsPerPageTIERRAVID]
                                        ['Hectareas'] = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Hectareas',
                                  ),
                                  controller: TextEditingController(
                                      text: getCurrentPageTIERRAVIDItems()[i]
                                          ['Hectareas']),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (value) {
                                    rows[i +
                                            currentPageTIERRAVID *
                                                itemsPerPageTIERRAVID]
                                        ['Piscinas'] = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Piscinas',
                                  ),
                                  controller: TextEditingController(
                                      text: getCurrentPageTIERRAVIDItems()[i]
                                          ['Piscinas']),
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
                  onPressed: currentPageTIERRAVID > 0 ? previousPage : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        currentPageTIERRAVID > 0 ? null : Colors.white,
                    backgroundColor:
                        currentPageTIERRAVID > 0 ? null : Colors.red,
                  ),
                  child: const Text('Anterior'),
                ),
                Text(
                  'Página ${currentPageTIERRAVID + 1}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ), // Mostrar número de página
                ElevatedButton(
                  onPressed:
                      (currentPageTIERRAVID + 1) * itemsPerPageTIERRAVID <
                              rows.length
                          ? nextPage
                          : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        (currentPageTIERRAVID + 1) * itemsPerPageTIERRAVID <
                                rows.length
                            ? null
                            : Colors.white,
                    backgroundColor:
                        (currentPageTIERRAVID + 1) * itemsPerPageTIERRAVID <
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
