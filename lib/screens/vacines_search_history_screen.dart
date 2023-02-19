import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:med_cert/db/models/vaccination_status.dart';
import 'package:med_cert/entities/certificate.dart';
import 'package:med_cert/screens/vaccines_data_result_screen.dart';
import 'package:med_cert/util/date_utils.dart';
import 'package:med_cert/util/encryptioin.dart';
import 'package:med_cert/widgets/search_history_cell_widget.dart';

class VaccinesSearchHistoryScreen extends StatefulWidget {
  const VaccinesSearchHistoryScreen({Key? key}) : super(key: key);
  @override
  _VaccinesSearchHistoryScreenState createState() =>
      _VaccinesSearchHistoryScreenState();
}

class _VaccinesSearchHistoryScreenState
    extends State<VaccinesSearchHistoryScreen> {
  List<VaccinationStatusModel> vaccineStatusList = [];
  Certificate? newCertificate;

  @override
  void initState() {
    super.initState();
    _getSearchHistory();
  }

  void _getSearchHistory() async {
    var listvaccines = await TodoProvider().getAllVaccinationStatus();
    if (listvaccines != null) {
      setState(() {
        vaccineStatusList = listvaccines;
      });

      for (VaccinationStatusModel vaccine in listvaccines) {
        String newJson =
            EncryptionUtil.shared.getDecryptedStringFrom(text: vaccine.json);
        print(newJson);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado de búsqueda'),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: vaccineStatusList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String jsonEncypted = vaccineStatusList[index].json;
                    String jsonString = EncryptionUtil.shared
                        .getDecryptedStringFrom(text: jsonEncypted);
                    dynamic jsonObject = json.decode(jsonString);
                    Certificate cert = Certificate.fromJson(jsonObject);
                    String dateString = DateTimeUtils.shared.stringFromDate(
                            vaccineStatusList[index].birthDate) ??
                        DateTimeUtils.shared.stringFromDate(DateTime.now())!;
                    String identification = EncryptionUtil.shared
                        .getDecryptedStringFrom(
                            text: vaccineStatusList[index].identification);

                    dynamic handler() async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => VaccinesDataResultScreen(
                                    certificate: cert,
                                    isFromMain: true,
                                    identification: identification,
                                    birthDate: dateString,
                                    isFromHistory: true,
                                  ))).then((value) {
                        Certificate? cert = value as Certificate?;
                        if (cert != null) {
                          newCertificate = cert;
                        }
                      });
                    }

                    return SearchHistoryCellWidget(
                      name: vaccineStatusList[index].name,
                      number: vaccineStatusList[index].id,
                      birthDate: vaccineStatusList[index].birthDate,
                      identification: vaccineStatusList[index].identification,
                      certificate: cert,
                      handler: handler,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
