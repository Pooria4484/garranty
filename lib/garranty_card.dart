import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:garranty/main.dart';
import 'package:garranty/pdf_factory.dart';
import 'package:google_fonts/google_fonts.dart';

Map card = {};
List<Widget> _wl = [];

class GCard extends StatelessWidget {
  const GCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logD(card);
    _wl.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Image(width: 60, image: AssetImage('images/logo.png')),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Title(
              title: 'کارت گارانتی آنلاین',
              color: Colors.blue,
              child: const Text('کارت گارانتی آنلاین',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  )),
            )),
      ],
    ));

    _wl.add(const Divider(
      color: Colors.black,
    ));

    card.forEach((key, value) {
      if (key.toString().trim() == 'id') {
        _wl.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value.toString()),
            const Text('سریال دستگاه'),
          ],
        ));
      }

      if (key.toString().trim() == 'name') {
        _wl.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value.toString()),
            const Text('نمایندگی'),
          ],
        ));
      }

      if (key.toString().trim() == 'city') {
        _wl.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value.toString()),
            const Text('شهر'),
          ],
        ));
      }

      if (key.toString().trim() == 'date') {
        List<int> d = [];
        value.toString().split('/').forEach((element) {
          try {
            d.add(int.parse(element));
          } catch (e) {
            logD(e);
          }
        });
        d[0] = d[0] - 1;
        String bd =
            d[0].toString() + '/' + d[1].toString() + '/' + d[2].toString();
        _wl.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(bd),
            const Text('تاریخ شروع گارانتی'),
          ],
        ));
        _wl.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value.toString()),
            const Text('تاریخ اتمام گارانتی'),
          ],
        ));
      }
    });

    _wl.add(const Divider(
      color: Colors.black,
    ));

    _wl.add(Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: const Text('شماره تلفن 38586195-051')));
    _wl.add(Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: const Text(
          'آدرس: مشهد، میدان ۱۵ خرداد،خیابان خرمشهر، بین خرمشهر ۲ و ۴، پلاک ۳۰، واحد ۴',
          style: TextStyle(fontSize: 11),
        )));

    _wl.add(Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: const Text(
          'کیمیا الکترونیک',
          style: TextStyle(fontSize: 20),
        )));

    _wl.add(Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: const Text('لینک استعلام صحت گارانتی: garranty.msb-co.ir',
            textDirection: TextDirection.rtl)));

    return FlutterWebFrame(
      builder: (c) {
        return MaterialApp(
          title: 'اطلاعات گارنتی',
          home: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                makePdfCard(card);
              },
              child: const Icon(Icons.picture_as_pdf),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: _wl,
              ),
            ),
          ),
          theme: ThemeData(
            fontFamily: GoogleFonts.lalezar().fontFamily,
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
