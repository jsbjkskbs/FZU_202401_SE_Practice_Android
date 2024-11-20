import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fulifuli_app/global.dart';
import 'package:fulifuli_app/widgets/index_page/login/recover_password.dart';

import '../model/user.dart';
import 'index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String routeName = '/login';

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => const Duration(milliseconds: 1500);
  final RecoverPasswordForm _recoverPasswordForm = const RecoverPasswordForm();
  final dio = Dio(BaseOptions(baseUrl: Global.baseUrl));

  String _cachedEmail = "";

  Future<String?> _login(LoginData data) async {
    Response response;
    response = await dio.post('/api/v1/user/login', data: {
      "username": data.name,
      "password": data.password,
    });

    if (response.data["code"] != Global.successCode) {
      return response.data["msg"];
    }

    Global.self = User.fromJson(response.data["data"]);
    if (!Global.self.isValidUser()) {
      return 'Login failed';
    }
    Global.updateDioToken(accessToken: Global.self.accessToken, refreshToken: Global.self.refreshToken);
    Storage.storePersistentData(Global.appPersistentData.copyWith(user: Global.self));
    Global.startAsyncTask();
    return null;
  }

  Future<String?> _signup(SignupData data) async {
    _cachedEmail = data.additionalSignupData!["email"]!;
    Response response;
    response = await dio.post('/api/v1/user/security/email/code', data: {
      'email': _cachedEmail,
    });
    if (response.data["code"] != Global.successCode) {
      return response.data["msg"];
    }
    return null;
  }

  Future<String?> _recoverPassword(String name, BuildContext context) async {
    if (context.mounted) {
      showDialog(
          context: context,
          builder: (context) {
            return _recoverPasswordForm;
          });
    }
    return null;
  }

  Future<String?> _onConfirmSignup(String code, LoginData data) async {
    Response response;
    response = await dio.post('/api/v1/user/register', data: {
      'username': data.name,
      'password': data.password,
      'email': _cachedEmail,
      'code': code,
    });

    if (response.data["code"] != Global.successCode) {
      return response.data["msg"];
    }

    response = await dio.post('/api/v1/user/login', data: {
      "username": data.name,
      "password": data.password,
    });

    if (response.data["code"] != Global.successCode) {
      return response.data["msg"];
    }

    Global.self = User.fromJson(response.data["data"]);
    if (!Global.self.isValidUser()) {
      return 'Login failed';
    }
    Global.updateDioToken(accessToken: Global.self.accessToken, refreshToken: Global.self.refreshToken);
    Storage.storePersistentData(Global.appPersistentData.copyWith(user: Global.self));
    return null;
  }

  Future<String?> _onResendCode(SignupData data) async {
    Response response;
    response = await dio.post('/api/v1/user/security/email/code', data: {
      'email': _cachedEmail,
    });
    if (response.data["code"] != Global.successCode) {
      return response.data["msg"];
    }
    return null;
  }

  Future<String?> _onRecoverPassword(String name) async {
    Response response;
    response = await dio.post('/api/v1/user/security/password/retrieve/username', data: {
      'username': name,
    });
    if (response.data["code"] != Global.successCode) {
      return response.data["msg"];
    }
    return null;
  }

  Future<String?> _onConfirmRecover(String code, LoginData data) async {
    Response response;
    response = await dio.post('/api/v1/user/security/password/reset/username', data: {
      'username': data.name,
      'password': data.password,
      'code': code,
    });
    if (response.data["code"] != Global.successCode) {
      return response.data["msg"];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FlutterLogin(
      userType: LoginUserType.name,
      userValidator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.login_user_empty;
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.login_password_empty;
        }
        return null;
      },
      logo: Global.appPersistentData.themeMode == 0 ? "assets/images/logo/logo_light1.png" : "assets/images/logo/logo_dark0.png",
      onLogin: _login,
      onSignup: _signup,
      onConfirmSignup: _onConfirmSignup,
      onResendCode: _onResendCode,
      onRecoverPassword: _onRecoverPassword,
      onConfirmRecover: _onConfirmRecover,
      hideForgotPasswordButton: false,
      navigateBackAfterRecovery: true,
      loginAfterSignUp: true,
      additionalSignupFields: [
        UserFormField(
          keyName: "email",
          displayName: AppLocalizations.of(context)!.login_additional_sign_up_email_hint,
          icon: const Icon(Icons.email),
          fieldValidator: (value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.login_additional_sign_up_email_empty;
            }
            if (!RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$').hasMatch(value)) {
              return AppLocalizations.of(context)!.login_additional_sign_up_email_validation_error;
            }
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(IndexPage.routeName);
      },
      messages: LoginMessages(
        userHint: AppLocalizations.of(context)!.login_user_hint,
        passwordHint: AppLocalizations.of(context)!.login_password_hint,
        confirmPasswordHint: AppLocalizations.of(context)!.login_confirm_password_hint,
        loginButton: AppLocalizations.of(context)!.login_login_button,
        signupButton: AppLocalizations.of(context)!.login_signup_button,
        forgotPasswordButton: AppLocalizations.of(context)!.login_forgot_password_button,
        recoverPasswordButton: AppLocalizations.of(context)!.login_recover_password_button,
        goBackButton: AppLocalizations.of(context)!.login_go_back_button,
        confirmPasswordError: AppLocalizations.of(context)!.login_confirm_password_error,
        recoverPasswordIntro: AppLocalizations.of(context)!.login_recover_password_intro,
        recoverPasswordDescription: AppLocalizations.of(context)!.login_recover_password_description,
        recoverPasswordSuccess: AppLocalizations.of(context)!.login_recover_password_success,
        providersTitleFirst: AppLocalizations.of(context)!.login_providers_title_first,
        confirmRecoverSuccess: AppLocalizations.of(context)!.login_confirm_recover_success,
        confirmationCodeHint: AppLocalizations.of(context)!.login_confirmation_code_hint,
        confirmationCodeValidationError: AppLocalizations.of(context)!.login_confirmation_code_validation_error,
        confirmRecoverIntro: AppLocalizations.of(context)!.login_confirm_recover_intro,
        confirmSignupButton: AppLocalizations.of(context)!.login_confirm_signup_button,
        confirmSignupIntro: AppLocalizations.of(context)!.login_confirm_signup_intro,
        confirmSignupSuccess: AppLocalizations.of(context)!.login_confirm_signup_success,
        resendCodeButton: AppLocalizations.of(context)!.login_resend_code_button,
        resendCodeSuccess: AppLocalizations.of(context)!.login_resend_code_success,
        recoveryCodeHint: AppLocalizations.of(context)!.login_recovery_code_hint,
        recoverCodePasswordDescription: AppLocalizations.of(context)!.login_recover_code_password_description,
        recoveryCodeValidationError: AppLocalizations.of(context)!.login_recovery_code_validation_error,
        signUpSuccess: AppLocalizations.of(context)!.login_sign_up_success,
        setPasswordButton: AppLocalizations.of(context)!.login_set_password_button,
        flushbarTitleError: AppLocalizations.of(context)!.login_flushbar_title_error,
        flushbarTitleSuccess: AppLocalizations.of(context)!.login_flushbar_title_success,
        providersTitleSecond: AppLocalizations.of(context)!.login_providers_title_second,
        additionalSignUpFormDescription: AppLocalizations.of(context)!.login_additional_sign_up_form_description,
        additionalSignUpSubmitButton: AppLocalizations.of(context)!.login_additional_sign_up_submit_button,
      ),
      headerWidget: AnimatedTextKit(totalRepeatCount: 1, animatedTexts: [
        TyperAnimatedText(
          Random.secure().nextInt(2) == 0 ? "Hello, FuliFuli!" : "Ciallo~ FuliFuli!",
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          speed: const Duration(milliseconds: 200),
        ),
      ]),
      footer: "copyright© 2024 FuliFuli",
      theme: LoginTheme(
          pageColorLight: Theme.of(context).primaryColor,
          pageColorDark: Theme.of(context).primaryColor,
          buttonStyle: TextStyle(
            color: Theme.of(context).cardColor,
          )),
      loginProviders: <LoginProvider>[
        LoginProvider(
            icon: Icons.email,
            label: AppLocalizations.of(context)!.login_additional_sign_up_email_hint,
            callback: () async {
              _recoverPassword("", context);
              return "no-error";
            },
            errorsToExcludeFromErrorMessage: ["no-error"])
      ],
    ));
  }
}
