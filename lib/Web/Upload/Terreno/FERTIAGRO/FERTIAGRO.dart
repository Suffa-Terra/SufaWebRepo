import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TERRAINFERTIAGROScreen extends StatefulWidget {
  const TERRAINFERTIAGROScreen({Key? key}) : super(key: key);

  @override
  _TERRAINFERTIAGROScreenState createState() => _TERRAINFERTIAGROScreenState();
}

class _TERRAINFERTIAGROScreenState extends State<TERRAINFERTIAGROScreen> {
  List<Map<String, String>> rows = [];
  final databaseReference = FirebaseDatabase.instance
      .ref("Empresas/TerrawaSufalyng/Terrain/FERTIAGRO/");
  int currentPageFERTIAGRO = 0;
  final int itemsPerPageFERTIAGRO = 5;

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

  List<Map<String, String>> getCurrentPageFERTIAGROItems() {
    int start = currentPageFERTIAGRO * itemsPerPageFERTIAGRO;
    int end = start + itemsPerPageFERTIAGRO;
    return rows.sublist(start, end > rows.length ? rows.length : end);
  }

  void nextPage() {
    if ((currentPageFERTIAGRO + 1) * itemsPerPageFERTIAGRO < rows.length) {
      setState(() {
        currentPageFERTIAGRO++;
      });
    }
  }

  void previousPage() {
    if (currentPageFERTIAGRO > 0) {
      setState(() {
        currentPageFERTIAGRO--;
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
                      Color(0xffffffff),
                      Color.fromARGB(255, 163, 172, 173)
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
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
                  borderRadius: BorderRadius.circular(12.0),
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
                          i < getCurrentPageFERTIAGROItems().length;
                          i++)
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    (currentPageFERTIAGRO *
                                                itemsPerPageFERTIAGRO +
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
                                child: Center(
                                  child: TextField(
                                    onChanged: (value) {
                                      rows[i +
                                              currentPageFERTIAGRO *
                                                  itemsPerPageFERTIAGRO]
                                          ['Hectareas'] = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Hectareas',
                                    ),
                                    controller: TextEditingController(
                                        text: getCurrentPageFERTIAGROItems()[i]
                                            ['Hectareas']),
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
                                            currentPageFERTIAGRO *
                                                itemsPerPageFERTIAGRO]
                                        ['Piscinas'] = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Piscinas',
                                  ),
                                  controller: TextEditingController(
                                      text: getCurrentPageFERTIAGROItems()[i]
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
                  onPressed: currentPageFERTIAGRO > 0 ? previousPage : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        currentPageFERTIAGRO > 0 ? null : Colors.white,
                    backgroundColor:
                        currentPageFERTIAGRO > 0 ? null : Colors.red,
                  ),
                  child: const Text('Anterior'),
                ),
                Text(
                  'Página ${currentPageFERTIAGRO + 1}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ), // Mostrar número de página
                ElevatedButton(
                  onPressed:
                      (currentPageFERTIAGRO + 1) * itemsPerPageFERTIAGRO <
                              rows.length
                          ? nextPage
                          : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        (currentPageFERTIAGRO + 1) * itemsPerPageFERTIAGRO <
                                rows.length
                            ? null
                            : Colors.white,
                    backgroundColor:
                        (currentPageFERTIAGRO + 1) * itemsPerPageFERTIAGRO <
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
