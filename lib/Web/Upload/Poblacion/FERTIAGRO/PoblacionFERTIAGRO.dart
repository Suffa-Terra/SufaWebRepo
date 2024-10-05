import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PoblacionFERTIAGROScreen extends StatefulWidget {
  const PoblacionFERTIAGROScreen({Key? key}) : super(key: key);

  @override
  _PoblacionFERTIAGROScreenState createState() => _PoblacionFERTIAGROScreenState();
}

class _PoblacionFERTIAGROScreenState extends State<PoblacionFERTIAGROScreen> {
  List<Map<String, String>> rows = [];
  final databaseReference = FirebaseDatabase.instance
      .ref("Empresas/TerrawaSufalyng/Terrain/FERTIAGRO/");

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black54, // Borde aleatorio pastel
                ),
                borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Table(
                  border: TableBorder.all(),
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(170, 215, 215, 215),
                      ),
                      children: [
                        TableCell(
                          child: Center(
                            child: Text(
                              'Hectáreas',
                              style: TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              'Piscinas',
                              style: TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              'Acciones',
                              style: TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (int i = 0; i < rows.length; i++)
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value) {
                                  rows[i]['Hectareas'] = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Hectareas',
                                ),
                                controller: TextEditingController(
                                    text: rows[i]['Hectareas']),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value) {
                                  rows[i]['Piscinas'] = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Piscinas',
                                ),
                                controller: TextEditingController(
                                    text: rows[i]['Piscinas']),
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
