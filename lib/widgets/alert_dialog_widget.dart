library flutter_ticket_widget;

import 'package:flutter/material.dart';

class AlertDialogWidget {
  static void showGenericDialog(
      BuildContext context, String title, String message,
      {TextButton? extraButton}) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Aceptar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    var buttons = [okButton];
    if (extraButton != null) {
      buttons = [extraButton, okButton];
    }
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: buttons,
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
