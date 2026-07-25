import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsAndConditions extends StatefulWidget {
  static const String routeName = '/terms_conditions';

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  void initState() {
    // FlutterFileView.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SfPdfViewer.asset('assets/terms_conditions.pdf')
      ),
      // FileView(
      //   controller: FileViewController.asset('assets/terms_conditions.doc'),
      //   placeholder: const Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // ),
    );
  }
}
