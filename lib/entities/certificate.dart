// To parse this JSON data, do
//
//     final certificate = certificateFromJson(jsonString);

import 'dart:convert';

Certificate certificateFromJson(String str) =>
    Certificate.fromJson(json.decode(str));

String certificateToJson(Certificate data) => json.encode(data.toJson());

class Certificate {
  Certificate({
    required this.data,
  });

  Data data;

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.status,
    required this.message,
    required this.datavacuna,
    required this.datapersona,
  });

  bool status;
  String message;
  List<Datavacuna> datavacuna;
  List<Datapersona> datapersona;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
        datavacuna: List<Datavacuna>.from(
            json["datavacuna"].map((x) => Datavacuna.fromJson(x))),
        datapersona: List<Datapersona>.from(
            json["datapersona"].map((x) => Datapersona.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "datavacuna": List<dynamic>.from(datavacuna.map((x) => x.toJson())),
        "datapersona": List<dynamic>.from(datapersona.map((x) => x.toJson())),
      };
}

class Datapersona {
  Datapersona({
    required this.fechanacimiento,
    required this.nombres,
    required this.idencrypt,
  });

  String fechanacimiento;
  String nombres;
  String idencrypt;

  factory Datapersona.fromJson(Map<String, dynamic> json) => Datapersona(
        fechanacimiento: json["fechanacimiento"],
        nombres: json["nombres"],
        idencrypt: json["idencrypt"],
      );

  Map<String, dynamic> toJson() => {
        "fechanacimiento": fechanacimiento,
        "nombres": nombres,
        "idencrypt": idencrypt,
      };
}

class Datavacuna {
  Datavacuna({
    required this.nomvacuna,
    required this.dosisaplicada,
    required this.fechavacuna,
  });

  String nomvacuna;
  int dosisaplicada;
  DateTime fechavacuna;

  factory Datavacuna.fromJson(Map<String, dynamic> json) => Datavacuna(
        nomvacuna: json["nomvacuna"],
        dosisaplicada: json["dosisaplicada"],
        fechavacuna: DateTime.parse(json["fechavacuna"]),
      );

  Map<String, dynamic> toJson() => {
        "nomvacuna": nomvacuna,
        "dosisaplicada": dosisaplicada,
        "fechavacuna":
            "${fechavacuna.year.toString().padLeft(4, '0')}-${fechavacuna.month.toString().padLeft(2, '0')}-${fechavacuna.day.toString().padLeft(2, '0')}",
      };
}
