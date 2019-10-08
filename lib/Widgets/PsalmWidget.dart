import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PsalmWidget  extends StatelessWidget {
  final String text;
  final String index;
  final String response;

  PsalmWidget(this.text, this.index, this.response);

  @override
  Widget build(BuildContext context) {
    
    return MarkdownBody(data: formatMarkDown(text, index, response));
  }

  String formatMarkDown(String text, String index, String response){
    return "## "+index+"\n\n"+
    "**_"+response+"_**\n\n"+
    text.replaceAll("R/.", "**R/.**");
  }
}