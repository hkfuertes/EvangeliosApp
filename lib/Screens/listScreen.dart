import 'package:auto_size_text/auto_size_text.dart';
import 'package:evangelios/Model/Comment.dart';
import 'package:evangelios/Widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class ListScreen extends StatefulWidget {
  static final String PAGE_NAME = "LIST_PAGE";
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Comment> _comments = List<Comment>();
  DateFormat _formatter = DateFormat('dd/MM/yyyy');

  _ListScreenState();

  void initState() {
    super.initState();
    _comments.add(Comment(DateTime.now(), "# Titulo\nComentario **molon**."));
    _comments
        .add(Comment(DateTime.now().subtract(Duration(days: 1)), '''# O flores

Cognita vacant cogi tamen simul timida ego audita ac sunt et consequitur
Haemoniae hausti semihomines amet cadunt. Huc sive: [ubi
sororem](http://contigitcavas.io/deae-emoriar.html) iaculum Veneris territus
illum moderamine frater minimae. In palmis quo aera animam canenti reus
superesse **ultima** cum sicut quodque ignem, et. Ignibus supplevit humum Nelei
paternos et posuere altera summis, lenis vestra. Ver nitor carebat at quidem,
[Phoebus me Pario](http://cruciatacarmina.com/) cum tepidos laboris digiti, quam
huic!

- Hyacinthia nec subdita finemque
- Corpora ipsa summas prohibebant enim
- Bacchi illis'''));
    _comments.add(Comment(DateTime.now().add(Duration(days: 1)),
        "Comentario **largo**, comentario **molon y superlargo** de mañana a ver que pasar y a ver como puedo _acortarlo_"));
  }

  Widget _buildMainLayout(BuildContext context) {
    return ListView(
      children: _comments
          .map((el) => ListTile(
                title: Text(
                  el.getTitle(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                subtitle: Text(
                  "Fecha: " + _formatter.format(el.date),
                ),
                onTap: () {
                  _commentModalBottomSheet(context, el);
                },
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarColor: Theme.of(context).scaffoldBackgroundColor));
        statusBarColor: Colors.transparent));
        */
    Color buttonBarFg = Theme.of(context).primaryColorDark;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        //centerTitle: true,
        elevation: 0,
        title: AutoSizeText(
          "Comentarios",
          maxLines: 1,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        iconTheme: IconThemeData(color: buttonBarFg),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: _comments != null
          ? _buildMainLayout(context)
          : LoadingWidget("cargando..."),
    );
  }

  void _commentModalBottomSheet(context, Comment comment) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MarkdownBody(
                  data: comment.comment,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              FlatButton(
                child: Text(
                  "Cerrar",
                  style: TextStyle(color: Theme.of(context).primaryColorDark),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Container(height: 10,)
            ],
          );
        });
  }
}
