import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key, required this.onLoading});

  static String routeName = '/loading';
  final Function onLoading;

  @override
  State<StatefulWidget> createState() {
    return _LoadingPageState();
  }
}

class _LoadingPageState extends State<LoadingPage> {
  dynamic _loadingResult;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) async {
      _loadingResult = await widget.onLoading();
      if (_loadingResult != null && _loadingResult is String) {
        ToastificationUtils.showSimpleToastification(context, _loadingResult);
      }
      setState(() {
        _isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 12,
              child: GestureDetector(
                  onTap: () {
                    if (!_isLoaded) {
                      ToastificationUtils.showSimpleToastification(context, '加载中，请稍后再试');
                      return;
                    } else {
                      Navigator.of(context).pushReplacementNamed(IndexPage.routeName);
                    }
                  },
                  child: CircularCountDownTimer(
                    width: MediaQuery.of(context).size.width / 10,
                    height: MediaQuery.of(context).size.height / 10,
                    duration: 5,
                    fillColor: Theme.of(context).indicatorColor,
                    ringColor: Theme.of(context).disabledColor,
                    strokeWidth: 3.0,
                    isReverse: true,
                    isReverseAnimation: true,
                    textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 18,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                    onComplete: () {
                      if (!_isLoaded) {
                        return;
                      }
                      Navigator.of(context).pushReplacementNamed(IndexPage.routeName);
                      ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.loading_hint,
                          duration: const Duration(seconds: 3));
                    },
                  )),
            ),
            SizedBox(width: MediaQuery.of(context).size.width / 20),
          ],
        ),
        Expanded(
          child: TDImage(
            assetUrl: 'assets/images/loading_img.png',
            fit: BoxFit.scaleDown,
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.height / 3,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 20, bottom: MediaQuery.of(context).size.height / 24),
              child: ElevatedButton(
                  onPressed: () {
                    if (!_isLoaded) {
                      ToastificationUtils.showSimpleToastification(context, '加载中，请稍后再试');
                      return;
                    }
                    Navigator.of(context).pushReplacementNamed(IndexPage.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.loading_skip,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).indicatorColor,
                          fontFamily: "Ponari"))),
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          AnimatedTextKit(repeatForever: false, totalRepeatCount: 1, animatedTexts: [
            WavyAnimatedText(
              'FuliFuli',
              textStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 6,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).indicatorColor,
                  fontFamily: "Ponari"),
              speed: const Duration(milliseconds: 360),
            ),
          ]),
        ]),
        SizedBox(height: MediaQuery.of(context).size.height / 8),
      ],
    )));
  }
}
