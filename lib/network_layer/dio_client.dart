import 'package:dio/dio.dart';
import 'package:med_cert/entities/certificate.dart';

class DioClient {
  final Dio _dio = Dio();

  final _baseUrl = 'https://certificados-vacunas.msp.gob.ec';

  Future<Certificate?> createUser(
      {required String dni, required String birthDate}) async {
    Certificate? retrievedUser;

    try {
      Response response = await _dio.post(
        _baseUrl + '/tomapacientemsp',
        data: {
          'form[identificacion]': dni, //0926744897,
          'form[fechanacimiento]': birthDate //1988-08-18
        },
      );
      print('User created: ${response.data}');
      retrievedUser = Certificate.fromJson(response.data);
    } catch (e) {
      print('Error creating user: $e');
    }
    return retrievedUser;
  }
}
