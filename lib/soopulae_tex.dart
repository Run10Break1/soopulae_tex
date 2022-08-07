import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SoopulaeTexView extends StatefulWidget {
  final String tex;
  final Color backgroundColor;
  final Color captureBackgroundColor;
  final VoidCallback? onRenderFinished;
  final void Function(Uint8List pngData, int width, int height)?
      onCaptureFinished;

  const SoopulaeTexView(
      {Key? key,
      required this.tex,
      this.backgroundColor = Colors.transparent,
      this.captureBackgroundColor = Colors.transparent,
      this.onRenderFinished,
      this.onCaptureFinished})
      : super(key: key);

  @override
  State<SoopulaeTexView> createState() => _SoopulaeTexViewState();
}

class _SoopulaeTexViewState extends State<SoopulaeTexView> {
  late final InAppWebViewController _webViewController;

  double _height = 1;

  void initState() {
    super.initState();
    //_SoopulaeTexViewContainer.of(context)?._cnt += 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print("constraints : $constraints");

        return SizedBox(
          height: _height,
          width: constraints.maxWidth,
          child: InAppWebView(
            initialFile: "packages/soopulae_tex/assets/index.html",
            onWebViewCreated: (controller) {
              _webViewController = controller;

              _webViewController.addJavaScriptHandler(
                handlerName: "requestInit",
                callback: (_) {
                  return [
                    widget.tex,
                    getCssColor(widget.backgroundColor),
                    getCssColor(widget.captureBackgroundColor),
                    constraints.maxWidth,
                  ];
                },
              );
              _webViewController.addJavaScriptHandler(
                handlerName: "katexRendered",
                callback: (args) {
                  setState(() {
                    _height = (args[1] as num).toDouble() + 10 /* 아래 부분이 잘리는 현상 막기 위해 높이 추가 */;
                  });

                  //_SoopulaeTexViewContainer.of(context)?._renderFinishedCnt += 1;
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

                  //_SoopulaeTexViewContainer.of(context)?._captureFinishedCnt += 1;
                  if (widget.onCaptureFinished != null) {
                    widget.onCaptureFinished!(pngData, width, height);
                  }
                },
              );
            },
            onConsoleMessage: (_, message) {
              print("console message in web : ${message.message}");
            },
          ),
        );
      }
    );
  }

  String getCssColor(Color color) {
    return "rgba(${widget.backgroundColor.red}, ${widget.backgroundColor.green}, ${widget.backgroundColor.blue}, ${widget.backgroundColor.alpha})";
  }
}

/*
class SoopulaeTexViewContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onRenderFinished;
  final void Function(Uint8List pngData, int width, int height)?
  onCaptureFinished;

  const SoopulaeTexViewContainer({Key? key, required this.child, this.onRenderFinished, }) : super(key: key);

  @override
  State<SoopulaeTexViewContainer> createState() => _SoopulaeTexViewContainerState();
}

class _SoopulaeTexViewContainerState extends State<SoopulaeTexViewContainer> {
  late final SoopulaeTexViewContainerData _data;

  void initState() {
    super.initState();
    _data = SoopulaeTexViewContainerData();
  }

  @override
  Widget build(BuildContext context) {
    return _SoopulaeTexViewContainer(_data, child: widget.child);
  }
}

class _SoopulaeTexViewContainer extends InheritedWidget {
  final SoopulaeTexViewContainerData _data;

  const _SoopulaeTexViewContainer(this._data, {required super.child});

  static SoopulaeTexViewContainerData? of(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<_SoopulaeTexViewContainer>()?._data;
    return data;
  }

  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

}

class SoopulaeTexViewContainerData {
  int _cnt = 0;
  int _renderFinishedCnt = 0;
  int _captureFinishedCnt = 0;
}
*/