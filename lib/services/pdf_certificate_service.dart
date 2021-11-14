// https://certificados-vacunas.msp.gob.ec/viewpdfcertificadomsp/AjhyGz@@@Gnuig2yPUr70k+w==

import 'package:med_cert/network_layer/dio_client.dart';

class VaccinePDFService {
  static VaccinePDFService shared = VaccinePDFService();

  Future<String?> getPDFVaccinationData({required String token}) async {
    var response = await DioClient.shared.getPDFCertificte(token: token);
    try {
      return response;
    } catch (error) {
      Exception("Error al descargar archivo.");
    }
  }
}
