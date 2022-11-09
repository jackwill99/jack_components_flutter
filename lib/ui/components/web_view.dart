import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JackUIWebView extends StatefulWidget {
  static const routeName = "/webview";
  const JackUIWebView({Key? key}) : super(key: key);

  @override
  State<JackUIWebView> createState() => _JackUIWebViewState();
}

class _JackUIWebViewState extends State<JackUIWebView> {
  late WebViewController controller;
  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final url = data['url'];
    final header = data['header'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(39, 37, 95, 1),
        title: Text(header ?? 'ZDS Myanmar'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (loadingPercentage < 100)
              SizedBox(
                height: 5,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.blue,
                  value: loadingPercentage / 100.0,
                ),
              ),
            Expanded(
              child: WebView(
                initialUrl: url,
                onWebViewCreated: (webViewController) {
                  controller = webViewController;
                },
                zoomEnabled: false,
                onPageStarted: (url) {
                  setState(() {
                    loadingPercentage = 0;
                  });
                },
                onProgress: (progress) {
                  print(progress);
                  setState(() {
                    loadingPercentage = progress;
                  });
                },
                onPageFinished: (url) {
                  setState(() {
                    loadingPercentage = 100;
                  });
                },
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
