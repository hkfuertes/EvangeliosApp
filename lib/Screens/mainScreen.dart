import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _counter = 0;

  String _dummyText = '''Lectura del libro de profeta Jonás (3,1-10):

En aquellos días, el Señor volvió a hablar a Jonás y le dijo: «Levántate y vete a Nínive, la gran capital, para anunciar allí el mensaje que te voy a indicar».
Se levantó Jonás y se fue a Nínive, como le había mandado el Señor. Nínive era una ciudad enorme: hacían falta tres días para recorrerla.
Jonás caminó por la ciudad durante un día, pregonando: «Dentro de cuarenta días Nínive será destruida».
Los ninivitas creyeron en Dios: ordenaron un ayuno y se vistieron de sayal, grandes y pequeños. Llegó la noticia al rey de Nínive, que se levantó del trono, se quitó el manto, se vistió de sayal, se sentó sobre ceniza y en nombre suyo y de sus ministros mandó proclamar en Nínive el siguiente decreto: «Que hombres y animales, vacas y ovejas, no prueben bocado, que no pasten ni beban. Que todos se vistan de sayal e invoquen con fervor a Dios, y que cada uno se arrepienta de su mala vida y deje de cometer injusticias. Quizá Dios se arrepienta y nos perdone, aplaque el incendio de su ira y así no moriremos».
Cuando Dios vio sus obras y cómo se convertían de su mala vida, cambió de parecer y no les mandó el castigo que había determinado imponerles.''';

  String _dummyComment = "Comentario";

  //https://stackoverflow.com/questions/51607440/horizontally-scrollable-cards-with-snap-effect-in-flutter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Text(_dummyText),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _dummyComment,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
