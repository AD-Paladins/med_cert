library flutter_ticket_widget;

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:med_cert/entities/certificate.dart';
import 'package:med_cert/screens/vaccines_data_result_screen.dart';
import 'package:med_cert/util/date_utils.dart';

class SearchHistoryCellWidget extends StatefulWidget {
  final Certificate certificate;
  final String name;
  final int number;
  final String identification;
  final DateTime birthDate;
  final dynamic handler;

  const SearchHistoryCellWidget(
      {Key? key,
      required this.certificate,
      required this.name,
      required this.number,
      required this.identification,
      required this.birthDate,
      required this.handler})
      : super(key: key);

  @override
  _SearchHistoryCellWidgetState createState() =>
      _SearchHistoryCellWidgetState();
}

class _SearchHistoryCellWidgetState extends State<SearchHistoryCellWidget> {
  Certificate? newCertificate;

  @override
  Widget build(BuildContext context) {
    String numDosisAplied =
        widget.certificate.data.datavacuna.length.toString();
    double nameTextWidth = MediaQuery.of(context).size.width - 180;
    Icon arrowIcon = Platform.isAndroid
        ? const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          )
        : const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          );
    return InkWell(
      // onTap: () => _goToGet(widget.certificate, context),
      onTap: () => widget.handler,
      child: Card(
        elevation: 2.0,
        shadowColor: const Color(0x77CDCDFF),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 125,
                child: Image.asset(
                  "assets/icons/sirynge.png",
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    height: 85,
                    width: nameTextWidth,
                    child: Text(
                      widget.name,
                      maxLines: 3,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    children: [
                      Text("Dosis aplicadas: ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(numDosisAplied,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onPrimary)),
                    ],
                  ),
                ),
              ],
            ),
            arrowIcon,
          ],
        ),
      ),
    );
  }
}
