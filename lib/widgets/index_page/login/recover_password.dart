import 'dart:async';

import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/utils/toastification.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class RecoverPasswordForm extends StatefulWidget {
  const RecoverPasswordForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RecoverPasswordState();
  }
}

class _RecoverPasswordState extends State<RecoverPasswordForm> {
  final TextEditingController _recoverPasswordController1 = TextEditingController();
  final TextEditingController _recoverPasswordController2 = TextEditingController();
  late Timer _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  int _countdownTime = 0;
  bool _emailValid = true;
  bool _passwordValid = true;
  bool _password2Valid = true;
  final bool _verifyCodeValid = true;

  bool _passwordVisible = true;
  bool _password2Visible = true;

  bool _validateEmail(String email) {
    if (email.isEmpty) {
      return false;
    }
    return RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$').hasMatch(email);
  }

  bool _validatePassword(String password) {
    if (password.isEmpty) {
      return false;
    }
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(password);
  }

  bool _validatePassword2(String password1, String password2) {
    if (password1.isEmpty || password2.isEmpty) {
      return false;
    }
    return password1 == password2;
  }

  @override
  void dispose() {
    _recoverPasswordController1.dispose();
    _recoverPasswordController2.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FluidDialog(
        rootPage: FluidDialogPage(
            alignment: Alignment.center,
            builder: (context) => FractionallySizedBox(
                  widthFactor: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.login_recover_page_reset_password,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TDInput(
                        leftLabel: AppLocalizations.of(context)!.login_recover_page_reset_email,
                        leftLabelStyle: TextStyle(
                          color: Theme.of(context).indicatorColor,
                        ),
                        textStyle: TextStyle(
                          color: Theme.of(context).indicatorColor,
                        ),
                        inputDecoration: _makeInputDecoration(AppLocalizations.of(context)!.login_recover_page_reset_email_hint, context),
                        onChanged: (value) {
                          setState(() {
                            _emailValid = _validateEmail(value);
                          });
                        },
                        additionInfo: _emailValid ? "" : AppLocalizations.of(context)!.login_recover_page_reset_email_error,
                        additionInfoColor: Colors.red,
                      ),
                      TDInput(
                        leftLabel: AppLocalizations.of(context)!.login_recover_page_reset_code,
                        leftLabelStyle: TextStyle(color: Theme.of(context).indicatorColor, letterSpacing: 0),
                        textStyle: TextStyle(
                          color: Theme.of(context).indicatorColor,
                        ),
                        inputDecoration: _makeInputDecoration(AppLocalizations.of(context)!.login_recover_page_reset_code_hint, context),
                        additionInfo: _verifyCodeValid ? "" : AppLocalizations.of(context)!.login_recover_page_reset_code_error,
                        additionInfoColor: Colors.red,
                        rightBtn: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Container(
                                width: 0.5,
                                height: 24,
                                color: TDTheme.of(context).grayColor3,
                              ),
                            ),
                            _countdownTime > 0
                                ? TDText(
                                    AppLocalizations.of(context)!.login_recover_page_send_reset_code_on_countdown(_countdownTime),
                                    textColor: Theme.of(context).secondaryHeaderColor,
                                  )
                                : TDText(
                                    AppLocalizations.of(context)!.login_recover_page_send_reset_code,
                                    textColor: Theme.of(context).primaryColor,
                                  ),
                          ],
                        ),
                        onBtnTap: () {
                          if (_countdownTime == 0) {
                            TDToast.showText(AppLocalizations.of(context)!.login_recover_page_reset_code_has_sent, context: context);
                            setState(() {
                              _countdownTime = 60;
                              _countdownTimer.cancel();
                              _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                                if (_countdownTime == 0) {
                                  timer.cancel();
                                } else {
                                  setState(() {
                                    _countdownTime--;
                                  });
                                }
                              });
                            });
                          }
                        },
                      ),
                      TDInput(
                        leftLabel: AppLocalizations.of(context)!.login_recover_page_new_password,
                        leftLabelStyle: TextStyle(
                          color: Theme.of(context).indicatorColor,
                        ),
                        textStyle: TextStyle(
                          color: Theme.of(context).indicatorColor,
                        ),
                        inputDecoration: _makeInputDecoration(AppLocalizations.of(context)!.login_recover_page_new_password_hint, context),
                        controller: _recoverPasswordController1,
                        onChanged: (value) {
                          setState(() {
                            _passwordValid = _validatePassword(value);
                          });
                        },
                        additionInfo: _passwordValid ? "" : AppLocalizations.of(context)!.login_recover_page_new_password_error,
                        additionInfoColor: Colors.red,
                        obscureText: !_passwordVisible,
                        rightBtn: IconButton(
                          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        needClear: false,
                      ),
                      TDInput(
                        leftLabel: AppLocalizations.of(context)!.login_recover_page_confirm_password,
                        leftLabelStyle: TextStyle(
                          color: Theme.of(context).indicatorColor,
                        ),
                        textStyle: TextStyle(
                          color: Theme.of(context).indicatorColor,
                        ),
                        inputDecoration:
                            _makeInputDecoration(AppLocalizations.of(context)!.login_recover_page_confirm_password_hint, context),
                        controller: _recoverPasswordController2,
                        onChanged: (value) {
                          setState(() {
                            _password2Valid = _validatePassword2(_recoverPasswordController1.text, value);
                          });
                        },
                        additionInfo: _password2Valid ? "" : AppLocalizations.of(context)!.login_recover_page_confirm_password_error,
                        additionInfoColor: Colors.red,
                        obscureText: !_password2Visible,
                        rightBtn: IconButton(
                          icon: Icon(_password2Visible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _password2Visible = !_password2Visible;
                            });
                          },
                        ),
                        needClear: false,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(width: 36),
                          Expanded(
                              child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(AppLocalizations.of(context)!.login_recover_page_cancel),
                          )),
                          const SizedBox(width: 48),
                          Expanded(
                              child: ElevatedButton(
                            onPressed: () {
                              if (_recoverPasswordController1.text != _recoverPasswordController2.text) {
                                ToastificationUtils.showSimpleToastification(
                                    context, AppLocalizations.of(context)!.login_recover_page_confirm_password_error);
                              } else {
                                ToastificationUtils.showSimpleToastification(
                                    context, AppLocalizations.of(context)!.login_recover_page_reset_password_success);
                                Navigator.of(context).pop();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Theme.of(context).indicatorColor),
                            ),
                            child: Text(AppLocalizations.of(context)!.login_recover_page_confirm,
                                style: TextStyle(color: Theme.of(context).cardColor)),
                          )),
                          const SizedBox(width: 36),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                )));
  }

  InputDecoration _makeInputDecoration(String hint, BuildContext context) {
    return InputDecoration(
      fillColor: Colors.transparent,
      hintText: hint,
      hintStyle: TextStyle(
        color: Theme.of(context).hintColor,
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).indicatorColor,
          width: 2.0,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
