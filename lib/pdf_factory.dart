import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shamsi_date/shamsi_date.dart';
import 'dart:html';

import 'main.dart';

Future<void> makePdfCard(Map _card) async {
  final font = await rootBundle.load("fonts/Yekan.ttf");
  final ttf = pw.Font.ttf(font);
  final logo = pw.MemoryImage(
      (await rootBundle.load('images/logo.png')).buffer.asUint8List(),
      dpi: 70);
  // pw.Center(child: pw.Image(logo,height: 60)
  // ),
  var pdf = pw.Document();
  List<pw.Widget> wl = [];
  wl.add(pw.Padding(padding: const pw.EdgeInsets.only(top: 50)));
  wl.add(
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
    pw.Image(logo, dpi: 70, alignment: pw.Alignment.center, width: 60),
    pw.Text('کارت گارانتی آنلاین',
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(
            font: ttf, fontSize: 13, color: const PdfColor(0, 0, 1))),
  ]));

  wl.add(pw.Divider());

  _card.forEach((key, value) {
    if (key.toString().trim() == 'id') {
      wl.add(pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(value.toString(),
              textDirection: pw.TextDirection.ltr,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
              )),
          pw.Text('سریال دستگاه',
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
              )),
        ],
      ));
    }

    if (key.toString().trim() == 'agent') {
      wl.add(pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(value.toString(),
              textDirection: pw.TextDirection.ltr,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
              )),
          pw.Text('کد نمایندگی',
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
              )),
        ],
      ));
    }

    if (key.toString().trim() == 'city') {
      wl.add(pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(value.toString(),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
              )),
          pw.Text('شهر',
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
              )),
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
      wl.add(pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(bd,
              textDirection: pw.TextDirection.ltr,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
              )),
          pw.Text('تاریخ شروع گارانتی',
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
              )),
        ],
      ));
      wl.add(pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(value.toString(),
              textDirection: pw.TextDirection.ltr,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
              )),
          pw.Text('تاریخ اتمام گارانتی',
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 12,
              )),
        ],
      ));
    }
  });

  wl.add(pw.Divider(
      //color: Colors.black,
      ));

  wl.add(pw.Container(
    //alignment: Alignment.center,
    //padding: const EdgeInsets.all(8),
    child: pw.Text('شماره تلفن 051-38586195',
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(
          font: ttf,
          fontSize: 9,
        )),
  ));
  wl.add(pw.Container(
      //alignment: Alignment.center,
      //padding: const EdgeInsets.all(8),
      child: pw.Text(
          'آدرس: مشهد- میدان ۱۵ خرداد-خیابان خرمشهر- بین خرمشهر ۲ و ۴- پلاک ۳۰- واحد ۴',
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(
            font: ttf,
            fontSize: 9,
          ))));

  wl.add(pw.Container(
      //alignment: Alignment.center,
      //padding: const EdgeInsets.all(8),
      child: pw.Text('کیمیا الکترونیک',
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(
            font: ttf,
            fontSize: 13,
            color: const PdfColor(1, 0, 0),
          ))));

  var url =
      'http://garranty.msb-co.ir/?phone=' + phone! + '&' + 'serial=' + serial!;
  wl.add(pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
    pw.Text('لینک استعلام صحت گارانتی:',
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(
          font: ttf,
          fontSize: 9,
        )),
  ]));

  wl.add(pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Link(
        destination: url,
        child: pw.Text(url,
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColor(0, 0, 1),
            )),
      )));

  wl.add(pw.Padding(child: pw.Divider(), padding: const pw.EdgeInsets.all(16)));

  wl.add(pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Link(
        destination: 'https://msb-co.ir/',
        child: pw.Text('https://msb-co.ir/',
            style: const pw.TextStyle(
              fontSize: 13,
              color: PdfColor(0, 0, 1),
            )),
      )));

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a5,
      build: (pw.Context context) {
        return pw.DecoratedBox(
            decoration: const pw.BoxDecoration(
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(3)),
              border: pw.Border(
                  top: pw.BorderSide(color: PdfColor(0, 0, 0)),
                  bottom: pw.BorderSide(color: PdfColor(0, 0, 0)),
                  left: pw.BorderSide(color: PdfColor(0, 0, 0)),
                  right: pw.BorderSide(color: PdfColor(0, 0, 0))),
            ),
            child: pw.Padding(child: pw.Center(child: pw.ListView(children: wl)),padding: const pw.EdgeInsets.all(8)));
      })); // Page

  Jalali now = DateTime.now().toJalali();
  String date = now.year.toString() +
      now.month.toString() +
      now.day.toString() +
      now.hour.toString() +
      now.minute.toString() +
      now.second.toString();
  List<int> bytes = await pdf.save();
  showPDF(bytes, '$date.pdf');
}

void showPDF(bytes, String name) {
  AnchorElement(
      href:
          "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    ..setAttribute("download", name)
    ..click();
}
