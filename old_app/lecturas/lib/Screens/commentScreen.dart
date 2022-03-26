import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lecturas/Model/Settings.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Util.dart';

class CommentScreen extends StatelessWidget {
  Settings _settings;

  @override
  Widget build(BuildContext context) {
    _settings = Provider.of<Settings>(context);
    return Scaffold(
        appBar: AppBar(
          title: title(context),
          actions: [
            _settings.getProvider().hasDownloadableExtras(_settings.currentTime)
                ? IconButton(
                    icon: Icon(FontAwesomeIcons.globe),
                    onPressed: () async {
                      var url = await _settings
                          .getProvider()
                          .getDownloadableExtraUrl();
                      print(url);
                      _launchURL(url);
                    },
                  )
                : Container()
          ],
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Container(
          //decoration: BoxDecoration( border: Border(top: BorderSide(color: Colors.brown, width: 2))),
          child: FutureBuilder<String>(
              future: _settings.getProvider().getExtraUrl(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) return Container();
                var text = snapshot.data;
                //print(text);
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0, bottom: 0.0),
                    //color: Theme.of(context).scaffoldBackgroundColor,
                    child: Html(
                      style: {
                        "strong": Style(textDecoration: TextDecoration.none),
                        "p": Style(
                            fontSize: FontSize(
                                Theme.of(context).textTheme.bodyText1.fontSize *
                                    _settings.scaleFactor)),
                      },
                      data: text,
                    ),
                  ),
                );
              }),
        ));
  }

  Widget title(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Comentario",
          maxLines: 1,
          style: TextStyle(
            color: (_settings.darkTheme)
                ? Theme.of(context).textTheme.bodyText1.color
                : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            //fontSize: 24
          ),
        ),
        Text(
          Util.getFullDateSpanish(_settings.currentTime),
          maxLines: 1,
          style: TextStyle(
              color: (_settings.darkTheme)
                  ? Theme.of(context).textTheme.bodyText1.color
                  : Theme.of(context).primaryColor,
              fontStyle: FontStyle.italic,
              fontSize: Theme.of(context).textTheme.bodyText1.fontSize
              //fontSize: 24
              ),
        )
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
