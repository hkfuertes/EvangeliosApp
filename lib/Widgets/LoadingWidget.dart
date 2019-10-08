import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String text;
  LoadingWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.file_download,
            color: Theme.of(context).primaryColorLight,
            size: MediaQuery.of(context).size.height * 0.3,
          ),
          Text(text, style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05, color: Theme.of(context).primaryColorLight,),)
        ],
      ),
    );
  }
}
