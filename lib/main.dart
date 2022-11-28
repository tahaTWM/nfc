// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print, unused_local_variable, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, import_of_legacy_library_into_null_safe, unnecessary_new, prefer_interpolation_to_compose_strings, avoid_function_literals_in_foreach_calls
import 'package:flutter/material.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

import 'write_excel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String title = "";
  List cardNumbers = [];
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    ToastContext().init(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title.toString(),
              style: TextStyle(fontSize: 23),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 23),
                decoration: InputDecoration(
                    suffix: Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                controller.clear();
                                cardNumbers = [];
                              });
                              Toast.show("All Data is Cleared",
                                  duration: Toast.lengthShort,
                                  gravity: Toast.center,
                                  backgroundColor: Colors.red);
                            },
                            child: Icon(Icons.clear_rounded,
                                color: Colors.red, size: 27)),
                        SizedBox(height: 10),
                        GestureDetector(
                            onTap: () {
                              if (cardNumbers.length == 1) {
                                Clipboard.setData(
                                    ClipboardData(text: cardNumbers[0]));
                              } else {
                                Clipboard.setData(ClipboardData(
                                    text: cardNumbers.toString()));
                              }
                              Toast.show("Data Copied to Clipboard",
                                  duration: Toast.lengthShort,
                                  gravity: Toast.center,
                                  backgroundColor: Colors.blue);
                            },
                            child: Icon(Icons.copy_rounded,
                                color: Colors.blue, size: 27)),
                        SizedBox(height: 10),
                        GestureDetector(
                            onTap: () {
                              if (cardNumbers.length == 1) {
                                Clipboard.setData(
                                    ClipboardData(text: cardNumbers[0]));
                                setState(() {
                                  controller.clear();
                                  cardNumbers = [];
                                });
                              } else {
                                Clipboard.setData(ClipboardData(
                                    text: cardNumbers.toString()));
                                setState(() {
                                  controller.clear();
                                  cardNumbers = [];
                                });
                              }
                              Toast.show("Data Cutted to Clipboard",
                                  duration: Toast.lengthShort,
                                  gravity: Toast.center,
                                  backgroundColor: Colors.green);
                            },
                            child: Icon(Icons.cut_sharp,
                                color: Colors.green, size: 27)),
                        SizedBox(height: 10),
                        GestureDetector(
                            onTap: () {
                              var insideList;
                              List all = [];
                              cardNumbers.forEach((element) {
                                all.add([element, true]);
                              });
                              print(all);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WriteExecl(all)));
                              Toast.show("Save to Excel",
                                  duration: Toast.lengthShort,
                                  gravity: Toast.center,
                                  backgroundColor: Colors.green);
                            },
                            child: Icon(Icons.save_alt_rounded,
                                color: Colors.green, size: 27)),
                      ],
                    ),
                    border: InputBorder.none),
                maxLines: 30,
                minLines: 1,
                controller: controller,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var cardDetails = await CardScanner.scanCard();

          var cardnumName = "";
          cardnumName =
              '${cardDetails!.cardNumber}\n${cardDetails.cardHolderName}';

          setState(() {
            title = cardnumName;
            cardNumbers.add(cardDetails.cardNumber.toString());
            controller.text = cardNumbers.length == 1
                ? cardNumbers[0].toString()
                : cardNumbers.toString();
          });
        },
        tooltip: 'Increment',
        label: Text("Scan Card No.", style: TextStyle(fontSize: 25)),
        icon: const Icon(Icons.add, size: 30),
        extendedPadding: EdgeInsets.symmetric(vertical: 100, horizontal: 80),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
