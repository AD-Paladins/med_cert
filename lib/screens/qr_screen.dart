import 'package:flutter/material.dart';
import 'package:med_cert/util/encryptioin.dart';
import 'package:med_cert/widgets/flutter_ticket_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatefulWidget {
  final String dni;
  final String birthDate;

  const QrScreen({Key? key, required this.dni, required this.birthDate})
      : super(key: key);
  @override
  _QrScreenState createState() => _QrScreenState();
}
// "form[identificacion]=${widget.dni}&form[fechanacimiento]=${widget.dni}";

class _QrScreenState extends State<QrScreen> {
  @override
  Widget build(BuildContext context) {
    // String dataString = "${widget.dni};${widget.dni}";
    String dataString = "0926744897;1988-08-18";

    String encrypted =
        EncryptionUtil.shared.getEncryptedStringFrom(text: dataString);
    // String decrypted =
    // EncryptionUtil.shared.getDecryptedStringFrom(text: encrypted);

    var qrImage = QrImage(
      data: encrypted,
      version: QrVersions.auto,
      size: 300,
      gapless: false,
      // embeddedImage: const AssetImage('assets/safe-travels-stamp.png'),
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
      foregroundColor: Colors.blue.shade900,
      // embeddedImageStyle: QrEmbeddedImageStyle(
      //   size: const Size(60, 60),
      // ),
    );
    bool status = false;
    // ignore: dead_code
    Color statusColor = status ? Colors.green.shade400 : Colors.red.shade700;
    // ignore: dead_code
    String statusString = status ? "Vaccinated: YES" : "Vaccinated: NO";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi QR'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: FlutterTicketWidget(
          width: 350.0,
          height: 500.0,
          isCornerRounded: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(width: 2.0, color: statusColor),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Text(statusString,
                              style: TextStyle(
                                  color: statusColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    // Row(
                    //   children: const <Widget>[
                    //     Text(
                    //       'SLM',
                    //       style: TextStyle(
                    //           color: Colors.black, fontWeight: FontWeight.bold),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.only(left: 8.0),
                    //       child: Icon(
                    //         Icons.flight_takeoff,
                    //         color: Colors.blueGrey,
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.only(left: 8.0),
                    //       child: Text(
                    //         'BTL',
                    //         style: TextStyle(
                    //             color: Colors.black,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     )
                    //   ],
                    // )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Vaccination Certificate',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ticketDetailsWidget(
                      'Name', 'Andres David', 'Date Vaccination', '24-12-2018'),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 24.0, left: 30.0, right: 30.0),
                  child: Center(
                    child: qrImage,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 12.0),
                //   child: SizedBox(
                //     height: 121,
                //     child: Expanded(
                //         child: SingleChildScrollView(
                //       scrollDirection: Axis.vertical,
                //       child: Column(
                //         children: <Widget>[
                //           ticketDetailsWidget('Name', 'Andres David',
                //               'Date Vaccination', '24-12-2018'),
                //           ticketDetailsWidget('Name', 'Andres David',
                //               'Date Vaccination', '24-12-2018'),
                //           ticketDetailsWidget('Surname', 'Paladines Garcia',
                //               'Date Vaccination', '24-12-2018'),
                //           Padding(
                //             padding:
                //                 const EdgeInsets.only(top: 4.0, right: 10.0),
                //             child: ticketDetailsWidget(
                //                 'Flight', '76836A45', 'Gate', '66B'),
                //           ),
                //         ],
                //       ),
                //     )),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc,
      String secondTitle, String secondDesc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  firstDesc,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                secondTitle,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  secondDesc,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
