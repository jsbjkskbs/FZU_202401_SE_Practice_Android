import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  static String routeName = '/loading';

  @override
  State<StatefulWidget> createState() {
    return _LoadingPageState();
  }
}

class _LoadingPageState extends State<LoadingPage> {
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
                    Navigator.of(context)
                        .pushReplacementNamed(IndexPage.routeName);
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
                      Navigator.of(context)
                          .pushReplacementNamed(IndexPage.routeName);
                      ToastificationUtils.showSimpleToastification(
                          context, AppLocalizations.of(context)!.loading_hint,
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
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 20,
                  bottom: MediaQuery.of(context).size.height / 24),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(IndexPage.routeName);
                  },
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
          AnimatedTextKit(
              repeatForever: false,
              totalRepeatCount: 1,
              animatedTexts: [
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
