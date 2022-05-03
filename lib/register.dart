import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:garranty/garranty_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import 'main.dart';
import 'msb.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Jalali fin = DateTime.now().toJalali();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _agent = TextEditingController();
  final TextEditingController _agentPass = TextEditingController();
  final TextEditingController _city = TextEditingController();

  @override
  Widget build(BuildContext context) {
    fin = Jalali(fin.year + 1, fin.month, fin.day, 0, 0, 0);
    String fDate = fin.year.toString() +
        '/' +
        fin.month.toString() +
        '/' +
        fin.day.toString();
    return FlutterWebFrame(
      builder: (context) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: GoogleFonts.lalezar().fontFamily,
          ),
          title: 'استعلام گارانتی محصولات',
          home: Scaffold(
            body: ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'فرم فعالسازی محصول',
                    style: GoogleFonts.lalezar(
                        fontSize: 20,
                        color: const Color.fromRGBO(70, 69, 66, 1)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      serial!,
                      style: GoogleFonts.lalezar(
                          fontSize: 20,
                          color: const Color.fromRGBO(70, 69, 66, 1)),
                    ),
                    Text(
                      'سریال:  ',
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.lalezar(
                          fontSize: 20,
                          color: const Color.fromRGBO(70, 69, 66, 1)),
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    fDate,
                    style: GoogleFonts.lalezar(
                        fontSize: 20,
                        color: const Color.fromRGBO(70, 69, 66, 1)),
                  ),
                  Text(
                    'اتمام گارانتی:  ',
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.lalezar(
                        fontSize: 20,
                        color: const Color.fromRGBO(70, 69, 66, 1)),
                  ),
                ]),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _agent,
                      textAlign: TextAlign.center,
                      maxLength: 4,
                      validator: (t) {
                        if (t!.length == 4) {
                          return null;
                        }
                        return 'شماره اشتباه';
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'کد نماینده',
                          icon: Icon(Icons.smartphone)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey1,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _agentPass,
                      textAlign: TextAlign.center,
                      maxLength: 4,
                      obscuringCharacter: "*",
                      obscureText: true,
                      validator: (t) {
                        if (t!.length == 4) {
                          return null;
                        }
                        return 'شماره اشتباه';
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'رمز نماینده',

                          icon: Icon(Icons.password)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey2,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _city,
                      textAlign: TextAlign.center,
                      validator: (t) {
                        if (t!.length >= 2) {
                          return null;
                        }
                        return 'شهر اشتباه';
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'شهر',
                          icon: Icon(Icons.location_city)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        var _pr = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false );
                        _pr.show(message: 'درحال انجام');
                        var body = {
                          'city': _city.text,
                          'date': fDate,
                          'agent': _agent.text,
                          'phone':phone,
                        };
                        card.addAll(body);
                        Map reqBody={};
                        reqBody.addAll(card);
                        reqBody.remove('id');
                        var agentT=false;
                        dbQuery('agents', (status,responseBody){
                          if(status==200){
                            List bodyList = jsonDecode(responseBody);
                            for (var element in bodyList) {
                              if(element['agent_pass'].toString().trim()==_agentPass.text && element['agent_id'].toString().trim()==_agent.text ){
                                agentT=true;
                                dbUpdate(reqBody, serial, 'garranty', (status2, responseBody2) {
                                  if(status2==200){
                                    _pr.hide();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const GCard()),
                                    );
                                  }
                                });
                              }
                            }

                            if(!agentT){
                              setState(() {
                                _pr.hide();
                                _agent.clear();
                                _agentPass.clear();
                                _formKey.currentState!.validate();
                                _formKey1.currentState!.validate();
                                _formKey2.currentState!.validate();
                              });
                            }
                          }
                        });
                      },
                      child: const Text('تایید')),
                ),


                const Padding(
                  padding: EdgeInsets.only(top: 48.0),
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
          ),
          debugShowCheckedModeBanner: false,
        );
      },
      maximumSize: const Size(400.0, 300.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey,
    );
  }
}


