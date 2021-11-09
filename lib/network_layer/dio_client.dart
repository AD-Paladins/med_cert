import 'dart:io';

import 'package:dio/dio.dart';
import 'package:med_cert/entities/certificate.dart';

class DioClient {
  static DioClient shared = DioClient();
  final Dio _dio = Dio();

  final _baseUrl = 'https://certificados-vacunas.msp.gob.ec';

  Future<Map> getVaccinationData(
      {required String dni, required String birthDate}) async {
    Map retrievedUser = {};

    try {
      Map request = {
        "form[identificacion]": dni,
        "form[fechanacimiento]": birthDate,
        "form[cttipoidentificacion]": 6
      };
      FormData formData = FormData.fromMap({
        "form[identificacion]": dni,
        "form[fechanacimiento]": birthDate,
        "form[cttipoidentificacion]": 6
      });
      Response response = await _dio.post(_baseUrl + '/tomapacientemsp',
          data: formData, options: Options(responseType: ResponseType.json));
      retrievedUser = response.data;
      // ignore: avoid_print
      print('User created: $retrievedUser');
    } catch (e) {
      print('Error creating user: $e');
    }
    return retrievedUser;
  }
}
