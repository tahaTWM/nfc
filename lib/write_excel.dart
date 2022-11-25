// ignore_for_file: avoid_print, unnecessary_this

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:flutter/material.dart';

class WriteExecl extends StatelessWidget {
  List cardsNo = [];
  WriteExecl(this.cardsNo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createExcel();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Future<void> _createExcel() async {
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    sheet.enableSheetCalculations();

    for (var i = 0; i < this.cardsNo.length; i++) {
      sheet
          .getRangeByName('A${i + 1}')
          .setText("Card Number for card ${i + 1}");
      sheet.getRangeByName('B${i + 1}').setText(this.cardsNo[i].toString());
    }

    final List<int> bytes = workbook.saveAsStream();

    await File("/storage/emulated/0/file.xlsx")
        .writeAsBytes(bytes, mode: FileMode.write);

    workbook.dispose();
  }
}
