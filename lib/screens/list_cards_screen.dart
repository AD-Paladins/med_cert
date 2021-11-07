import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Card App")),
        body: Column(
          children: [
            Card(
              child: ListTile(
                leading: Image.asset("images/1.png"),
                title: Text(
                  "adadasdad",
                  style: TextStyle(fontSize: 19),
                ),
                subtitle: Padding(
                    padding: EdgeInsets.only(top: 2, bottom: 2),
                    child: Text(
                      "adasdsda",
                      style: TextStyle(fontSize: 12),
                    )),
              ),
            ),
          ],
        ),
        drawer: Drawer(),
      ),
    );
  }
}
