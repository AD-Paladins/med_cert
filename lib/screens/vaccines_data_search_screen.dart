import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:med_cert/entities/certificate.dart';
import 'package:med_cert/screens/vaccines_data_result_screen.dart';
import 'package:med_cert/services/vaccine_service.dart';
import 'package:med_cert/entities/error_response.dart';
import 'package:med_cert/util/date_utils.dart';
import 'package:med_cert/widgets/alert_dialog_widget.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class VaccinesDataSearchScreen extends StatefulWidget {
  const VaccinesDataSearchScreen({Key? key, this.restorationId})
      : super(key: key);
  final String? restorationId;

  @override
  _VaccinesDataSearchScreenState createState() =>
      _VaccinesDataSearchScreenState();
}

class _VaccinesDataSearchScreenState extends State<VaccinesDataSearchScreen> {
  Certificate? certificate;
  DateTime? _selectedDate;
  bool loading = false;
  TextEditingController dniInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  void _presentDatePicker() {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        String formattedDate = "Selecionar una fecha";
        if (_selectedDate != null) {
          formattedDate = DateTimeUtils.shared.stringFromDate(_selectedDate)!;
        }
        dateInput.text = formattedDate;
      });
    });
  }

  Future<void> _getVaccinationData(BuildContext context) async {
    final progress = ProgressHUD.of(context);
    progress!.show();
    try {
      var result = await VaccineService.shared
          .getVaccinationData(dni: dniInput.text, birthDate: dateInput.text);
      certificate = result as Certificate;
      progress.dismiss();
      setState(() {
        if (certificate != null) {
          Certificate cert = certificate!;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => VaccinesDataResultScreen(
                        certificate: cert,
                        isFromMain: false,
                        identification: dniInput.text,
                        birthDate: dateInput.text,
                        json: cert.json.toString(),
                      )));
        }
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

  _showGenericError({String? message}) {
    String newMessage = message ??
        "Certificado no encontrado, cédula o fecha de nacimiento ingresados de manera incorrecta";
    AlertDialogWidget.showGenericDialog(context, "Error", newMessage);
  }

  @override
  void initState() {
    super.initState();
    String formattedDate = "Selecionar una fecha";
    if (_selectedDate != null) {
      formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
    dateInput.text = formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Certificado COVID'),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16, left: 16, bottom: 16),
                child: TextFormField(
                  maxLength: 13,
                  maxLines: 1,
                  minLines: 1,
                  controller: dniInput,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.perm_identity),
                    labelText: "Numero de cédula",
                    hintStyle: const TextStyle(fontFamily: "AvenirNext"),
                    labelStyle: const TextStyle(fontFamily: "AvenirNext"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Debe ingresar un título.";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, right: 16, left: 16, bottom: 16),
                child: TextFormField(
                  readOnly: true,
                  controller: dateInput,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.calendar_today),
                    labelText: "Fecha de nacimiento",
                    hintStyle: const TextStyle(fontFamily: "AvenirNext"),
                    labelStyle: const TextStyle(fontFamily: "AvenirNext"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Debe ingresar un título.";
                    }
                    return null;
                  },
                  onTap: () async {
                    _presentDatePicker();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  height: 50,
                  // width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                    onPressed: () {
                      _getVaccinationData(context);
                    },
                    child: const Text(
                      'Buscar',
                      style: TextStyle(color: Colors.white, fontSize: 25),
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
}
