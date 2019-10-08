import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class GodspellWidget  extends StatelessWidget {
  final String text;
  final String index;

  GodspellWidget(this.text, this.index);

  @override
  Widget build(BuildContext context) {
    
    return MarkdownBody(data: formatMarkDown(text, index));
  }

  String formatMarkDown(String text, String index){
    return "## "+index+"\n\n"+text+"\n\n**Palabra del Señor**";
  }
}