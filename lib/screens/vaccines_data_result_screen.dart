import 'dart:io';

import 'package:flutter/material.dart';
import 'package:med_cert/entities/certificate.dart';
import 'package:med_cert/services/pdf_certificate_service.dart';
import 'package:med_cert/util/date_utils.dart';
import 'package:med_cert/util/encryptioin.dart';
import 'package:med_cert/util/shared_preferences_util.dart';
import 'package:med_cert/widgets/alert_dialog_widget.dart';
import 'package:med_cert/widgets/vaccine_data_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import "package:med_cert/extensions/string_extension.dart";
import 'package:qr_flutter/qr_flutter.dart';

class VaccinesDataResultScreen extends StatefulWidget {
  const VaccinesDataResultScreen(
      {Key? key,
      this.restorationId,
      required this.certificate,
      required this.isFromMain})
      : super(key: key);
  final String? restorationId;
  final Certificate certificate;
  final bool isFromMain;
  @override
  _VaccinesDataResultScreenState createState() =>
      _VaccinesDataResultScreenState();
}

class _VaccinesDataResultScreenState extends State<VaccinesDataResultScreen> {
  bool _isVaccinePdfDownloaded = false;
  bool loading = false;
  String? pdfPath = "";

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';
    Directory dir = await getApplicationDocumentsDirectory();
    path = '${dir.path}/$uniqueFileName.pdf';
    return path;
  }

  Widget _myQrImage() {
    String dataString = widget.certificate.data.datapersona.first.idencrypt;
    String encrypted =
        EncryptionUtil.shared.getEncryptedStringFrom(text: dataString);

    Widget qrImage = QrImage(
      data: encrypted,
      version: QrVersions.auto,
      size: 300,
      gapless: false,
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
      foregroundColor: Colors.blue.shade900,
    );
    return qrImage;
  }

  _showAlertDialog(BuildContext context, Widget newWidget) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Cerrar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Mi QR"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width / 1.6,
            width: MediaQuery.of(context).size.width / 1.6,
            child: newWidget,
          ),
        ],
      ),
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

  Future<void> _getPDFVaccinationData(
      BuildContext contact, Certificate cert) async {
    if (widget.isFromMain) {
      String filePath =
          await getFilePath(cert.data.datapersona.first.idencrypt);
      _openFileFrom(filePath);
      return;
    } else {
      final progress = ProgressHUD.of(context);
      progress!.show();
      pdfPath = await VaccinePDFService.shared
          .getPDFVaccinationData(token: cert.data.datapersona.first.idencrypt);
      if (pdfPath != null) {
        progress.dismiss();
        setState(() {
          _isVaccinePdfDownloaded = true;
          _openFileFrom(pdfPath!);
        });
      }
    }
  }

  Future<void> _openFileFrom(String path) async {
    final _result = await OpenFile.open(path);
  }

  _saveVaccinationData() async {
    bool? savedData = await SharedPreferencesUtil.storeJson(
        key: 'user', json: widget.certificate.toJson());
    if (savedData) {
      _showGenericSuccess(message: "Tu certificado se guardó exitósamente.");
    } else {
      _showGenericError(
          message: "No pudimos guardar los datos de tu consulta.");
    }
  }

  _showGenericSuccess({String? message}) {
    String newMessage = message ?? "Acción realizada con éxito.";
    AlertDialogWidget.showGenericDialog(context, "¡Perfecto!", newMessage);
  }

  _showGenericError({String? message}) {
    String newMessage = message ??
        "Certificado no encontrado, cédula o fecha de nacimiento ingresados de manera incorrecta";
    AlertDialogWidget.showGenericDialog(context, "Error", newMessage);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String userFullName = widget.certificate.data.datapersona.first.nombres;
    String userBirthDate = DateTimeUtils.shared.stringDateFromString(
            widget.certificate.data.datapersona.first.fechanacimiento) ??
        "--/--/--";
    List<Datavacuna> vaccines = widget.certificate.data.datavacuna;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado de búsqueda'),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                    onPressed: () {
                      if (_isVaccinePdfDownloaded && pdfPath != null) {
                        _openFileFrom(pdfPath!);
                      } else {
                        _getPDFVaccinationData(context, widget.certificate);
                      }
                    },
                    child: Text(
                      _isVaccinePdfDownloaded || widget.isFromMain
                          ? "Mostrar PDF"
                          : 'Descargar PDF',
                      style: const TextStyle(color: Colors.white, fontSize: 21),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.isFromMain,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Container(
                    height: 50,
                    width: 180,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextButton(
                      onPressed: () {
                        _showAlertDialog(context, _myQrImage());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Motrar QR',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          SizedBox(
                            height: 36,
                            width: 36,
                            child: Icon(
                              Icons.qr_code,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _isVaccinePdfDownloaded,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextButton(
                      onPressed: () {
                        _saveVaccinationData();
                      },
                      child: const Text(
                        'Guardar como favorito',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        userFullName.cleanSpacesBewtween.capitalizeFirstofEach,
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Fecha nacimiento: ",
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          userBirthDate,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // ),
              Expanded(
                child: ListView.builder(
                  itemCount: vaccines.length,
                  itemBuilder: (BuildContext context, int index) {
                    return VaccineDataWidget(
                        name: vaccines[index].nomvacuna,
                        date: vaccines[index].fechavacuna,
                        number: vaccines[index].dosisaplicada);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
