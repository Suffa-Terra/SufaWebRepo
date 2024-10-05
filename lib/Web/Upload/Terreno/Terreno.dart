import 'package:flutter/material.dart';
import 'package:sufaweb/Web/Upload/Terreno/CAMANOVILLO/CAMANOVILLO.dart';
import 'package:sufaweb/Web/Upload/Terreno/EXCANCRIGRU/EXCANCRIGRU.dart';
import 'package:sufaweb/Web/Upload/Terreno/FERTIAGRO/FERTIAGRO.dart';
import 'package:sufaweb/Web/Upload/Terreno/GROVITAL/GROVITAL.dart';
import 'package:sufaweb/Web/Upload/Terreno/SUFAAZA/SUFAAZA.dart';
import 'package:sufaweb/Web/Upload/Terreno/TIERRAVID/TIERRAVID.dart';

class TerrenoScreen extends StatefulWidget {
  const TerrenoScreen({Key? key}) : super(key: key);

  @override
  _TerrenoScreenState createState() => _TerrenoScreenState();
}

class _TerrenoScreenState extends State<TerrenoScreen> {
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
                  child: TERRAINCAMANOVILLOScreen(),
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
                  child: TERRAINEXCANCRIGRUScreen(),
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
                  child: TERRAINFERTIAGROScreen(),
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
                  child: TERRAINGROVITALScreen(),
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
                  child: TERRAINSUFAAZAScreen(),
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
                  child: TERRAINTIERRAVIDScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
