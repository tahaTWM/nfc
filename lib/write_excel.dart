// ignore_for_file: avoid_print, unnecessary_this, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class WriteExecl extends StatefulWidget {
  List cardsNo = [];
  WriteExecl(this.cardsNo);

  @override
  State<WriteExecl> createState() => _WriteExeclState();
}

class _WriteExeclState extends State<WriteExecl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: widget.cardsNo.length,
          itemBuilder: (context, index) {
            List item = widget.cardsNo[index];
            print(item);
            return ListTile(
              title: Text(item[0].toString()),
              trailing: Checkbox(
                value: item[1],
                onChanged: (value) {
                  setState(() {
                    item[1] = value;
                  });
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _createExcel();
        },
        label: Text("Export Excel", style: TextStyle(fontSize: 25)),
        icon: const Icon(Icons.ios_share, size: 30),
        extendedPadding: EdgeInsets.symmetric(vertical: 100, horizontal: 80),
      ),
    );
  }

  Future<void> _createExcel() async {
    List newAccountNo = [];

    for (var i = 0; i < widget.cardsNo.length; i++) {
      if (widget.cardsNo[i][1] == true) {
        newAccountNo.add(widget.cardsNo[i][0]);
      }
    }
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    sheet.enableSheetCalculations();

    // permissions
    if (await Permission.storage.request().isGranted) {
      Toast.show("permission is Good",
          duration: Toast.lengthShort,
          gravity: Toast.center,
          backgroundColor: Colors.blue);
    } else {
      openAppSettings();
      Toast.show("premissions is not Good",
          duration: Toast.lengthShort,
          gravity: Toast.center,
          backgroundColor: Colors.red);
    }

    for (var i = 0; i < newAccountNo.length; i++) {
      print(newAccountNo[i]);
      sheet
          .getRangeByName('A${i + 1}')
          .setText("Card Number for card ${i + 1}");
      sheet.getRangeByName('B${i + 1}').setText(newAccountNo[i].toString());
    }

    try {
      final List<int> bytes = workbook.saveAsStream();

      await File(
              "/storage/emulated/0/Download/${DateTime.now().microsecondsSinceEpoch}.xlsx")
          .writeAsBytes(bytes, mode: FileMode.write);
      Toast.show("Export Done",
          duration: Toast.lengthShort,
          gravity: Toast.center,
          backgroundColor: Colors.green);
      Navigator.pop(context);
    } catch (e) {
      print(e);
      Toast.show(e.toString(),
          duration: Toast.lengthLong,
          gravity: Toast.center,
          backgroundColor: Colors.red);
    }

    workbook.dispose();
  }
}
