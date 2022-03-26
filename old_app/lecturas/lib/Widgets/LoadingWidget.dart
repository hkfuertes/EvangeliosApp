import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String text;
  IconData iconData;
  LoadingWidget(this.text,{this.iconData = Icons.file_download});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              this.iconData,
              color: Theme.of(context).primaryColorLight,
              size: MediaQuery.of(context).size.height * 0.3,
            ),
            Container(height: 20,),
            Text(text, style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05, color: Theme.of(context).primaryColorLight,),)
          ],
        ),
      ),
    );
  }
}
