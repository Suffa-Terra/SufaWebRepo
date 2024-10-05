import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RendimientoScreen extends StatefulWidget {
  const RendimientoScreen({Key? key}) : super(key: key);

  @override
  _RendimientoScreenState createState() => _RendimientoScreenState();
}

class _RendimientoScreenState extends State<RendimientoScreen> {
  List<Map<String, String>> rows = [];
  final databaseReference =
      FirebaseDatabase.instance.ref("Empresas/TerrawaSufalyng/Rendimiento");
  int currentPage = 0;
  final int itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    loadData();
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

  void saveData() async {
    await databaseReference.set({
      'rows': rows,
    });
    print('Datos guardados correctamente');
  }

  void addRow() {
    setState(() {
      rows.add({'Gramos': '', 'Rendimiento': ''});
    });
  }

  void removeRow(int index) {
    setState(() {
      rows.removeAt(index);
    });
  }

  List<Map<String, String>> getCurrentPageItems() {
    int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;
    return rows.sublist(start, end > rows.length ? rows.length : end);
  }

  void nextPage() {
    if ((currentPage + 1) * itemsPerPage < rows.length) {
      setState(() {
        currentPage++;
      });
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
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
                    colors: [Color(0xfff3ece7), Color(0xffe9f0f0)],
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
                                  'Gramos',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
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
                                  'Rendimiento',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < getCurrentPageItems().length; i++)
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    (currentPage * itemsPerPage + i + 1)
                                        .toString(), // Contador de filas
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
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
                                      rows[i + currentPage * itemsPerPage]
                                          ['Gramos'] = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Gramos',
                                    ),
                                    controller: TextEditingController(
                                        text: getCurrentPageItems()[i]
                                            ['Gramos']),
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
                                      rows[i + currentPage * itemsPerPage]
                                          ['Rendimiento'] = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Rendimiento',
                                    ),
                                    controller: TextEditingController(
                                        text: getCurrentPageItems()[i]
                                            ['Rendimiento']),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      removeRow(i + currentPage * itemsPerPage);
                                    },
                                  ),
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
                  onPressed: currentPage > 0 ? previousPage : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: currentPage > 0 ? null : Colors.white,
                    backgroundColor: currentPage > 0 ? null : Colors.red,
                  ),
                  child: const Text('Anterior'),
                ),
                Text('Página ${currentPage + 1}'), // Mostrar número de página
                ElevatedButton(
                  onPressed: (currentPage + 1) * itemsPerPage < rows.length
                      ? nextPage
                      : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        (currentPage + 1) * itemsPerPage < rows.length
                            ? null
                            : Colors.white,
                    backgroundColor:
                        (currentPage + 1) * itemsPerPage < rows.length
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
