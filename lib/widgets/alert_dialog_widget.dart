library flutter_ticket_widget;

import 'package:flutter/material.dart';

class AlertDialogWidget {
  static void showGenericDialog(
      BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Aceptar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
