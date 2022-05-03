import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
String otp='';
class PinPutPage extends StatefulWidget {

  const PinPutPage({Key? key}) : super(key: key);

  @override
  State<PinPutPage> createState() => _PinPutPageState();
}

class _PinPutPageState extends State<PinPutPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String timeS = '2:0';
  int time = 120;
  bool odd = true;
  var ttimer;

  void handleTimeout() {
    setState(() {
      odd = !odd;
      if (odd) {
        timeS = (time ~/ 60).toInt().toString() + ':' + (time % 60).toString();
        if (time > 0) {
          time -= 1;
        } else {
          Navigator.of(context).pop(false);
          ttimer.cancel();
        }
      }
    });
  }

  Timer timer([int milliseconds = 500]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ttimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.lalezar(
          fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(232, 235, 241, 0.37),
        borderRadius: BorderRadius.circular(24),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    //cnt();
    ttimer = timer(500);
    return FlutterWebFrame(
      builder: (context) {
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
                    Text(
                      'لطفا کد پیامک شده را وارد کنید:',
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.lalezar(
                          fontSize: 13, color: const Color.fromRGBO(70, 69, 66, 1)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        timeS,
                        style: GoogleFonts.lalezar(
                            fontSize: 20,
                            color: const Color.fromRGBO(70, 69, 66, 1)),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Pinput(
                        validator: (t) {
                          if (t == otp && t!.length == 4) {
                            return null;
                          }
                          return 'اشتباه';
                        },
                        autofocus: true,
                        length: 4,
                        controller: controller,
                        focusNode: focusNode,
                        defaultPinTheme: defaultPinTheme,
                        separator: const SizedBox(width: 16),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                                offset: Offset(0, 3),
                                blurRadius: 16,
                              )
                            ],
                          ),
                        ),
                        showCursor: true,
                        cursor: cursor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pop(true);
                            }
                          },
                          child: const Text('تایید'),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 96.0),
                      child: Divider(color: Colors.black,),
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
