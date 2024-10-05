import 'package:flutter/material.dart';
import 'package:sufaweb/Web/Upload/Graficas/CAMANOVILLO/GraficaCAMANOVILLOScreen.dart';
import 'package:sufaweb/Web/Upload/Graficas/EXCANCRIGRUS/GraficaEXCANCRIGRUScreen.dart';
import 'package:sufaweb/Web/Upload/Graficas/FERTIAGRO/GraficaFERTIAGROScreen.dart';
import 'package:sufaweb/Web/Upload/Graficas/GROVITAL/GraficaGROVITALScreen.dart';
import 'package:sufaweb/Web/Upload/Graficas/SUFAAZA/GraficaSUFAAZAScreen.dart';
import 'package:sufaweb/Web/Upload/Graficas/TIERRAVID/GraficaTIERRAVIDScreen.dart';

class GraficasScreen extends StatefulWidget {
  const GraficasScreen({Key? key}) : super(key: key);

  @override
  _GraficasScreenState createState() => _GraficasScreenState();
}

class _GraficasScreenState extends State<GraficasScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // Cambiado a 6
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF4F4F4),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: const TabBar(
                    tabs: [
                      Tab(
                        text: 'CAMANOVILLOS',
                      ),
                      Tab(
                        text: 'EXCANCRIGRUS',
                      ),
                      Tab(
                        text: 'FERTIAGRO',
                      ),
                      Tab(
                        text: 'GROVITAL',
                      ),
                      Tab(
                        text: 'SUFAAZA',
                      ),
                      Tab(
                        text: 'TIERRAVID',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xfff4f4f4), Color(0xfff4f4f4)],
            ),
          ),
          child: TabBarView(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff4f4f4), Color(0xfff4f4f4)],
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: GraficaCAMANOVILLOScreen(),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff4f4f4), Color(0xfff4f4f4)],
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: GraficaEXCANCRIGRUScreen(),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff4f4f4), Color(0xfff4f4f4)],
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: GraficaFERTIAGROScreen(),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff4f4f4), Color(0xfff4f4f4)],
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: GraficaGROVITALScreen(),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff4f4f4), Color(0xfff4f4f4)],
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: GraficaSUFAAZAScreen(),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff4f4f4), Color(0xfff4f4f4)],
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: GraficaTIERRAVIDScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
