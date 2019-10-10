import 'package:auto_size_text/auto_size_text.dart';
import 'package:evangelios/Model/Comment.dart';
import 'package:evangelios/Model/DBHelper.dart';
import 'package:evangelios/Util.dart';
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

  DBHelper _dbHelper = DBHelper();

  _ListScreenState();

  void initState() {
    super.initState();
    _dbHelper.fetchAllComments().then((comments) {
      setState(() {
        _comments = comments;
      });
    });
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
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    _dbHelper.removeComment(el.date).then((_) {
                      setState(() {
                        _comments.remove(el);
                      });
                    });
                  },
                ),
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
          ? _comments.length > 0
              ? _buildMainLayout(context)
              : LoadingWidget(
                  "",
                  iconData: Icons.comment,
                )
          : LoadingWidget("cargando..."),
    );
  }

  void _commentModalBottomSheet(context, Comment comment) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).padding.top,
                ),
                Row(
                  children: <Widget>[
                    AutoSizeText(
                      Util.getFullDateSpanish(comment.date),
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          //fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ],
                ),
                Container(height: 32,),
                MarkdownBody(
                  data: comment.comment,
                ),
                Expanded(
                  child: Container(),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        child: Text(
                          "Cerrar",
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
