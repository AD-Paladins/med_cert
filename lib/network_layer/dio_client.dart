import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DioClient {
  static DioClient shared = DioClient();
  final Dio _dio = Dio();

  final _baseUrl = 'https://certificados-vacunas.msp.gob.ec';

  Future<Map> getVaccinationData(
      {required String dni, required String birthDate}) async {
    Map retrievedUser = {};

    try {
      FormData formData = FormData.fromMap({
        "form[identificacion]": dni.trim(),
        "form[fechanacimiento]": birthDate.trim(),
        "form[cttipoidentificacion]": 6
      });
      Response response = await _dio.post(_baseUrl + '/tomapacientemsp',
          data: formData, options: Options(responseType: ResponseType.json));
      retrievedUser = response.data;
    } catch (e) {
      print('Error creating user: $e');
    }
    return retrievedUser;
  }

  Future<String> getPDFCertificte({required String token}) async {
    String uri = _baseUrl + '/viewpdfcertificadomsp/' + token;
    String savePath = await getFilePath(token);
    try {
      await _dio.download(
        uri,
        savePath,
        deleteOnError: true,
      ); //.onError((error, stackTrace) => null);
      return savePath;
    } catch (e) {
      return '';
    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';
    Directory dir = await getApplicationDocumentsDirectory();
    path = '${dir.path}/$uniqueFileName.pdf';
    return path;
  }
}
