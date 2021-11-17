import 'package:flutter/material.dart';

class VaccinesSearchHistoryScreen extends StatefulWidget {
  final String dni;
  final String birthDate;

  const VaccinesSearchHistoryScreen(
      {Key? key, required this.dni, required this.birthDate})
      : super(key: key);
  @override
  _VaccinesSearchHistoryScreenState createState() =>
      _VaccinesSearchHistoryScreenState();
}
// "form[identificacion]=${widget.dni}&form[fechanacimiento]=${widget.dni}";

class _VaccinesSearchHistoryScreenState
    extends State<VaccinesSearchHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text("TODO: Historial de busquedas (maximo 5 consultas.)");
  }
}
