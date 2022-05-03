import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:garranty/garranty_card.dart';
import 'package:garranty/msb.dart';
import 'package:garranty/pinput_page.dart';
import 'package:garranty/register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

String? serial, phone;

void logD(s) {
  if (kDebugMode) {
    print(s);
  }
}

void main() {
  setUrlStrategy(PathUrlStrategy());
  serial = Uri.base.queryParameters["serial"];
  phone = Uri.base.queryParameters["phone"];
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StartPage(),
      theme: ThemeData(
        fontFamily: GoogleFonts.lalezar().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _phone = TextEditingController(text: phone);
  final TextEditingController _serial = TextEditingController(text: serial);
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  int code = 0;
  String res = '';

  void reg(bool isNew) async {
    var _pr = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    if (_formKey2.currentState!.validate() &&
        _formKey.currentState!.validate()) {
      _pr.show(message: 'در حال انجام');
      var random = Random();
      code = random.nextInt(8999) + 1000;
      logD(code.toString());
      otp = code.toString();
      var otpBody = {
        'receptor': _phone.text,
        'token': code.toString(),
        'template': 'OTP'
      };

      var isTrue = false, conf = false;
      dbQuery('garranty', (status, responseBody) async {
        if (status == 200) {
          //logD(status);
          try {
            List bodyList = jsonDecode(responseBody);
            for (var element in bodyList) {
              try {
                Map elementBody = jsonDecode(element['body']);
                if (_serial.text == element['id']) {
                  postReq(otpHost, otpHostSsl, otpUrl, otpBody, (b, s) {
                    logD("$s$b");
                  });
                  _pr.hide();
                  conf = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PinPutPage()),
                  );
                  if (conf) {
                    serial = _serial.text;
                    phone = _phone.text;
                    if (elementBody.containsKey('date')) {
                      //logD(element['id']);
                      isTrue = true;
                      serial = _serial.text;
                      card.clear();
                      card.addAll({'id': serial});
                      card.addAll(elementBody);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GCard()),
                      );
                    } else {
                      if (isNew) {
                        isTrue = true;
                        card.clear();
                        card.addAll({'id': element['id']});
                        if (elementBody.isNotEmpty) card.addAll(elementBody);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      }
                    }
                  }
                }
              } catch (e) {
                logD(e);
              }
            }
            if (!isTrue) {
              _pr.hide();
              setState(() {
                _serial.setText('');
              });
              _formKey2.currentState!.validate();
            }
          } catch (e) {
            logD(e);
          }
        } else {
          logD(status);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return FlutterWebFrame(
      builder: (c) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: GoogleFonts.lalezar().fontFamily,
          ),
          title: 'استعلام گارانتی محصولات',
          home: Scaffold(
              body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: const Text('استعلام گارانتی محصولات'),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phone,
                      textAlign: TextAlign.center,
                      maxLength: 13,
                      validator: (t) {
                        if (t!.length >= 10 &&
                            (t.startsWith('09') ||
                                t.startsWith('9') ||
                                t.startsWith('+989'))) {
                          return null;
                        }
                        return 'شماره اشتباه';
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'شماره موبایل',
                          icon: Icon(Icons.smartphone)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey2,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _serial,
                      textAlign: TextAlign.center,
                      validator: (t) {
                        if (t!.length < 5) {
                          return 'سریال اشتباه';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'شماره سریال',
                          icon: Icon(Icons.qr_code)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 48, right: 8, top: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        reg(false);
                      },
                      child: const Text('استعلام'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 48, right: 8, top: 8),
                  child: TextButton(
                    onPressed: () async {
                      reg(true);
                    },
                    child: const Text('فعالسازی محصول جدید'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 96.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'تمامی حقوق متعلق به کیمیا الکترونیک(الکترو کالا) است.',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '051-38586195',
                      style: TextStyle(fontSize: 11),
                    ),
                    Text(
                      'در صورت بروز مشکل با شماره روبرو تماس بگیرید:',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                //Text(res),
              ],
            ),
          )),
          debugShowCheckedModeBanner: false,
        );
      },
      maximumSize: const Size(400.0, 300.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey,
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  var ttimer, _pr;
  bool f = false;

  void handle() {
    _pr = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    if (!f) {
      _pr.show(message: '');
      f = true;
      ttimer.cancel();
      ttimer = timer(1000);
    } else {
      ttimer.cancel();
      _pr.hide();
      try {
        dispose();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      }catch(e){
        logD(e);
      }
    }
  }

  Timer timer([int milliseconds = 500]) =>
      Timer(Duration(milliseconds: milliseconds), handle);

  @override
  Widget build(BuildContext context) {
    ttimer = timer(500);
    return const MaterialApp(
      home: Scaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}
