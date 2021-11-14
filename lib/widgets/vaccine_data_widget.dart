library flutter_ticket_widget;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:med_cert/util/date_utils.dart';

class VaccineDataWidget extends StatefulWidget {
  final String name;
  final DateTime date;
  final int number;

  const VaccineDataWidget(
      {Key? key, required this.name, required this.date, required this.number})
      : super(key: key);

  @override
  _VaccineDataWidgetState createState() => _VaccineDataWidgetState();
}

class _VaccineDataWidgetState extends State<VaccineDataWidget> {
  @override
  Widget build(BuildContext context) {
    String dateString = DateTimeUtils.shared.stringFromDate(widget.date) ??
        widget.date.toString();
    return Card(
      elevation: 2.0,
      shadowColor: const Color(0x77CDCDFF),
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              height: 65,
              child: Image.asset(
                "assets/icons/sirynge.png",
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    Text("Dosis aplicada: ",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onPrimary)),
                    Text(widget.number.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onPrimary)),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8),
              //   child: Text(widget.number.toString(),
              //       style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.w500,
              //           color: Theme.of(context).colorScheme.onPrimary)),
              // ),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text("Fecha de dosis: ",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      Text(dateString,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onPrimary)),
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
