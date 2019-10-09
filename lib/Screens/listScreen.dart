import 'package:evangelios/Model/Comment.dart';
import 'package:evangelios/Model/TextsSet.dart';
import 'package:evangelios/Widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  }

  Widget _buildMainLayout(BuildContext context) {
    return ListView(
      children: _comments
          .map((el) => ListTile(
                title: Text(el.comment),
                subtitle: Text("Fecha: " + _formatter.format(el.date)),
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
        centerTitle: true,
        elevation: 0,
        title: Text("Comentarios"),
        textTheme: TextTheme(
            title: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        iconTheme: IconThemeData(color: buttonBarFg),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: _comments != null
          ? _buildMainLayout(context)
          : LoadingWidget("cargando..."),
    );
  }
}
