import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:med_cert/entities/certificate.dart';
import 'package:med_cert/screens/qr_reader_screen.dart';
import 'package:med_cert/screens/vaccines_data_result_screen.dart';
import 'package:med_cert/screens/vaccines_data_search_screen.dart';
import 'package:med_cert/util/shared_preferences_util.dart';
import 'package:med_cert/widgets/alert_dialog_widget.dart';
import 'qr_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, this.restorationId}) : super(key: key);
  final String? restorationId;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Certificate? userCertificate;
  bool _isShownInitMessage = false;
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  _getUserData() async {
    var jsonCertificate = await SharedPreferencesUtil.getJson(key: 'user');
    if (jsonCertificate != null) {
      setState(() {
        userCertificate = Certificate.fromJson(jsonCertificate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShownInitMessage) {
      _isShownInitMessage = true;
      _firtsInitApp(context);
    }

    Icon arrowIcon = Platform.isAndroid
        ? const Icon(Icons.arrow_forward)
        : const Icon(Icons.arrow_forward_ios);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificado COVID'),
      ),
      body: Column(
        children: [
          Visibility(
              visible: userCertificate != null,
              child: InkWell(
                onTap: () => _goToGetCerttificate(context),
                child: Card(
                  child: ListTile(
                    leading: Image.asset(
                      "assets/icons/policy.png",
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    trailing: arrowIcon,
                    title: const Text(
                      "Revisa el estado de tu certificado",
                      style: TextStyle(fontSize: 19),
                    ),
                    subtitle: const Padding(
                        padding: EdgeInsets.only(top: 2, bottom: 2),
                        child: Text(
                          "Aquí se muestra el certificado que elegiste como el principal.",
                          style: TextStyle(fontSize: 12),
                        )),
                  ),
                ),
              )),
          InkWell(
            onTap: () => _goToSearchCerttificate(context),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.asset(
                    "assets/icons/search-file.png",
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  trailing: arrowIcon,
                  title: const Text(
                    "Buscar certificado",
                    style: TextStyle(fontSize: 19),
                  ),
                  subtitle: const Padding(
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      child: Text(
                        "Necesitas el número de cédula y fecha de nacimiento.",
                        style: TextStyle(fontSize: 12),
                      )),
                ),
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: InkWell(
              onTap: () => _goToQrReader(context),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset(
                      "assets/icons/search-qr.png",
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    trailing: arrowIcon,
                    title: const Text(
                      "Lectura de código QR.",
                      style: TextStyle(fontSize: 19),
                    ),
                    subtitle: const Padding(
                        padding: EdgeInsets.only(top: 2, bottom: 2),
                        child: Text(
                          "Leer QR que proporciona esta app desde otro dispositivo.",
                          style: TextStyle(fontSize: 12),
                        )),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: InkWell(
              onTap: () => _goToGetCerttificate(context),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset(
                      "assets/icons/history.png",
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    trailing: arrowIcon,
                    title: const Text(
                      "Historial",
                      style: TextStyle(fontSize: 19),
                    ),
                    subtitle: const Padding(
                        padding: EdgeInsets.only(top: 2, bottom: 2),
                        child: Text(
                          "Revisa el estado de tus consultas previas.",
                          style: TextStyle(fontSize: 12),
                        )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _goToGetCerttificate(BuildContext context) async {
    if (userCertificate != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => VaccinesDataResultScreen(
                    certificate: userCertificate!,
                    isFromMain: true,
                  )));
    }
  }

  _goToSearchCerttificate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VaccinesDataSearchScreen()),
    ).then((value) => _getUserData());
  }

  _goToQrReader(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrReaderScreen()),
    ).then((value) => _getUserData());
  }

  _firtsInitApp(BuildContext context) async {
    TextButton okButton = TextButton(
      child: const Text("No volver a mostrar"),
      onPressed: () {
        SharedPreferencesUtil.storeInt(key: "firstInit", value: 1);
        Navigator.pop(context);
      },
    );

    int isFirstInitApp =
        await SharedPreferencesUtil.getInt(key: "firstInit") ?? 0;
    if (isFirstInitApp == 0) {
      AlertDialogWidget.showGenericDialog(context, "App gratuita!",
          "Esa aplicación es gratuita e independiente del gobierno. \nUsa servicios abiertos por el Ministerio de Salud Pública del Ecuador para verificar tus datos de vacunación.",
          extraButton: okButton);
    }
  }
}
