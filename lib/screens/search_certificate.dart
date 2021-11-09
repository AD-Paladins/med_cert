import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:med_cert/entities/certificate.dart';
import 'package:med_cert/network_layer/dio_client.dart';
import 'package:med_cert/screens/main_screen.dart';
import 'package:med_cert/services/vaccine_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, this.restorationId}) : super(key: key);
  final String? restorationId;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DateTime? _selectedDate;
  bool loading = false;
  TextEditingController dniInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  String _vaccineName = "";
  String _message = "";

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
          formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        }
        dateInput.text = formattedDate;
      });
    });
  }

  void showAlertDialog(BuildContext context, String title, String message) {
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

  Future<void> _getVaccinationData() async {
    try {
      var result = await VaccineService.shared
          .getVaccinationData(dni: dniInput.text, birthDate: dateInput.text);
      Certificate certificate = result as Certificate;
      setState(() {
        _vaccineName = certificate.data.datavacuna.first.nomvacuna;
        _message = certificate.data.message;
      });
    } catch (error) {
      showAlertDialog(context, "Error",
          "Certificado no encontrado, cédula o fecha de nacimiento ingresados de manera incorrecta");
    }
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
        title: Text('Buscar Certificado COVID'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 16),
            child: TextFormField(
              maxLength: 13,
              maxLines: 1,
              minLines: 1,
              controller: this.dniInput,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration(
                icon: const Icon(Icons.perm_identity),
                labelText: "Numero de cédula",
                hintStyle: TextStyle(fontFamily: "AvenirNext"),
                labelStyle: TextStyle(fontFamily: "AvenirNext"),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
            padding:
                const EdgeInsets.only(top: 0, right: 16, left: 16, bottom: 16),
            child: TextFormField(
              readOnly: true,
              controller: this.dateInput,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration(
                icon: const Icon(Icons.calendar_today),
                labelText: "Fecha de nacimiento",
                hintStyle: TextStyle(fontFamily: "AvenirNext"),
                labelStyle: TextStyle(fontFamily: "AvenirNext"),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Debe ingresar un título.";
                }
                return null;
              },
              onTap: () async {
                print("fadasadfdfsdfsdfsdf");
                _presentDatePicker();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 50,
              // width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              child: TextButton(
                onPressed: () {
                  _getVaccinationData();
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (_) => MainScreen()));
                },
                child: const Text(
                  'Buscar',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(_vaccineName),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(_message),
          ),
        ],
      ),
    );
  }
}
