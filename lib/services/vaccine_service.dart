import 'package:med_cert/entities/certificate.dart';
import 'package:med_cert/entities/certificate_astrazeneca.dart';
import 'package:med_cert/entities/error_response.dart';
import 'package:med_cert/network_layer/dio_client.dart';

class VaccineService {
  static VaccineService shared = VaccineService();

  getVaccinationData({required String dni, required String birthDate}) async {
    var response = await DioClient.shared
        .getVaccinationData(dni: dni, birthDate: birthDate);
    try {
      Certificate certResp = Certificate.fromJson(response);
      CertificateAstrazeneca certAstResp =
          CertificateAstrazeneca.fromJson(response);
    } catch (error) {}
    ErrorResponse errorResponse = ErrorResponse.fromJson(response);
  }
}
