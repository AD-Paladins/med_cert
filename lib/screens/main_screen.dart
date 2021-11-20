import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:med_cert/db/models/vaccination_status.dart';
import 'package:med_cert/entities/certificate.dart';
import 'package:med_cert/screens/qr_reader_screen.dart';
import 'package:med_cert/screens/vaccines_data_result_screen.dart';
import 'package:med_cert/screens/vaccines_data_search_screen.dart';
import 'package:med_cert/services/pdf_certificate_service.dart';
import 'package:med_cert/util/encryptioin.dart';
import 'package:med_cert/util/shared_preferences_util.dart';
import 'package:med_cert/widgets/alert_dialog_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:open_file/open_file.dart';

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

    String json = '''
    {
    "data": {
        "status": true,
        "message": "Paciente se encuentra vacunado",
        "datavacuna": [
            {
                "nomvacuna": "CoronaVac SINOVAC",
                "dosisaplicada": 2,
                "fechavacuna": "yyyy-mm-dd"
            },
            {
                "nomvacuna": "CoronaVac SINOVAC",
                "dosisaplicada": 1,
                "fechavacuna": "2021-08-18"
            }
        ],
        "datapersona": [
            {
                "fechanacimiento": "1888-8-18",
                "nombres": "MONCAYO PIGUABE DON RAMON",
                "idencrypt": "xxxxx@@@xxxxxxxxx+w=="
            }
        ]
    }
}
    ''';
    VaccinationStatusModel item = VaccinationStatusModel(
        id: 0,
        name: "PRUEBA",
        identification: "0000000000",
        birthDate: DateTime.now(),
        json: json,
        isFavorite: false);

    // var itemReturn = await TodoProvider().insert(item);
    // print(itemReturn.toString());
    String asdasd =
        await EncryptionUtil.shared.getEncryptedStringFrom(text: "text");
    var listvaccines = await TodoProvider().getAllVaccinationStatus();
    print(listvaccines);
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
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Column(
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
        ),
      ),
    );
  }

  _goToGetCerttificate(BuildContext context) async {
    if (userCertificate != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => VaccinesDataResultScreen(
                  certificate: userCertificate!, isFromMain: true)));
    }
  }

  _goToSearchCerttificate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VaccinesDataSearchScreen()),
    ).then((value) => _getUserData());
  }

  _goToQrReader(BuildContext context) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (barcodeScanRes == "-1" || int.parse(barcodeScanRes) == -1) {
      return;
    }
    if (!mounted) return;
    String decrypted =
        EncryptionUtil.shared.getDecryptedStringFrom(text: barcodeScanRes);
    if (decrypted.isEmpty) {
      TextButton okButton = TextButton(
        child: const Text("Internar nuevamente"),
        onPressed: () {
          Navigator.pop(context);
          _goToQrReader(context);
        },
      );
      AlertDialogWidget.showGenericDialog(
          context, "Lector QR", "El QR no es válido.",
          extraButton: okButton);
      return;
    }
    final progress = ProgressHUD.of(context);
    progress!.show();
    String? pdfPath =
        await VaccinePDFService.shared.getPDFVaccinationData(token: decrypted);
    setState(() {
      if (pdfPath != null) {
        progress.dismiss();
        setState(() {
          _openFileFrom(pdfPath, context);
        });
      }
    });
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

  Future<void> _openFileFrom(String path, BuildContext context) async {
    final progress = ProgressHUD.of(context);
    progress!.showWithText(
      "Cargando PDF...",
    );
    final _result =
        await OpenFile.open(path); //.then((value) => deleteFile(path));
    progress.dismiss();
  }
}
