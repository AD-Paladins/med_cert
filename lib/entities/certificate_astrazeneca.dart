// To parse this JSON data, do
//
// For ASTRAZENECA only
//     final certificateAstrazeneca = certificateAstrazenecaFromJson(jsonString);

import 'dart:convert';

CertificateAstrazeneca certificateAstrazenecaFromJson(String str) =>
    CertificateAstrazeneca.fromJson(json.decode(str));

String certificateAstrazenecaToJson(CertificateAstrazeneca data) =>
    json.encode(data.toJson());

class CertificateAstrazeneca {
  bool status;
  String message;
  List<Vacunadatum> vacunadata;
  Pacientedata pacientedata;

  CertificateAstrazeneca({
    required this.status,
    required this.message,
    required this.vacunadata,
    required this.pacientedata,
  });

  factory CertificateAstrazeneca.fromJson(dynamic json) =>
      CertificateAstrazeneca(
        status: json["status"],
        message: json["message"],
        vacunadata: List<Vacunadatum>.from(
            json["vacunadata"].map((x) => Vacunadatum.fromJson(x))),
        pacientedata: Pacientedata.fromJson(json["pacientedata"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "vacunadata": List<dynamic>.from(vacunadata.map((x) => x.toJson())),
        "pacientedata": pacientedata.toJson(),
      };
}

class Pacientedata {
  Pacientedata({
    required this.idpacinete,
    required this.correo,
  });

  int idpacinete;
  String correo;

  factory Pacientedata.fromJson(Map<String, dynamic> json) => Pacientedata(
        idpacinete: json["idpacinete"],
        correo: json["correo"],
      );

  Map<String, dynamic> toJson() => {
        "idpacinete": idpacinete,
        "correo": correo,
      };
}

class Vacunadatum {
  Vacunadatum({
    required this.nombrevacuna,
    required this.dosis,
    required this.fechavacunacion,
  });

  String nombrevacuna;
  int dosis;
  Fechavacunacion fechavacunacion;

  factory Vacunadatum.fromJson(Map<String, dynamic> json) => Vacunadatum(
        nombrevacuna: json["nombrevacuna"],
        dosis: json["dosis"],
        fechavacunacion: Fechavacunacion.fromJson(json["fechavacunacion"]),
      );

  Map<String, dynamic> toJson() => {
        "nombrevacuna": nombrevacuna,
        "dosis": dosis,
        "fechavacunacion": fechavacunacion.toJson(),
      };
}

class Fechavacunacion {
  Fechavacunacion({
    required this.date,
    required this.timezoneType,
    required this.timezone,
  });

  DateTime date;
  int timezoneType;
  String timezone;

  factory Fechavacunacion.fromJson(Map<String, dynamic> json) =>
      Fechavacunacion(
        date: DateTime.parse(json["date"]),
        timezoneType: json["timezone_type"],
        timezone: json["timezone"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "timezone_type": timezoneType,
        "timezone": timezone,
      };
}
