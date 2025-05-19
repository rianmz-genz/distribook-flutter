import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlPreviewPage extends StatelessWidget {
  final String htmlContent;

  HtmlPreviewPage({required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()..loadHtmlString(htmlContent);

    return Scaffold(
      appBar: AppBar(title: Text("HTML Preview")),
      body: WebViewWidget(controller: controller),
    );
  }
}
