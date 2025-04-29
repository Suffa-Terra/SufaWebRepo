// ignore_for_file: unnecessary_null_comparison, unused_local_variable, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sufaweb/env_loader.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DatoCAMANOVILLO_Screen extends StatefulWidget {
  const DatoCAMANOVILLO_Screen({Key? key}) : super(key: key);

  @override
  _DatoCAMANOVILLO_ScreenState createState() => _DatoCAMANOVILLO_ScreenState();
}

class _DatoCAMANOVILLO_ScreenState extends State<DatoCAMANOVILLO_Screen> {
  bool _showResults_CAMANOVILLO = false;
  final ScrollController _scrollController_CAMANOVILLO = ScrollController();
  String? selectedHectareas;
  String? selectedPiscinas;
  String? selectedGramos;

  List<Map<String, dynamic>> CAMANOVILLOData = [];
  List<Map<String, dynamic>> rendimientoData = [];

  List<String> piscinasOptions_CAMANOVILLO = [];
  Map<String, dynamic>? selectedTerreno;

  final DatabaseReference _CAMANOVILLORef =
      FirebaseDatabase.instance.ref(EnvLoader.get('CAMANOVILLO_ROWS')!);

  final DatabaseReference _rendimientoRef =
      FirebaseDatabase.instance.ref(EnvLoader.get('RENDIMIENTO_ROWS')!);

  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _consumoController = TextEditingController();
  final TextEditingController _piscinasController = TextEditingController();
  final TextEditingController _gramosController = TextEditingController();
  final TextEditingController _HectareasController = TextEditingController();
  // Define un TextEditingController en tu clase de estado
  final TextEditingController _kgXHaController = TextEditingController();
  final TextEditingController _RendimientoController = TextEditingController();
  final TextEditingController _LibrasXHaController = TextEditingController();
  final TextEditingController _LibrasTotalController = TextEditingController();
  final TextEditingController _calculateAnimalesMController =
      TextEditingController();
  final TextEditingController _calculateError2Controller =
      TextEditingController();
  List<String> _hectareasPiscinas = [];
  String _selectedFinca = 'CAMANOVILLO';
  int _currentPage = 0;
  final int _itemsPerPage = 6;

  Timer? _timerDATO;

  void _addListeners() {
    _HectareasController.addListener(_updateCalculations);
    _piscinasController.addListener(_updateCalculations);
    _gramosController.addListener(_updateCalculations);
    _consumoController.addListener(_updateCalculations);
  }

  void _updateCalculations() {}

  void _fetchData() async {
    try {
      final CAMANOVILLOSnapshot = await _CAMANOVILLORef.get();
      final rendimientoSnapshot = await _rendimientoRef.get();

      if (CAMANOVILLOSnapshot.exists) {
        setState(() {
          if (CAMANOVILLOSnapshot.value is List) {
            CAMANOVILLOData = (CAMANOVILLOSnapshot.value as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
          } else if (CAMANOVILLOSnapshot.value is Map) {
            CAMANOVILLOData = (CAMANOVILLOSnapshot.value as Map)
                .values
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
          }

          // Rellena las listas de opciones para el Dropdown de Piscinas
          piscinasOptions_CAMANOVILLO =
              CAMANOVILLOData.map((e) => e['Piscinas'].toString()).toList();
          if (piscinasOptions_CAMANOVILLO.isNotEmpty) {
            selectedPiscinas = piscinasOptions_CAMANOVILLO.first;
            _updateHectareasForPiscina(selectedPiscinas!);
          }
        });
      }

      if (rendimientoSnapshot.exists) {
        setState(() {
          if (rendimientoSnapshot.value is List) {
            rendimientoData = (rendimientoSnapshot.value as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
          } else if (rendimientoSnapshot.value is Map) {
            rendimientoData = (rendimientoSnapshot.value as Map)
                .values
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
          }
        });
      }
    } catch (e) {
      print('Error al cargar datos: $e');
    }
  }

  void _updateHectareasForPiscina(String piscina) {
    final matchingPiscina = CAMANOVILLOData.firstWhere(
      (element) => element['Piscinas'].toString() == piscina,
      orElse: () => <String, dynamic>{},
    );

    if (matchingPiscina.isNotEmpty) {
      selectedHectareas = matchingPiscina['Hectareas'].toString();
      _HectareasController.text = selectedHectareas!;
    } else {
      selectedHectareas = null;
      _HectareasController.clear();
    }
    // Aquí llama a las funciones de cálculo
    _calculateKgXHa();
    _calculateLibrasXHa();
    _calculateLibrasTotal();
    _calculateError2();
    _calculateAnimalesM();
  }

  void _addData() {
    // Validar selección de terreno
    if (selectedTerreno == null) {
      _showSnackBar('Por favor, seleccione la Hectárea y Piscina.');
      return;
    }

    // Validar selección de piscina
    if (_getHectareas() == null) {
      _showSnackBar('Debe seleccionar una opción en el ComboBox de Terreno.');
      return;
    }

    // Validar campo de peso
    if (_pesoController.text.isEmpty) {
      _showSnackBar('Por favor, complete el campo Peso.');
      return;
    }

    // Validar campo de consumo
    if (_consumoController.text.isEmpty) {
      _showSnackBar('Por favor, complete el campo Consumo.');
      return;
    }

    // Reemplazar comas por puntos y validar los datos
    final pesoString = _pesoController.text.replaceAll(',', '.');
    final consumoString = _consumoController.text.replaceAll(',', '.');

    final peso = double.tryParse(pesoString);
    final consumo = double.tryParse(consumoString);

    if (peso == null || consumo == null) {
      _showSnackBar('Peso y Consumo deben ser valores numéricos válidos.');
      return;
    }

    final newData = {
      'Peso': peso,
      'Consumo': consumo,
      'Entero': peso.toInt(),
    };

    CAMANOVILLOData.add(newData);
    _calculateAndUpload(peso, consumo);
    _calculateKgXHa();
    _calculateLibrasXHa();
    _calculateLibrasTotal();
    _calculateError2();
    _calculateAnimalesM();

    setState(() {
      _showResults_CAMANOVILLO = !_showResults_CAMANOVILLO;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_showResults_CAMANOVILLO) {
        _scrollController_CAMANOVILLO.animateTo(
          _scrollController_CAMANOVILLO.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

// Función para mostrar mensajes con SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 43, 43),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _calculateAndUpload(double peso, double consumo) {
    // Calcula el peso y consumo totales
    double totalPeso = peso;
    double totalConsumo = consumo;

    // Convierte totalPeso a entero sin decimales para la comparación
    final entero = totalPeso.toInt();

    // Obtiene el rendimiento basado en el peso total
    final rendimiento = _getRendimiento(entero);

    // Calcula kgXHa, librasXHa, librasTotal, error2, y animalesM
    final kgXHa =
        (totalConsumo) / (double.tryParse(selectedHectareas ?? '1') ?? 1);
    final librasXHa = kgXHa * (rendimiento / 100) * 100;
    final librasTotal =
        (double.tryParse(selectedHectareas ?? '1') ?? 1) * librasXHa;
    final error2 = librasTotal * 0.98;
    final animalesM = ((librasXHa * 454) / totalPeso) / 10000;

    // Obtén la fecha y hora actual formateada como yyyy-MM-dd HH
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH').format(now);

    // Crea un mapa con los datos calculados para subir a Firebase
    final newData = {
      'Piscinas': selectedPiscinas,
      'Hectareas': selectedHectareas,
      'FechaHora': formattedDate,
      'Peso': totalPeso,
      'Consumo': totalConsumo,
      'Gramos': totalPeso,
      'KGXHA': kgXHa,
      'Rendimiento': rendimiento,
      'LibrasTotal': librasTotal,
      'Error2': error2,
      'LibrasXHA': librasXHa,
      'AnimalesM': animalesM,
      'Finca': 'CAMANOVILLO',
    };

    // Sube los datos calculados a la base de datos de Firebase
    final resultRef = FirebaseDatabase.instance
        .ref('${EnvLoader.get('RESULT_DATO_BASE')}/$_selectedFinca');
    resultRef.push().set(newData);

    // Actualiza el estado con los resultados
    setState(() {
      // Aquí actualiza cualquier otra cosa que necesites
    });
  }

  int _getRendimiento(int entero) {
    final matchingElement = rendimientoData.firstWhere(
      (element) =>
          element.containsKey('Gramos') &&
          element['Gramos'] != null &&
          int.tryParse(element['Gramos'].toString()) == entero,
      orElse: () => <String,
          dynamic>{}, // Devuelve un Map vacío como valor predeterminado
    );

    if (matchingElement.isEmpty) {
      return 0; // o cualquier valor predeterminado apropiado
    }

    final rendimiento =
        int.tryParse(matchingElement['Rendimiento'].toString()) ?? 0;
    _RendimientoController.text = rendimiento.toString();
    return rendimiento;
  }

  // coach mark
  final GlobalKey _SelectPiscDATO = GlobalKey();
  final GlobalKey _BeforeDATO = GlobalKey();
  final GlobalKey _AfterDATO = GlobalKey();
  final GlobalKey _ConsumoDATO = GlobalKey();
  final GlobalKey _PesoAdmin = GlobalKey();
  final GlobalKey _calcularbuttonDATO = GlobalKey();
  final GlobalKey _resetTutorialDATO = GlobalKey();
  TutorialCoachMark? tutorialCoachMarkDATO;

  @override
  void dispose() {
    _HectareasController.dispose();
    _piscinasController.dispose();
    _pesoController.dispose();
    _consumoController.dispose();
    _timerDATO?.cancel(); // Cancela el timer si está activo
    tutorialCoachMarkDATO?.finish();
    _RendimientoController.dispose();
    super.dispose();
  }

  String get tutorial_mostrado_CAMANOVILLO_DATO =>
      "tutorial_mostrado_CAMANOVILLO_DATO";

  // Verifica si el tutorial ya fue mostrado
  Future<bool> _shouldShowTutorialDATO() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(tutorial_mostrado_CAMANOVILLO_DATO) ??
        true; // Si no existe, se muestra
  }

// Guarda que el tutorial ya se mostró
  Future<void> _setTutorialShownDATO() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorial_mostrado_CAMANOVILLO_DATO, false);
  }

// Restablece el tutorial desde ajustes si el usuario lo quiere repetir
  Future<void> resetTutorialDATO() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorial_mostrado_CAMANOVILLO_DATO, true);
  }

  // Muestra el tutorial solo si no se ha mostrado antes
  void showTutorialDATO() async {
    if (await _shouldShowTutorialDATO()) {
      tutorialCoachMarkDATO = TutorialCoachMark(
        targets: _initTargetsDATO,
        colorShadow: Colors.black87,
        paddingFocus: 0.01,
        showSkipInLastTarget: true,
        initialFocus: 0,
        useSafeArea: true,
        textSkip: "Saltar",
        focusAnimationDuration: const Duration(milliseconds: 500),
        unFocusAnimationDuration: const Duration(milliseconds: 500),
        pulseAnimationDuration: const Duration(milliseconds: 500),
        pulseEnable: true,
        onFinish: () {
          _setTutorialShownDATO(); // Guarda que ya se mostró
        },
        onClickTarget: (target) {
          print("Clicked on target: ${target.identify}");
        },
        onClickOverlay: (target) {
          print("Overlay clicked");
        },
      )..show(context: context);
    }
  }

  final List<TargetFocus> _initTargetsDATO = [];

  @override
  void initState() {
    super.initState();
    _initTargetsDATO.add(
      TargetFocus(
        identify: "SelectPiscina",
        keyTarget: _SelectPiscDATO,
        alignSkip: Alignment.bottomRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Configura tu terreno",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Selecciona las hectáreas y la cantidad de alimento en gramos para obtener el mejor rendimiento.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsDATO.add(
      TargetFocus(
        identify: "Before",
        keyTarget: _BeforeDATO,
        alignSkip: Alignment.bottomRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Retroceder Pagina",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Da click para retroceder a la página anterior. "
                    "Si no deseas retroceder, puedes omitir este paso.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsDATO.add(
      TargetFocus(
        identify: "After",
        keyTarget: _AfterDATO,
        alignSkip: Alignment.bottomRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Avanzar Pagina",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Da click para avanzar a la página siguiente. "
                    "Si no deseas avanzar, puedes omitir este paso.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsDATO.add(
      TargetFocus(
        identify: "Peso",
        keyTarget: _PesoAdmin,
        alignSkip: Alignment.bottomRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Peso del camarón",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Indica el peso promedio del camarón en gramos para afinar los cálculos.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsDATO.add(
      TargetFocus(
        identify: "Consumo",
        keyTarget: _ConsumoDATO,
        alignSkip: Alignment.bottomRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Consumo diario",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Ingresa la cantidad de alimento consumido en gramos para realizar un cálculo preciso.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsDATO.add(
      TargetFocus(
        identify: "Calcular",
        keyTarget: _calcularbuttonDATO,
        alignSkip: Alignment.topCenter,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "¡Hora de calcular!",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Presiona el botón para obtener los resultados y optimizar tu producción.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsDATO.add(
      TargetFocus(
        identify: "ResetTutorialDATO",
        keyTarget: _resetTutorialDATO,
        alignSkip: Alignment.topRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Reinicia el tutorial",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Si deseas volver a ver el tutorial, presiona este botón.",
                    style: TextStyle(
                      color: Color(0xfff3ece7),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // Asegurar que el tutorial se inicie después de que el widget esté construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timerDATO = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          showTutorialDATO();
        }
      });
    });
    _loadHectareasPiscinas(_selectedFinca);
    _fetchData();
    _pesoController.addListener(() {
      setState(() {
        selectedGramos = _pesoController.text;
      });
    });
    _addListeners();
    final entero = double.tryParse(_pesoController.text)?.toInt() ?? 0;
    _getRendimiento(entero);
    // Establecer un valor por defecto para `selectedHectareas` si lo deseas
    if (CAMANOVILLOData.isNotEmpty) {
      final defaultHectareas =
          '${CAMANOVILLOData[0]['Hectareas']}_${CAMANOVILLOData[0]['Piscinas']}';
      selectedHectareas = defaultHectareas; // Establecer el valor por defecto
    }
    _HectareasController.addListener(() {
      setState(() {
        selectedHectareas = _HectareasController.text;
      });
    });
  }

  void _loadHectareasPiscinas(String finca) async {
    final snapshot = await _CAMANOVILLORef.get();
    if (snapshot.exists) {
      List<dynamic> rows = List<dynamic>.from(snapshot.value as List);

      setState(() {
        _hectareasPiscinas = rows.map((row) {
          String hectareas = row["Hectareas"].toString().trim();
          String piscinas = row["Piscinas"].toString().trim();
          String piscinasNumero = piscinas.replaceAll(
              RegExp(r'[^0-9.]'), ''); // Extrae solo números y puntos
          return "Hect: $hectareas - Pisc: $piscinasNumero"; // Mostrar sin texto extra
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final entero = double.tryParse(_pesoController.text)?.toInt() ?? 0;
    _gramosController.text = entero != null ? entero.toString() : 'N/A';
    final rendimiento = _getRendimiento(entero);
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: SingleChildScrollView(
        controller: _scrollController_CAMANOVILLO,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildHectSelect(
                    _hectareasPiscinas,
                    '${_HectareasController.text} - ${_piscinasController.text}',
                    'Seleccione Hectáreas y Piscinas',
                    'hectareas'),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Ingresar los datos:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 241, 238, 235),
                          Color.fromARGB(255, 241, 238, 235),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                      ), // Opcional: bordes redondeados
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(-10, 10),
                          color: Color.fromARGB(80, 0, 0, 0),
                          blurRadius: 10,
                        ),
                        BoxShadow(
                            offset: Offset(10, -10),
                            color: Color.fromARGB(147, 202, 202, 202),
                            blurRadius: 10),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Table(
                        border: const TableBorder(
                          horizontalInside:
                              BorderSide(color: Colors.transparent),
                          verticalInside: BorderSide(color: Colors.transparent),
                        ),
                        columnWidths: const {
                          0: FixedColumnWidth(120.0),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            children: [
                              const TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Peso:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        key: _PesoAdmin,
                                        child: TextField(
                                          controller: _pesoController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: 'Ingrese el Peso...',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 126, 53, 0),
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 126, 53, 0),
                                              ),
                                            ),
                                          ),
                                          style: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Tooltip(
                                        message: 'Peso en gramos (g)',
                                        child: Icon(
                                          Icons.info,
                                          color:
                                              Color.fromARGB(255, 176, 74, 11),
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Consumo:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        key: _ConsumoDATO,
                                        child: TextField(
                                          controller: _consumoController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: 'Ingrese el Consumo...',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 126, 53, 0),
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 126, 53, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Tooltip(
                                        message: 'Consumo en gramos (g)',
                                        child: Icon(
                                          Icons.info,
                                          color:
                                              Color.fromARGB(255, 176, 74, 11),
                                          size: 20,
                                        ),
                                      ),
                                    ],
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
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 176, 74, 11),
                        Color.fromARGB(255, 126, 53, 0),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(-5, 5),
                        color: Color.fromARGB(80, 0, 0, 0),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        offset: Offset(5, -5),
                        color: Color.fromARGB(150, 255, 255, 255),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: SizedBox(
                    child: ElevatedButton(
                      key: _calcularbuttonDATO,
                      onPressed: _addData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0), // Tamaño del botón
                      ),
                      child: const Text(
                        'Calcular',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xfff3ece7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _showResults_CAMANOVILLO
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              'Resultados:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 8,
                                margin: const EdgeInsets.all(10),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 241, 238, 235),
                                        Color.fromARGB(255, 241, 238, 235),
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(10, 10),
                                        color: Color.fromARGB(80, 0, 0, 0),
                                        blurRadius: 10,
                                      ),
                                      BoxShadow(
                                          offset: Offset(-10, -10),
                                          color: Color.fromARGB(
                                              147, 202, 202, 202),
                                          blurRadius: 10),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Table(
                                      border: const TableBorder(
                                        horizontalInside: BorderSide(
                                            color: Colors.transparent),
                                        verticalInside: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      columnWidths: const {
                                        0: FixedColumnWidth(120.0),
                                        1: FlexColumnWidth(),
                                      },
                                      children: [
                                        CustomTableRow(
                                            label: 'Hectareas',
                                            controller: _HectareasController,
                                            unit: 'ha'),
                                        CustomTableRow(
                                            label: 'Piscinas',
                                            controller: _piscinasController,
                                            unit: 'Pisc'),
                                        CustomTableRow(
                                            label: 'Gramos',
                                            controller: _gramosController,
                                            unit: 'g'),
                                        CustomTableRow(
                                            label: 'Rendimiento',
                                            controller: _RendimientoController,
                                            unit: 'R'),
                                        CustomTableRow(
                                            label: 'KGXHA',
                                            controller: _kgXHaController,
                                            unit: 'kg/ha'),
                                        CustomTableRow(
                                          label: 'LibrasTotal',
                                          controller: _LibrasTotalController,
                                          unit: 'lb',
                                        ),
                                        CustomTableRow(
                                          label: 'Error 2%',
                                          controller:
                                              _calculateError2Controller,
                                          unit: '%',
                                        ),
                                        CustomTableRow(
                                          label: 'LibrasXHA',
                                          controller: _LibrasXHaController,
                                          unit: 'lb/ha',
                                        ),
                                        CustomTableRow(
                                          label: 'AnimalesM',
                                          controller:
                                              _calculateAnimalesMController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Tooltip(
        key: _resetTutorialDATO,
        message: "Reactivar tutorial",
        height: 50,
        padding: const EdgeInsets.all(8.0),
        preferBelow: true,
        textStyle: const TextStyle(fontSize: 20),
        showDuration: const Duration(seconds: 2),
        waitDuration: const Duration(seconds: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(colors: <Color>[
            Color.fromARGB(255, 241, 238, 235),
            Color.fromARGB(255, 241, 238, 235),
          ]),
          boxShadow: const [
            BoxShadow(
              offset: Offset(-10, 10),
              color: Color.fromARGB(80, 0, 0, 0),
              blurRadius: 10,
            ),
            BoxShadow(
                offset: Offset(10, -10),
                color: Color.fromARGB(147, 202, 202, 202),
                blurRadius: 10),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await resetTutorialDATO();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Tutorial restablecido. Para verlo,"
                    " solo tienes que ir a otra interfaz y luego volver aquí."),
                duration: Duration(seconds: 2),
              ),
            );
          },
          backgroundColor:
              const Color.fromARGB(255, 126, 53, 0), // Color del botón
          child: const Icon(
            Icons.refresh,
            color: Color(0xfff3ece7),
          ), // Ícono de reinicio
        ),
      ),
    );
  }

  String _getHectareas() {
    // Extrae solo la parte numérica de hectáreas de "Hectareas_Piscinas"
    return selectedHectareas?.split('_')[0] ?? '1';
  }

  String _calculateKgXHa() {
    final consumo =
        double.tryParse(_consumoController.text.replaceAll(',', '.'));
    final hectareas =
        double.tryParse(_HectareasController.text.replaceAll(',', '.'));
    final result = (consumo != null && hectareas != null)
        ? (consumo / hectareas).toStringAsFixed(2)
        : 'N/A';
    _kgXHaController.text = result;

    return result;
  }

  String _calculateLibrasXHa() {
    final kgXHa = double.tryParse(_calculateKgXHa().replaceAll(',', '.'));
    final rendimiento = double.tryParse(
        _getRendimiento(double.tryParse(_pesoController.text)?.toInt() ?? 0)
            .toString());
    final result = (kgXHa != null && rendimiento != null)
        ? (kgXHa * (rendimiento / 100) * 100).toStringAsFixed(2)
        : 'N/A';
    _LibrasXHaController.text = result;
    return result;
  }

  String _calculateLibrasTotal() {
    final hectareas =
        double.tryParse(_HectareasController.text.replaceAll(',', '.'));
    final librasXHa =
        double.tryParse(_calculateLibrasXHa().replaceAll(',', '.'));
    final result = (hectareas != null && librasXHa != null)
        ? (hectareas * librasXHa).toStringAsFixed(2)
        : 'N/A';
    _LibrasTotalController.text = result;
    return result;
  }

  String _calculateError2() {
    final librasTotal =
        double.tryParse(_calculateLibrasTotal().replaceAll(',', '.'));
    final result =
        (librasTotal != null) ? (librasTotal * 0.98).toStringAsFixed(2) : 'N/A';
    _calculateError2Controller.text = result;
    return result;
  }

  String _calculateAnimalesM() {
    final librasXHa =
        double.tryParse(_calculateLibrasXHa().replaceAll(',', '.'));
    final peso = double.tryParse(_pesoController.text.replaceAll(',', '.'));
    final result = (librasXHa != null && peso != null)
        ? (((librasXHa * 454) / peso) / 10000).toStringAsFixed(2)
        : 'N/A';
    _calculateAnimalesMController.text = result;
    return result;
  }

  void _nextPage() {
    setState(() {
      if ((_currentPage + 1) * _itemsPerPage < _hectareasPiscinas.length) {
        _currentPage++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  Widget _buildHectSelect(List<String> itemsHect, String selectedItemHect,
      String titleHect, String categoryHect) {
    int startIndex = _currentPage * _itemsPerPage;
    int endIndex = (_currentPage + 1) * _itemsPerPage;

    // Limita el rango de elementos para mostrar solo 8 por página
    List<String> pagedItems = itemsHect.sublist(
        startIndex, endIndex > itemsHect.length ? itemsHect.length : endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key: _SelectPiscDATO,
          titleHect,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 10.0,
          children: pagedItems.map((itemHect) {
            // 🔹 Usamos `pagedItems` aquí
            final isSelectedHect = _HectareasController.text.trim() ==
                    itemHect.split(" - ")[0].replaceAll("Hect: ", "").trim() &&
                _piscinasController.text.trim() ==
                    itemHect.split(" - ")[1].replaceAll("Pisc: ", "").trim();
            return FilterChip(
              shadowColor: Colors.black,
              selectedShadowColor: Colors.black,
              elevation: 5,
              label: Text(
                itemHect,
                style: TextStyle(
                  color: isSelectedHect ? Colors.white : Colors.black,
                ),
              ),
              selected: isSelectedHect,
              onSelected: (isSelected) {
                _onSelect(categoryHect, itemHect, isSelected);
              },
              selectedColor: const Color.fromARGB(255, 126, 53, 0),
              backgroundColor: const Color.fromARGB(255, 241, 238, 235),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Controles de paginación
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              key: _BeforeDATO,
              onPressed: _currentPage > 0 ? _previousPage : null,
              style: ButtonStyle(
                  backgroundColor: _currentPage > 0
                      ? WidgetStateProperty.all<Color>(
                          const Color.fromARGB(255, 126, 53, 0))
                      : null),
              child: const Text(
                "Atrás",
                style: TextStyle(
                  color: Color(0xfff3ece7),
                ),
              ),
            ),
            Text(
              "Pg. ${_currentPage + 1}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            ElevatedButton(
              key: _AfterDATO,
              onPressed: (_currentPage + 1) * _itemsPerPage < itemsHect.length
                  ? _nextPage
                  : null,
              style: ButtonStyle(
                  backgroundColor:
                      (_currentPage + 1) * _itemsPerPage < itemsHect.length
                          ? WidgetStateProperty.all<Color>(
                              const Color.fromARGB(255, 126, 53, 0))
                          : null),
              child: const Text(
                "Siguiente",
                style: TextStyle(
                  color: Color(0xfff3ece7),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onSelect(String category, String item, bool isSelected) {
    setState(() {
      if (category == "finca") {
        _selectedFinca = isSelected ? item : _selectedFinca;
        _loadHectareasPiscinas(_selectedFinca);
      } else if (category == "hectareas") {
        List<String> parts = item.split(" - ");
        if (parts.length == 2) {
          _HectareasController.text = parts[0].replaceAll("Hect: ", "").trim();
          _piscinasController.text =
              parts[1].replaceAll(RegExp(r'[^0-9.]'), '');
          selectedTerreno = {
            "Hectareas": _HectareasController.text,
            "Piscinas": _piscinasController.text,
          };
        }
      }
    });
  }
}

class CustomTableRow extends TableRow {
  CustomTableRow({
    required String label,
    required TextEditingController controller,
    String? unit,
  }) : super(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            TableCell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '$label...',
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 126, 53, 0),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 126, 53, 0),
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                  if (unit != null) // Solo muestra la unidad si está definida
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        unit,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
}
