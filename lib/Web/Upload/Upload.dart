import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sufaweb/Web/Upload/Graficas/CAMANOVILLO/GraficaCAMANOVILLOScreen.dart';
import 'package:sufaweb/Web/Upload/Graficas/EXCANCRIGRUS/GraficaEXCANCRIGRUScreen.dart';
import 'package:sufaweb/Web/Upload/Graficas/FERTIAGRO/GraficaFERTIAGROScreen.dart';
import 'package:sufaweb/Web/Upload/Graficas/GROVITAL/GraficaGROVITALScreen.dart';
import 'package:sufaweb/Web/Upload/Graficas/GraficasScreen.dart';
import 'package:sufaweb/Web/Upload/Graficas/SUFAAZA/GraficaSUFAAZAScreen.dart';
import 'package:sufaweb/Web/Upload/Graficas/TIERRAVID/GraficaTIERRAVIDScreen.dart';
import 'package:sufaweb/Web/Upload/Poblacion/CAMANOVILLO/PoblacionCAMANOVILLOS.dart';
import 'package:sufaweb/Web/Upload/Poblacion/EXCANCRIGRU/PoblacionEXCANCRIGRU.dart';
import 'package:sufaweb/Web/Upload/Poblacion/FERTIAGRO/PoblacionFERTIAGRO.dart';
import 'package:sufaweb/Web/Upload/Poblacion/GROVITAL/PoblacionGROVITAL.dart';
import 'package:sufaweb/Web/Upload/Poblacion/Poblacion.dart';
import 'package:sufaweb/Web/Upload/Poblacion/SUFAAZA/PoblacionSUFAAZA.dart';
import 'package:sufaweb/Web/Upload/Poblacion/TIERRAVID/PoblacionTIERRAVID.dart';
import 'package:sufaweb/Web/Upload/Rendimiento/Rendimiento.dart';
import 'package:sufaweb/Web/Upload/Terreno/CAMANOVILLO/CAMANOVILLO.dart';
import 'package:sufaweb/Web/Upload/Terreno/EXCANCRIGRU/EXCANCRIGRU.dart';
import 'package:sufaweb/Web/Upload/Terreno/FERTIAGRO/FERTIAGRO.dart';
import 'package:sufaweb/Web/Upload/Terreno/GROVITAL/GROVITAL.dart';
import 'package:sufaweb/Web/Upload/Terreno/SUFAAZA/SUFAAZA.dart';
import 'package:sufaweb/Web/Upload/Terreno/TIERRAVID/TIERRAVID.dart';
import 'package:sufaweb/Web/Upload/Terreno/Terreno.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final List<String> imagePaths = [
    'assets/images/logoOscuro1.jpeg',
    'assets/images/logoOscuro2.jpeg',
    'assets/images/logoOscuro3.jpeg',
    'assets/images/logoBlanco1.jpeg',
    'assets/images/logoBlanco2.jpeg',
    'assets/images/logoBlanco3.jpeg',
    'assets/images/logoSemi1.jpeg',
  ];

  String _selectedScreen = 'GRUPO TERRAWA';
  String _selectedScreenText = 'GRUPO TERRAWA';
  bool _showImageAndLema = true;

  String? selectedOption;

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  String _randomImagePath() {
    final Random random = Random();
    return imagePaths[random.nextInt(imagePaths.length)];
  }

  Widget _getScreenContentText(String text) {
    switch (text) {
      case 'CAMANOVILLO':
        return const Center(child: Text("CAMANOVILLO"));
      case 'EXCANCRIGRU':
        return const Center(child: Text("EXCANCRIGRU"));
      case 'FERTIAGRO':
        return const Center(child: Text("FERTIAGRO"));
      case 'GROVITAL':
        return const Center(child: Text("GROVITAL"));
      case 'SUFAAZA':
        return const Center(child: Text("SUFAAZA"));
      case 'TIERRAVID':
        return const Center(child: Text("TIERRAVID"));
      case 'BALANCEO':
        return const Center(child: Text("CONTROL BALANCEO"));
      case 'Poblacion':
        return const Center(child: Text("Poblacion"));
      default:
        return const Center(child: Text("GRUPO TERRAWA"));
    }
  }

  Widget getSelectedScreen(String selectedOption) {
    String randomImagePath = _randomImagePath();
    switch (selectedOption) {
      case 'Terreno':
        return const TerrenoScreen();
      case 'Terreno_CAMANOVILLO':
        return const TERRAINCAMANOVILLOScreen();
      case 'Terreno_EXCANCRIGRU':
        return const TERRAINEXCANCRIGRUScreen();
      case 'Terreno_FERTIAGRO':
        return const TERRAINFERTIAGROScreen();
      case 'Terreno_GROVITAL':
        return const TERRAINGROVITALScreen();
      case 'Terreno_SUFAAZA':
        return const TERRAINSUFAAZAScreen();
      case 'Terreno_TIERRAVID':
        return const TERRAINTIERRAVIDScreen();

      case 'Rendimiento':
        return const RendimientoScreen();

      case 'Poblacion':
        return const PoblacionScreen();
      case 'Poblacion_CAMANOVILLO':
        return const PoblacionCAMANOVILLOScreen();
      case 'Poblacion_EXCANCRIGRU':
        return const PoblacionEXCANCRIGRUScreen();
      case 'Poblacion_FERTIAGRO':
        return const PoblacionFERTIAGROScreen();
      case 'Poblacion_GROVITAL':
        return const PoblacionGROVITALScreen();
      case 'Poblacion_SUFAAZA':
        return const PoblacionSUFAAZAScreen();
      case 'Poblacion_TIERRAVID':
        return const PoblacionTIERRAVIDScreen();

      case 'Graficas':
        return const GraficasScreen();
      case 'GraficaCAMANOVILLO':
        return const GraficaCAMANOVILLOScreen();
      case 'GraficaEXCANCRIGRU':
        return const GraficaEXCANCRIGRUScreen();
      case 'GraficaFERTIAGRO':
        return const GraficaFERTIAGROScreen();
      case 'GraficaGROVITAL':
        return const GraficaGROVITALScreen();
      case 'GraficaSUFAAZA':
        return const GraficaSUFAAZAScreen();
      case 'GraficaTIERRAVID':
        return const GraficaTIERRAVIDScreen();
      default:
        return Center(
          child: DraggableImageWidget(
            showImageAndLema: _showImageAndLema,
            imagePath: randomImagePath,
          ),
        );
    }
  }

  void _onMenuTap(String screen, String text) {
    setState(() {
      _selectedScreen = screen;
      _selectedScreenText = text;
      _showImageAndLema =
          false; // Ocultar imagen y lema al seleccionar una opción
    });
    Navigator.of(context).pop(); // Cerrar el drawer
  }

  @override
  Widget build(BuildContext context) {
    String randomImagePath = _randomImagePath();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedScreenText,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            color: Color(0XFFF4F4F4),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text(
                "GRUPO TERRAWA",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(213, 0, 0, 0),
                ),
              ),
              accountEmail: const Text(
                "facturacion@terrawa.ec",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(213, 0, 0, 0),
                ),
              ),
              currentAccountPicture: Material(
                elevation: 5,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: CircleAvatar(
                  backgroundImage: AssetImage(randomImagePath),
                  radius: 30, // Puedes ajustar el radio según sea necesario
                ),
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 254, 247, 255),
              ),
            ),
            ListTile(
              title: const Text(
                'Rendimiento',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => _onMenuTap('Rendimiento', 'Rendimiento'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
            const Divider(
              thickness: 1,
              height: 1,
              color: Color.fromARGB(38, 0, 0, 0),
            ),
            ExpansionTile(
              title: const Text(
                'Fincas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: const Text(
                      'CAMANOVILLO',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                          child: ListTile(
                            title: const Text(
                              'Terreno',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () => _onMenuTap(
                                'Terreno_CAMANOVILLO', 'CAMANOVILLO'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                          child: ListTile(
                            title: const Text(
                              'Población',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () => _onMenuTap(
                                'Poblacion_CAMANOVILLO', 'CAMANOVILLO'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                          child: ListTile(
                            title: const Text(
                              'Gráficas',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('GraficaCAMANOVILLO', 'CAMANOVILLO'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: const Text(
                      'EXCANCRIGRU',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffe2d7d4),
                                Color.fromARGB(255, 255, 251, 236)
                              ],
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
                          child: ListTile(
                            title: const Text(
                              'Terreno',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () => _onMenuTap(
                                'Terreno_EXCANCRIGRU', 'EXCANCRIGRU'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffe2d7d4),
                                Color.fromARGB(255, 255, 251, 236)
                              ],
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
                          child: ListTile(
                            title: const Text(
                              'Población',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () => _onMenuTap(
                                'Poblacion_EXCANCRIGRU', 'EXCANCRIGRU'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffe2d7d4),
                                Color.fromARGB(255, 255, 251, 236)
                              ],
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
                          child: ListTile(
                            title: const Text(
                              'Gráficas',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('GraficaEXCANCRIGRU', 'EXCANCRIGRU'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: const Text(
                      'FERTIAGRO',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                          child: ListTile(
                            title: const Text(
                              'Terreno',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('Terreno_FERTIAGRO', 'FERTIAGRO'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                          child: ListTile(
                            title: const Text(
                              'Población',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('Poblacion_FERTIAGRO', 'FERTIAGRO'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                          child: ListTile(
                            title: const Text(
                              'Gráficas',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('GraficaFERTIAGRO', 'FERTIAGRO'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: const Text(
                      'GROVITAL',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffe2dfd7), Color(0xffffffff)],
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
                          child: ListTile(
                            title: const Text(
                              'Terreno',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('Terreno_GROVITAL', 'GROVITAL'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffe2dfd7), Color(0xffffffff)],
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
                          child: ListTile(
                            title: const Text(
                              'Población',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('Poblacion_GROVITAL', 'GROVITAL'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffe2dfd7), Color(0xffffffff)],
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
                          child: ListTile(
                            title: const Text(
                              'Gráficas',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('GraficaGROVITAL', 'GROVITAL'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: const Text(
                      'SUFAAZA',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffe2d5d5), Color(0xfff4f4f4)],
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
                          child: ListTile(
                            title: const Text(
                              'Terreno',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('Terreno_SUFAAZA', 'SUFAAZA'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffe2d5d5), Color(0xfff4f4f4)],
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
                          child: ListTile(
                            title: const Text(
                              'Población',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('Poblacion_SUFAAZA', 'SUFAAZA'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffe2d5d5), Color(0xfff4f4f4)],
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
                          child: ListTile(
                            title: const Text(
                              'Gráficas',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('GraficaCAMANOVILLO', 'CAMANOVILLO'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: const Text(
                      'TIERRAVID',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xfff5ede3), Color(0xfff6f2f0)],
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
                          child: ListTile(
                            title: const Text(
                              'Terreno',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('Terreno_TIERRAVID', 'TIERRAVID'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                             colors: [Color(0xfff5ede3), Color(0xfff6f2f0)],
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
                          child: ListTile(
                            title: const Text(
                              'Población',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('Poblacion_TIERRAVID', 'TIERRAVID'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xfff5ede3), Color(0xfff6f2f0)],
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
                          child: ListTile(
                            title: const Text(
                              'Gráficas',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () =>
                                _onMenuTap('GraficaTIERRAVID', 'TIERRAVID'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff4f4f4), Color(0xfff4f4f4)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: getSelectedScreen(_selectedScreen),
        ),
      ),
    );
  }
}

class DraggableImageWidget extends StatefulWidget {
  final bool showImageAndLema;
  final String imagePath;

  const DraggableImageWidget({
    super.key,
    required this.showImageAndLema,
    required this.imagePath,
  });

  @override
  _DraggableImageWidgetState createState() => _DraggableImageWidgetState();
}

class _DraggableImageWidgetState extends State<DraggableImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(
          0, -0.1), // Ajusta el offset para mover la imagen más arriba
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showImageAndLema
        ? Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height *
                        0.2, // Ajusta este valor para mover la imagen más arriba
                    left: 0,
                    right: 0,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: _animation.value *
                              MediaQuery.of(context).size.height,
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(widget.imagePath),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Card(
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xfff9f8ff), Color(0xfff1f2f4)],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            color: const Color(0XFFF4F4F4).withOpacity(
                                0.8), // Color de fondo con opacidad
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(10, 10),
                                color: Color.fromARGB(80, 0, 0, 0),
                                blurRadius: 10,
                              ),
                              BoxShadow(
                                  offset: Offset(-10, -10),
                                  color: Color.fromARGB(150, 255, 255, 255),
                                  blurRadius: 10),
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "LA EXCELENCIA EN LA CRÍA DE CAMARÓN ES NUESTRA META, COSECHANDO CALIDAD, ENTREGANDO CONFIANZA",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color.fromARGB(205, 35, 45, 50),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox
            .shrink(); // Retorna un widget vacío si no se debe mostrar
  }
}
