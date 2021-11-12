import 'package:flutter/material.dart';
import 'package:med_cert/entities/certificate.dart';
import 'package:med_cert/services/pdf_certificate_service.dart';
import 'package:med_cert/util/date_utils.dart';
import 'package:med_cert/util/shared_preferences_util.dart';
import 'package:med_cert/widgets/alert_dialog_widget.dart';
import 'package:med_cert/widgets/vaccine_data_widget.dart';
import 'package:open_file/open_file.dart';

class VaccinesDataResultScreen extends StatefulWidget {
  const VaccinesDataResultScreen(
      {Key? key, this.restorationId, required this.certificate})
      : super(key: key);
  final String? restorationId;
  final Certificate certificate;

  @override
  _VaccinesDataResultScreenState createState() =>
      _VaccinesDataResultScreenState();
}

class _VaccinesDataResultScreenState extends State<VaccinesDataResultScreen> {
  bool _isVaccinePdfDownloaded = false;
  bool loading = false;
  String? pdfPath = "";

  Future<void> _getPDFVaccinationData(Certificate cert) async {
    pdfPath = await VaccinePDFService.shared
        .getPDFVaccinationData(token: cert.data.datapersona.first.idencrypt);
    if (pdfPath != null) {
      _isVaccinePdfDownloaded = true;
      _openFileFrom(pdfPath!);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              child: TextButton(
                onPressed: () {
                  if (_isVaccinePdfDownloaded && pdfPath != null) {
                    _openFileFrom(pdfPath!);
                  } else {
                    _getPDFVaccinationData(widget.certificate);
                  }
                },
                child: Text(
                  _isVaccinePdfDownloaded ? "Mostrar PDF" : 'Descargar PDF',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isVaccinePdfDownloaded,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(8)),
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
          SizedBox(
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    userFullName,
                    style: TextStyle(
                        fontSize: 24,
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
    );
  }
}
