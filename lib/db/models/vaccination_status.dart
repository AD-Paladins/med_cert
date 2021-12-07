import 'package:med_cert/db/client/data_base_client.dart';
import 'package:med_cert/util/date_utils.dart';
import 'package:sqflite/sqflite.dart';

class VaccinationStatusModel {
  int id;
  String name;
  String identification;
  DateTime birthDate;
  String json;
  bool isFavorite;

  VaccinationStatusModel(
      {required this.id,
      required this.name,
      required this.identification,
      required this.birthDate,
      required this.json,
      required this.isFavorite});

  static VaccinationStatusModel fromMap(Map<String, dynamic> map) {
    print(map);
    print(map.toString());
    var idwhat = map[0];
    print(idwhat);
    int id = map[0];
    String name = map[1];
    String identification = map[2];
    String birthDate = map[3];
    String json = map[4];
    String favorite = map[5];
    DateTime newDate =
        DateTimeUtils.shared.dateFromString(birthDate) ?? DateTime.now();
    bool isFavorite = favorite.toLowerCase() == 'true';
    VaccinationStatusModel vacc = VaccinationStatusModel(
        id: id,
        name: name,
        identification: identification,
        birthDate: newDate,
        json: json,
        isFavorite: isFavorite);
    return vacc;
  }

  static VaccinationStatusModel fromSelectMap(Map<String, dynamic> map) {
    int id = map['_id'];
    String name = map['name'];
    String identification = map['identification'];
    String birthDate = map['birthDate'];
    String json = map['json'];
    String favorite = map['isFavorite'];
    DateTime newDate =
        DateTimeUtils.shared.dateFromString(birthDate) ?? DateTime.now();
    bool isFavorite = favorite.toLowerCase() == 'true';
    VaccinationStatusModel vacc = VaccinationStatusModel(
        id: id,
        name: name,
        identification: identification,
        birthDate: newDate,
        json: json,
        isFavorite: isFavorite);
    return vacc;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'identification': identification,
      'birthDate': DateTimeUtils.shared.stringFromDate(birthDate),
      'json': json,
      'isFavorite': isFavorite.toString()
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id,\nname: $name,\nidentification: $identification,\nbirthDate: $birthDate}';
  }
}

class TodoProvider {
  final String tableVaccinationStatus = 'vaccination_status';
  final String columnId = '_id';
  final String name = 'name';
  final String identification = 'identification';
  final String birthDate = 'birthDate';
  final String json = 'json';
  final String isFavorite = 'isFavorite';

  Future<VaccinationStatusModel> insert(VaccinationStatusModel item) async {
    Database? db = DataBaseClient.shared.db;
    if (db != null) {
      item.id = await db.insert(tableVaccinationStatus, item.toMap());
    } else {
      throw Exception("No se pudo conectar a la base de datos");
    }
    return item;
  }

  Future<List<VaccinationStatusModel>?> getAllVaccinationStatus() async {
    Database? db = DataBaseClient.shared.db;
    if (db != null) {
      final List<Map<String, dynamic>> maps =
          await db.query(tableVaccinationStatus);
      return List.generate(maps.length, (i) {
        DateTime newDate =
            DateTimeUtils.shared.dateFromString(maps[i][birthDate]) ??
                DateTime.now();
        bool isFav = maps[i][isFavorite].toString().toLowerCase() == "true";
        return VaccinationStatusModel(
            id: maps[i][columnId],
            name: maps[i][name],
            identification: maps[i][identification],
            birthDate: newDate,
            json: maps[i][json],
            isFavorite: isFav);
      });
    }
  }

  Future<VaccinationStatusModel?> getVaccinationStatus(int id) async {
    Database? db = DataBaseClient.shared.db;
    if (db != null) {
      try {
        List<Map<String, dynamic>> maps = await db.query(tableVaccinationStatus,
            columns: [columnId, name, identification, birthDate, json],
            where: '$columnId = ?',
            whereArgs: [id]);
        if (maps.isNotEmpty) {
          return VaccinationStatusModel.fromMap(maps.first);
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    } else {
      throw Exception("selectOne: No se pudo conectar a la base de datos");
    }
  }

  Future<VaccinationStatusModel?> getVaccinationStatusBy(
      {required String dni}) async {
    Database? db = DataBaseClient.shared.db;
    if (db != null) {
      try {
        List<Map<String, dynamic>> maps = await db.query(tableVaccinationStatus,
            columns: [
              columnId,
              name,
              identification,
              birthDate,
              json,
              isFavorite
            ],
            where: '$identification = ?',
            whereArgs: [dni]);
        if (maps.isNotEmpty) {
          return VaccinationStatusModel.fromSelectMap(maps.first);
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    } else {
      throw Exception("selectOne: No se pudo conectar a la base de datos");
    }
  }

  Future<int> delete({required String dni}) async {
    Database? db = DataBaseClient.shared.db;
    if (db != null) {
      String likeDni = '%$dni%';
      return await db.delete(tableVaccinationStatus,
          where: '$identification LIKE ?', whereArgs: [likeDni]);
    } else {
      throw Exception("delete: No se pudo conectar a la base de datos");
    }
  }

  Future<int> update(VaccinationStatusModel todo) async {
    Database? db = DataBaseClient.shared.db;
    if (db != null) {
      return await db.update(tableVaccinationStatus, todo.toMap(),
          where: '$columnId = ?', whereArgs: [todo.id]);
    } else {
      throw Exception("update: No se pudo conectar a la base de datos");
    }
  }

  Future close() async {
    Database? db = DataBaseClient.shared.db;
    if (db != null) {
      db.close();
    } else {
      throw Exception("close: No se pudo conectar a la base de datos");
    }
  }
}
