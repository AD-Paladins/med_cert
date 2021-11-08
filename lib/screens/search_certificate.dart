import 'package:flutter/material.dart';
import 'package:med_cert/screens/main_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool loading = false;
  TextEditingController tituloController = new TextEditingController();
  TextEditingController descripcionController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // _setUser();
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
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: TextFormField(
              maxLength: 13,
              maxLines: 1,
              minLines: 1,
              controller: this.tituloController,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration(
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
            padding: const EdgeInsets.only(bottom: 16),
            child: TextFormField(
              maxLength: 10,
              maxLines: 1,
              minLines: 1,
              controller: this.tituloController,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration(
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
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => MainScreen()));
                },
                child: const Text(
                  'Buscar',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
