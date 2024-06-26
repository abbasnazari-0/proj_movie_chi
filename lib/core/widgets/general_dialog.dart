import 'package:flutter/material.dart';
import 'package:movie_chi/core/widgets/mytext.dart';

class GeneralDialog {
  static void show(BuildContext context, String title, String message,
      String buttonText, Function onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: MyText(
                  txt: buttonText,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressed();
                },
              ),
              TextButton(
                child: const MyText(txt: 'خیر'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
