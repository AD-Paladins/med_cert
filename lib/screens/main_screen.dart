import 'package:flutter/material.dart';
import 'package:med_cert/util/shared_preferences_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'qr_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificado COVID'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () async {
            String dni =
                await SharedPreferencesUtil.getString(key: "dni") ?? "";
            String birthDate =
                await SharedPreferencesUtil.getString(key: "birthDate") ?? "";
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QrScreen(
                        birthDate: birthDate,
                        dni: dni,
                      )),
            );
          },
        ),
      ),
    );
  }
}
