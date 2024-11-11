import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/model/user.dart';
import 'package:fulifuli_app/pages/index.dart';
import 'package:pinput/pinput.dart';

import '../widgets/mfa_page/themes.dart';

class MFAVerification extends StatefulWidget {
  const MFAVerification({super.key});

  static const String routeName = '/mfa/verification';

  @override
  State<MFAVerification> createState() => _MFAVerificationState();
}

class _MFAVerificationState extends State<MFAVerification> {
  bool _enableInput = true;

  TextStyle? createOtpTextStyle(Color color) {
    ThemeData theme = Theme.of(context);
    return theme.textTheme.headlineLarge?.copyWith(color: color);
  }

  List<TextInputFormatter> createOtpInputFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    dynamic obj = ModalRoute.of(context)?.settings.arguments;
    if (obj != null && obj is User) {
      debugPrint(obj.name);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Global.themeMode == 0
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColor,
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.mfa_title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.mfa_hint,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 72),
                    Pinput(
                      length: 6,
                      pinAnimationType: PinAnimationType.slide,
                      defaultPinTheme: MFATheme.getDefaultPinTheme(context),
                      focusedPinTheme: MFATheme.getFocusedPinTheme(context),
                      submittedPinTheme: MFATheme.getSubmittedPinTheme(context),
                      errorPinTheme: MFATheme.getErrorPinTheme(context),
                      errorTextStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                      errorText:
                          AppLocalizations.of(context)!.mfa_validation_error,
                      inputFormatters: createOtpInputFormatters(),
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      enabled: _enableInput,
                      validator: (s) {
                        debugPrint('validator: $s');
                        setState(() {
                          _enableInput = false;
                        });
                        if (s == '123456') {
                          Navigator.of(context).pushAndRemoveUntil(
                            _createRoute(),
                            (route) => false,
                          );
                          return null;
                        } else {
                          setState(() {
                            _enableInput = true;
                          });
                          return AppLocalizations.of(context)!
                              .mfa_validation_error;
                        }
                      },
                      onCompleted: (pin) {
                        debugPrint('Completed: $pin');
                      },
                    ),
                    const SizedBox(height: 48),
                    AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: <AnimatedText>[
                          _enableInput
                              ? TyperAnimatedText(
                                  'MFA Code: 123456...',
                                  curve: Curves.easeIn,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  speed: const Duration(milliseconds: 150),
                                )
                              : TyperAnimatedText(
                                  AppLocalizations.of(context)!.mfa_verifying,
                                  curve: Curves.easeIn,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  speed: const Duration(milliseconds: 150),
                                )
                        ]),
                    const SizedBox(height: 36)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const IndexPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return ScaleTransition(
          scale: animation.drive(
            Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.ease)),
          ),
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
