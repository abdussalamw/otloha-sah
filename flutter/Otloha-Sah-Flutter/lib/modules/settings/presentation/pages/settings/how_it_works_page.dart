import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SfPdfViewer.asset(
          'assets/how_it_works.pdf',
          pageLayoutMode: PdfPageLayoutMode.single,
        ),
      ),
    );
  }
}
