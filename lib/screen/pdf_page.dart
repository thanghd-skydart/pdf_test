import 'package:flutter/material.dart';
import 'package:pdf_flutter/service/pdf_service.dart';

import '../data/data.dart';
import '../main.dart';
import '../widget/button_widget.dart';

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonWidget(
                  text: 'Simple PDF',
                  onPressed: () async {
                    final pdfFile =
                        await PdfService.generateCenteredText('Sample Text');
                    PdfService.openFile(pdfFile);
                  },
                ),
                const SizedBox(height: 24),
                ButtonWidget(
                  text: 'Paragraphs PDF',
                  onPressed: () async {
                    final pdfFile = await PdfService.generatePDf(data);
                    PdfService.openFile(pdfFile);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
