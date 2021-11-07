import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:med_cert/screens/search_certificate.dart';
import 'package:med_cert/util/shared_preferences_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'qr_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon arrowIcon = Platform.isAndroid
        ? const Icon(Icons.arrow_forward)
        : const Icon(Icons.arrow_forward_ios);
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificado COVID'),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () => _goToGetCerttificate(context),
            child: Card(
              child: ListTile(
                leading: Image.asset(
                  "assets/icons/policy.png",
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                trailing: arrowIcon,
                title: Text(
                  "Revisa el estado de tu certificado",
                  style: TextStyle(fontSize: 19),
                ),
                subtitle: Padding(
                    padding: EdgeInsets.only(top: 2, bottom: 2),
                    child: Text(
                      "Aquí se muestra el certificado que elegiste como el principal.",
                      style: TextStyle(fontSize: 12),
                    )),
              ),
            ),
          ),
          InkWell(
            onTap: () => _goToSearchCerttificate(context),
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.asset(
                    "assets/icons/search-file.png",
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  trailing: arrowIcon,
                  title: Text(
                    "Buscar certificado",
                    style: TextStyle(fontSize: 19),
                  ),
                  subtitle: Padding(
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      child: Text(
                        "Necesitas el número de cédula y fecha de nacimiento.",
                        style: TextStyle(fontSize: 12),
                      )),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => _goToGetCerttificate(context),
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.asset(
                    "assets/icons/search-qr.png",
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  trailing: arrowIcon,
                  title: Text(
                    "Lectura de código QR.",
                    style: TextStyle(fontSize: 19),
                  ),
                  subtitle: Padding(
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      child: Text(
                        "Leer QR que proporciona la app en otro dispositivo.",
                        style: TextStyle(fontSize: 12),
                      )),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => _goToGetCerttificate(context),
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.asset(
                    "assets/icons/history.png",
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  trailing: arrowIcon,
                  title: Text(
                    "Historial",
                    style: TextStyle(fontSize: 19),
                  ),
                  subtitle: Padding(
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      child: Text(
                        "Revisa el estado de tus consultas previas.",
                        style: TextStyle(fontSize: 12),
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _goToGetCerttificate(BuildContext context) async {
    String dni = await SharedPreferencesUtil.getString(key: "dni") ?? "";
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
  }

  _goToSearchCerttificate(BuildContext context) async {
    String dni = await SharedPreferencesUtil.getString(key: "dni") ?? "";
    String birthDate =
        await SharedPreferencesUtil.getString(key: "birthDate") ?? "";
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
  }
}
