import 'package:flutter/material.dart';
import 'package:sufaweb/Web/Upload/Poblacion/CAMANOVILLO/PoblacionCAMANOVILLOS.dart';
import 'package:sufaweb/Web/Upload/Poblacion/EXCANCRIGRU/PoblacionEXCANCRIGRU.dart';
import 'package:sufaweb/Web/Upload/Poblacion/FERTIAGRO/PoblacionFERTIAGRO.dart';
import 'package:sufaweb/Web/Upload/Poblacion/GROVITAL/PoblacionGROVITAL.dart';
import 'package:sufaweb/Web/Upload/Poblacion/SUFAAZA/PoblacionSUFAAZA.dart';
import 'package:sufaweb/Web/Upload/Poblacion/TIERRAVID/PoblacionTIERRAVID.dart';

class PoblacionScreen extends StatefulWidget {
  const PoblacionScreen({Key? key}) : super(key: key);

  @override
  _PoblacionScreenState createState() => _PoblacionScreenState();
}

class _PoblacionScreenState extends State<PoblacionScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // Cambiado a 6
      child: Scaffold(
        appBar: AppBar(
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
        body: const TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: PoblacionCAMANOVILLOScreen(),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: PoblacionEXCANCRIGRUScreen(),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: PoblacionFERTIAGROScreen(),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: PoblacionGROVITALScreen(),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: PoblacionSUFAAZAScreen(),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: PoblacionTIERRAVIDScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
