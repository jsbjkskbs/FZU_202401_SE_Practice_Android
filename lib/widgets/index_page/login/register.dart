import 'dart:async';

import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<RegisterForm> {
  late Timer _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  int _countdownTime = 0;
  bool _emailValid = true;
  final bool _verifyCodeValid = true;

  bool _validateEmail(String email) {
    if (email.isEmpty) {
      return false;
    }
    return RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$').hasMatch(email);
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
                      const Text("重置密码", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TDInput(
                        leftLabel: "邮箱",
                        leftLabelStyle: TextStyle(
                          color: Theme.of(context).indicatorColor,
                        ),
                        textStyle: TextStyle(
                          color: Theme.of(context).indicatorColor,
                        ),
                        inputDecoration: _makeInputDecoration('邮箱', context),
                        onChanged: (value) {
                          setState(() {
                            _emailValid = _validateEmail(value);
                          });
                        },
                        additionInfo: _emailValid ? "" : "邮箱格式不正确",
                        additionInfoColor: Colors.red,
                      ),
                      TDInput(
                        leftLabel: "验证码",
                        leftLabelStyle: TextStyle(
                          color: Theme.of(context).indicatorColor,
                        ),
                        textStyle: TextStyle(
                          color: Theme.of(context).indicatorColor,
                        ),
                        inputDecoration: _makeInputDecoration('验证码', context),
                        additionInfo: _verifyCodeValid ? "" : "验证码错误",
                        additionInfoColor: Colors.red,
                        rightBtn: SizedBox(
                          width: 98,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Container(
                                  width: 0.5,
                                  height: 24,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              _countdownTime > 0
                                  ? TDText(
                                      '重发($_countdownTime秒)',
                                      textColor: Theme.of(context).secondaryHeaderColor,
                                    )
                                  : TDText('发送验证码', textColor: Theme.of(context).primaryColor),
                            ],
                          ),
                        ),
                        onBtnTap: () {
                          if (_countdownTime == 0) {
                            TDToast.showText('验证码已发送', context: context);
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
