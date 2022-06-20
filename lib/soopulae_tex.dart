library soopulae_tex;

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class SoopulaeTexView extends StatefulWidget {
  final String tex;
  final VoidCallback? onRenderFinished;
  final void Function(Uint8List pngData, int width, int height)? onCaptureFinished;

  const SoopulaeTexView({Key? key, required this.tex, this.onRenderFinished, this.onCaptureFinished}) : super(key: key);

  @override
  State<SoopulaeTexView> createState() => _SoopulaeTexViewState();
}

class _SoopulaeTexViewState extends State<SoopulaeTexView> {
  late final InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialFile: "packages/soopulae_tex/assets/index.html",
      onWebViewCreated: (controller) {
        _webViewController = controller;

        _webViewController.addJavaScriptHandler(
          handlerName: "requestKatex",
          callback: (_) {
            return widget.tex;
          },
        );
        _webViewController.addJavaScriptHandler(
          handlerName: "katexRendered",
          callback: (_) {
            if (widget.onRenderFinished != null) {
              widget.onRenderFinished!();
            }
          },
        );
        _webViewController.addJavaScriptHandler(
          handlerName: "captureFinished",
          callback: (args) {
            final String base64png = args[0] as String;
            final int width = args[1] as int;
            final int height = args[2] as int;

            final Uint8List pngData = base64Decode(base64png.split(",")[1]);

            if(widget.onCaptureFinished != null) {
              widget.onCaptureFinished!(pngData, width, height);
            }
          },
        );
      },
      onConsoleMessage: (_, message) {
        print("console message : ${message.message}");
      },
    );
  }
}

