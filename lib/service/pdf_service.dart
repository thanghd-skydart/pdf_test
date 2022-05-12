import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  static Future<File> generateCenteredText(String text) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (context) => pw.Center(
        child: pw.Text(text, style: const pw.TextStyle(fontSize: 48)),
      ),
    ));

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future<File> generatePDf(dynamic data) async {
    final pdf = pw.Document();
    final customFont =
        pw.Font.ttf(await rootBundle.load('assets/OpenSans-Regular.ttf'));
    final logo =
        (await rootBundle.load('assets/logo_react.png')).buffer.asUint8List();
    pdf.addPage(
      pw.MultiPage(
        build: (context) => <pw.Widget>[
          buildCustomHeader(logo: logo, font: customFont),
          pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
          pw.Paragraph(
            text:
                'This is my custom font that displays also characters such as €, Ł, ... Thắng đẹp troai vãi cả đái đặt cơm',
            style: pw.TextStyle(font: customFont, fontSize: 20),
          ),
          buildCustomHeadline(font: customFont),
          buildLink(),
          ...buildBulletPoints(),
          pw.Header(child: pw.Text('My Headline')),
          pw.Paragraph(text: pw.LoremText().paragraph(60)),
          pw.Paragraph(text: pw.LoremText().paragraph(60)),
          pw.Paragraph(text: pw.LoremText().paragraph(60)),
          pw.Paragraph(text: pw.LoremText().paragraph(60)),
          pw.Paragraph(text: pw.LoremText().paragraph(60)),
        ],
        footer: (context) {
          final text = 'Page ${context.pageNumber} of ${context.pagesCount}';

          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1 * PdfPageFormat.cm),
            child: pw.Text(
              text,
              style: const pw.TextStyle(color: PdfColors.black),
            ),
          );
        },
      ),
    );

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static pw.Widget buildCustomHeader({logo, pw.Font? font}) => pw.Container(
        padding: const pw.EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
        decoration: const pw.BoxDecoration(
          border:
              pw.Border(bottom: pw.BorderSide(width: 2, color: PdfColors.blue)),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            // pw.PdfLogo(),
            pw.Image(pw.MemoryImage(logo),
                fit: pw.BoxFit.cover, height: 50, width: 50),
            pw.SizedBox(width: 0.5 * PdfPageFormat.cm),
            pw.Paragraph(
              text: 'Đặt cơm ReactPlus',
              style: pw.TextStyle(
                font: font,
                fontSize: 40,
                color: PdfColors.blue,
              ),
            ),
          ],
        ),
      );

  static pw.Widget buildCustomHeadline({font}) => pw.Header(
        child: pw.Paragraph(
          text: 'Danh sách đặt cơm',
          style: pw.TextStyle(
            font: font,
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
        ),
        padding: const pw.EdgeInsets.all(4),
        decoration: const pw.BoxDecoration(color: PdfColors.red),
      );

  static pw.Widget buildLink() => pw.UrlLink(
        destination: 'https://flutter.dev',
        child: pw.Text(
          'Go to flutter.dev',
          style: const pw.TextStyle(
            decoration: pw.TextDecoration.underline,
            color: PdfColors.blue,
          ),
        ),
      );

  static List<pw.Widget> buildBulletPoints() => [
        pw.Bullet(text: 'First Bullet'),
        pw.Bullet(text: 'Second Bullet'),
        pw.Bullet(text: 'Third Bullet'),
      ];
}
