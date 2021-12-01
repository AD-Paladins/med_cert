import 'dart:io';

import 'package:flutter/material.dart';
import 'package:med_cert/db/models/vaccination_status.dart';
import 'package:med_cert/entities/certificate.dart';
import 'package:med_cert/entities/error_response.dart';
import 'package:med_cert/services/pdf_certificate_service.dart';
import 'package:med_cert/services/vaccine_service.dart';
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
      this.identification,
      this.birthDate,
      this.json,
      required this.certificate,
      required this.isFromMain})
      : super(key: key);
  final String? restorationId;
  final Certificate certificate;
  final bool isFromMain;
  final String? identification;
  final String? birthDate;
  final String? json;

  @override
  _VaccinesDataResultScreenState createState() =>
      _VaccinesDataResultScreenState();
}

class _VaccinesDataResultScreenState extends State<VaccinesDataResultScreen> {
  Certificate? newCertificate;
  bool _isVaccinePdfDownloaded = false;
  bool loading = false;
  String? pdfPath = "";

  @override
  void initState() {
    super.initState();
    newCertificate = widget.certificate;
    _saveSearchDataIfNeeded();
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';
    Directory dir = await getApplicationDocumentsDirectory();
    path = '${dir.path}/$uniqueFileName.pdf';
    return path;
  }

  Widget _myQrImage() {
    String dataString = newCertificate!.data.datapersona.first.idencrypt;
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
      BuildContext context, Certificate cert) async {
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

  Future<void> _getVaccinationData(
      BuildContext context, String identification, String birthDate) async {
    final progress = ProgressHUD.of(context);
    progress!.show();
    try {
      var result = await VaccineService.shared
          .getVaccinationData(dni: identification, birthDate: birthDate);
      progress.dismiss();
      setState(() {
        newCertificate = result as Certificate;
      });
    } on ErrorResponse catch (error) {
      progress.dismiss();
      if (error.data != null) {
        AlertDialogWidget.showGenericDialog(
            context, "Error", error.data!.message);
      } else {
        _showGenericError();
      }
    } catch (e) {
      progress.dismiss();
      _showGenericError();
    }
  }

  _saveVaccinationData() async {
    bool? savedData = await SharedPreferencesUtil.storeJson(
        key: 'user', json: newCertificate!.toJson());
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

  _saveSearchDataIfNeeded() async {
    if (widget.identification != null && widget.birthDate != null) {
      String encryptedIdentification = EncryptionUtil.shared
          .getEncryptedStringFrom(text: widget.identification!);
      String encryptedJSON = EncryptionUtil.shared
          .getEncryptedStringFrom(text: newCertificate!.json.toString());

      DateTime birthDate =
          DateTimeUtils.shared.dateFromString(widget.birthDate!) ??
              DateTime.now();

      VaccinationStatusModel item = VaccinationStatusModel(
          id: 0,
          name: newCertificate!.data.datapersona.first.nombres,
          identification: encryptedIdentification,
          birthDate: birthDate,
          json: encryptedJSON,
          isFavorite: false);
      var itemReturn = await TodoProvider().insert(item);
      print(itemReturn);

      var listvaccines = await TodoProvider().getAllVaccinationStatus();
      if (listvaccines != null) {
        for (VaccinationStatusModel vaccine in listvaccines) {
          String newJson =
              EncryptionUtil.shared.getDecryptedStringFrom(text: vaccine.json);
          print(newJson);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String userFullName = newCertificate!.data.datapersona.first.nombres;
    String userBirthDate = DateTimeUtils.shared.stringDateFromString(
            newCertificate!.data.datapersona.first.fechanacimiento) ??
        "--/--/--";
    List<Datavacuna> vaccines = newCertificate!.data.datavacuna;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado de búsqueda'),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Column(
            children: [
              Visibility(
                visible: _isVaccinePdfDownloaded || widget.isFromMain,
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
                        if (widget.identification == null ||
                            widget.birthDate == null) {
                          return;
                        }
                        _getVaccinationData(
                            context, widget.identification!, widget.birthDate!);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Actualizar datos',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          SizedBox(
                            height: 36,
                            width: 36,
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
                        _getPDFVaccinationData(context, newCertificate!);
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
