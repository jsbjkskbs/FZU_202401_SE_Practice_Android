// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Wa Ao!`
  String get egg_wa_ao {
    return Intl.message(
      'Wa Ao!',
      name: 'egg_wa_ao',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get function_default_like_on_zero {
    return Intl.message(
      'Like',
      name: 'function_default_like_on_zero',
      desc: '',
      args: [],
    );
  }

  /// `Dislike`
  String get function_default_dislike {
    return Intl.message(
      'Dislike',
      name: 'function_default_dislike',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get function_default_report {
    return Intl.message(
      'Report',
      name: 'function_default_report',
      desc: '',
      args: [],
    );
  }

  /// `Load failed`
  String get function_default_image_load_failed {
    return Intl.message(
      'Load failed',
      name: 'function_default_image_load_failed',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get function_default_clear {
    return Intl.message(
      'Clear',
      name: 'function_default_clear',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get function_default_confirm {
    return Intl.message(
      'Confirm',
      name: 'function_default_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get function_default_cancel {
    return Intl.message(
      'Cancel',
      name: 'function_default_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get function_default_submit {
    return Intl.message(
      'Submit',
      name: 'function_default_submit',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get function_default_close {
    return Intl.message(
      'Close',
      name: 'function_default_close',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get function_default_delete {
    return Intl.message(
      'Delete',
      name: 'function_default_delete',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get function_default_edit {
    return Intl.message(
      'Edit',
      name: 'function_default_edit',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get function_default_save {
    return Intl.message(
      'Save',
      name: 'function_default_save',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get function_default_send {
    return Intl.message(
      'Send',
      name: 'function_default_send',
      desc: '',
      args: [],
    );
  }

  /// `Uh oh! Seemly nothing here~~`
  String get empty_placeholder_hint {
    return Intl.message(
      'Uh oh! Seemly nothing here~~',
      name: 'empty_placeholder_hint',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get index_tabs_home {
    return Intl.message(
      'Home',
      name: 'index_tabs_home',
      desc: '',
      args: [],
    );
  }

  /// `Dynamic`
  String get index_tabs_dynamic {
    return Intl.message(
      'Dynamic',
      name: 'index_tabs_dynamic',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get index_tabs_submit {
    return Intl.message(
      'Submit',
      name: 'index_tabs_submit',
      desc: '',
      args: [],
    );
  }

  /// `Friend`
  String get index_tabs_friend {
    return Intl.message(
      'Friend',
      name: 'index_tabs_friend',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get index_tabs_mine {
    return Intl.message(
      'Mine',
      name: 'index_tabs_mine',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get home_top_bar_search {
    return Intl.message(
      'Search',
      name: 'home_top_bar_search',
      desc: '',
      args: [],
    );
  }

  /// `Theme switch successful`
  String get home_theme_switch_toast {
    return Intl.message(
      'Theme switch successful',
      name: 'home_theme_switch_toast',
      desc: '',
      args: [],
    );
  }

  /// `Please login first`
  String get home_login_hint {
    return Intl.message(
      'Please login first',
      name: 'home_login_hint',
      desc: '',
      args: [],
    );
  }

  /// `Recommend`
  String get home_tabs_recommend {
    return Intl.message(
      'Recommend',
      name: 'home_tabs_recommend',
      desc: '',
      args: [],
    );
  }

  /// `Game`
  String get home_tabs_game {
    return Intl.message(
      'Game',
      name: 'home_tabs_game',
      desc: '',
      args: [],
    );
  }

  /// `Knowledge`
  String get home_tabs_knowledge {
    return Intl.message(
      'Knowledge',
      name: 'home_tabs_knowledge',
      desc: '',
      args: [],
    );
  }

  /// `Life`
  String get home_tabs_life {
    return Intl.message(
      'Life',
      name: 'home_tabs_life',
      desc: '',
      args: [],
    );
  }

  /// `Military`
  String get home_tabs_military {
    return Intl.message(
      'Military',
      name: 'home_tabs_military',
      desc: '',
      args: [],
    );
  }

  /// `Vitascope`
  String get home_tabs_vitascope {
    return Intl.message(
      'Vitascope',
      name: 'home_tabs_vitascope',
      desc: '',
      args: [],
    );
  }

  /// `News`
  String get home_tabs_news {
    return Intl.message(
      'News',
      name: 'home_tabs_news',
      desc: '',
      args: [],
    );
  }

  /// `Pull to refresh`
  String get home_page_refresher_drag_text {
    return Intl.message(
      'Pull to refresh',
      name: 'home_page_refresher_drag_text',
      desc: '',
      args: [],
    );
  }

  /// `Release ready`
  String get home_page_refresher_armed_text {
    return Intl.message(
      'Release ready',
      name: 'home_page_refresher_armed_text',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing...`
  String get home_page_refresher_ready_text {
    return Intl.message(
      'Refreshing...',
      name: 'home_page_refresher_ready_text',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing...`
  String get home_page_refresher_processing_text {
    return Intl.message(
      'Refreshing...',
      name: 'home_page_refresher_processing_text',
      desc: '',
      args: [],
    );
  }

  /// `Succeeded`
  String get home_page_refresher_processed_text {
    return Intl.message(
      'Succeeded',
      name: 'home_page_refresher_processed_text',
      desc: '',
      args: [],
    );
  }

  /// `No more`
  String get home_page_refresher_no_more_text {
    return Intl.message(
      'No more',
      name: 'home_page_refresher_no_more_text',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get home_page_refresher_failed_text {
    return Intl.message(
      'Failed',
      name: 'home_page_refresher_failed_text',
      desc: '',
      args: [],
    );
  }

  /// `Last updated at %T`
  String get home_page_refresher_message_text {
    return Intl.message(
      'Last updated at %T',
      name: 'home_page_refresher_message_text',
      desc: '',
      args: [],
    );
  }

  /// `Attempt to request again`
  String get home_page_try_request_again {
    return Intl.message(
      'Attempt to request again',
      name: 'home_page_try_request_again',
      desc: '',
      args: [],
    );
  }

  /// `Really nothing more here~`
  String get home_page_no_more {
    return Intl.message(
      'Really nothing more here~',
      name: 'home_page_no_more',
      desc: '',
      args: [],
    );
  }

  /// `Get {count} data`
  String home_page_get_data_count(int count) {
    return Intl.message(
      'Get $count data',
      name: 'home_page_get_data_count',
      desc: '',
      args: [count],
    );
  }

  /// `Login/Register`
  String get mine_profile_login_or_register {
    return Intl.message(
      'Login/Register',
      name: 'mine_profile_login_or_register',
      desc: '',
      args: [],
    );
  }

  /// `View Profile`
  String get mine_profile_view_profile {
    return Intl.message(
      'View Profile',
      name: 'mine_profile_view_profile',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get mine_user_info_like {
    return Intl.message(
      'Like',
      name: 'mine_user_info_like',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get mine_user_info_subscribe {
    return Intl.message(
      'Subscribe',
      name: 'mine_user_info_subscribe',
      desc: '',
      args: [],
    );
  }

  /// `Follower`
  String get mine_user_info_follower {
    return Intl.message(
      'Follower',
      name: 'mine_user_info_follower',
      desc: '',
      args: [],
    );
  }

  /// `Liked Videos`
  String get mine_func_zone_liked_videos {
    return Intl.message(
      'Liked Videos',
      name: 'mine_func_zone_liked_videos',
      desc: '',
      args: [],
    );
  }

  /// `Submission Management`
  String get mine_func_zone_submission_management {
    return Intl.message(
      'Submission Management',
      name: 'mine_func_zone_submission_management',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get mine_func_zone_settings {
    return Intl.message(
      'Settings',
      name: 'mine_func_zone_settings',
      desc: '',
      args: [],
    );
  }

  /// `Please login first`
  String get mine_need_login {
    return Intl.message(
      'Please login first',
      name: 'mine_need_login',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get login_user_hint {
    return Intl.message(
      'Username',
      name: 'login_user_hint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get login_password_hint {
    return Intl.message(
      'Password',
      name: 'login_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get login_confirm_password_hint {
    return Intl.message(
      'Confirm Password',
      name: 'login_confirm_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_login_button {
    return Intl.message(
      'Login',
      name: 'login_login_button',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get login_signup_button {
    return Intl.message(
      'Sign Up',
      name: 'login_signup_button',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get login_forgot_password_button {
    return Intl.message(
      'Forgot Password',
      name: 'login_forgot_password_button',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get login_recover_password_button {
    return Intl.message(
      'Send',
      name: 'login_recover_password_button',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get login_go_back_button {
    return Intl.message(
      'Back',
      name: 'login_go_back_button',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get login_confirm_password_error {
    return Intl.message(
      'Passwords do not match',
      name: 'login_confirm_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your username, and we will send a verification code to reset your password to your email`
  String get login_recover_password_intro {
    return Intl.message(
      'Please enter your username, and we will send a verification code to reset your password to your email',
      name: 'login_recover_password_intro',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get login_recover_password_description {
    return Intl.message(
      'Reset Password',
      name: 'login_recover_password_description',
      desc: '',
      args: [],
    );
  }

  /// `A verification code to reset your password has been sent to your email, please check`
  String get login_recover_password_success {
    return Intl.message(
      'A verification code to reset your password has been sent to your email, please check',
      name: 'login_recover_password_success',
      desc: '',
      args: [],
    );
  }

  /// `Other methods to recover`
  String get login_providers_title_first {
    return Intl.message(
      'Other methods to recover',
      name: 'login_providers_title_first',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successful`
  String get login_confirm_recover_success {
    return Intl.message(
      'Password reset successful',
      name: 'login_confirm_recover_success',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get login_confirmation_code_hint {
    return Intl.message(
      'Verification Code',
      name: 'login_confirmation_code_hint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid verification code format`
  String get login_confirmation_code_validation_error {
    return Intl.message(
      'Invalid verification code format',
      name: 'login_confirmation_code_validation_error',
      desc: '',
      args: [],
    );
  }

  /// `A verification code has been sent to your email, please enter the code and new password`
  String get login_confirm_recover_intro {
    return Intl.message(
      'A verification code has been sent to your email, please enter the code and new password',
      name: 'login_confirm_recover_intro',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get login_confirm_signup_button {
    return Intl.message(
      'Sign Up',
      name: 'login_confirm_signup_button',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code`
  String get login_confirm_signup_intro {
    return Intl.message(
      'Please enter the verification code',
      name: 'login_confirm_signup_intro',
      desc: '',
      args: [],
    );
  }

  /// `Sign up successful`
  String get login_confirm_signup_success {
    return Intl.message(
      'Sign up successful',
      name: 'login_confirm_signup_success',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get login_resend_code_button {
    return Intl.message(
      'Resend',
      name: 'login_resend_code_button',
      desc: '',
      args: [],
    );
  }

  /// `A verification code has been sent to your email, please check`
  String get login_resend_code_success {
    return Intl.message(
      'A verification code has been sent to your email, please check',
      name: 'login_resend_code_success',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get login_recovery_code_hint {
    return Intl.message(
      'Verification Code',
      name: 'login_recovery_code_hint',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get login_recover_code_password_description {
    return Intl.message(
      'Reset Password',
      name: 'login_recover_code_password_description',
      desc: '',
      args: [],
    );
  }

  /// `Invalid verification code format`
  String get login_recovery_code_validation_error {
    return Intl.message(
      'Invalid verification code format',
      name: 'login_recovery_code_validation_error',
      desc: '',
      args: [],
    );
  }

  /// `A verification code has been sent to your email, please check`
  String get login_sign_up_success {
    return Intl.message(
      'A verification code has been sent to your email, please check',
      name: 'login_sign_up_success',
      desc: '',
      args: [],
    );
  }

  /// `Set Password`
  String get login_set_password_button {
    return Intl.message(
      'Set Password',
      name: 'login_set_password_button',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get login_flushbar_title_error {
    return Intl.message(
      'Error',
      name: 'login_flushbar_title_error',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get login_flushbar_title_success {
    return Intl.message(
      'Success',
      name: 'login_flushbar_title_success',
      desc: '',
      args: [],
    );
  }

  /// `Or use the following methods to log in`
  String get login_providers_title_second {
    return Intl.message(
      'Or use the following methods to log in',
      name: 'login_providers_title_second',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email, and we will send a verification code to register to your email`
  String get login_additional_sign_up_form_description {
    return Intl.message(
      'Please enter your email, and we will send a verification code to register to your email',
      name: 'login_additional_sign_up_form_description',
      desc: '',
      args: [],
    );
  }

  /// `Send Verification Code`
  String get login_additional_sign_up_submit_button {
    return Intl.message(
      'Send Verification Code',
      name: 'login_additional_sign_up_submit_button',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get login_additional_sign_up_email_hint {
    return Intl.message(
      'Email',
      name: 'login_additional_sign_up_email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get login_additional_sign_up_email_empty {
    return Intl.message(
      'Email cannot be empty',
      name: 'login_additional_sign_up_email_empty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get login_additional_sign_up_email_validation_error {
    return Intl.message(
      'Invalid email format',
      name: 'login_additional_sign_up_email_validation_error',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be empty`
  String get login_user_empty {
    return Intl.message(
      'Username cannot be empty',
      name: 'login_user_empty',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get login_password_empty {
    return Intl.message(
      'Password cannot be empty',
      name: 'login_password_empty',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get login_recover_page_reset_password {
    return Intl.message(
      'Reset Password',
      name: 'login_recover_page_reset_password',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get login_recover_page_reset_email {
    return Intl.message(
      '',
      name: 'login_recover_page_reset_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get login_recover_page_reset_email_hint {
    return Intl.message(
      'Enter your email',
      name: 'login_recover_page_reset_email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get login_recover_page_reset_email_error {
    return Intl.message(
      'Invalid email format',
      name: 'login_recover_page_reset_email_error',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get login_recover_page_reset_code {
    return Intl.message(
      '',
      name: 'login_recover_page_reset_code',
      desc: '',
      args: [],
    );
  }

  /// `Enter verification code`
  String get login_recover_page_reset_code_hint {
    return Intl.message(
      'Enter verification code',
      name: 'login_recover_page_reset_code_hint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid verification code`
  String get login_recover_page_reset_code_error {
    return Intl.message(
      'Invalid verification code',
      name: 'login_recover_page_reset_code_error',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get login_recover_page_send_reset_code {
    return Intl.message(
      'Send',
      name: 'login_recover_page_send_reset_code',
      desc: '',
      args: [],
    );
  }

  /// `Wait for {seconds}s`
  String login_recover_page_send_reset_code_on_countdown(int seconds) {
    return Intl.message(
      'Wait for ${seconds}s',
      name: 'login_recover_page_send_reset_code_on_countdown',
      desc: '',
      args: [seconds],
    );
  }

  /// `Verification code has been sent`
  String get login_recover_page_reset_code_has_sent {
    return Intl.message(
      'Verification code has been sent',
      name: 'login_recover_page_reset_code_has_sent',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get login_recover_page_new_password {
    return Intl.message(
      '',
      name: 'login_recover_page_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter a new password`
  String get login_recover_page_new_password_hint {
    return Intl.message(
      'Enter a new password',
      name: 'login_recover_page_new_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain letters and numbers, at least 8 characters`
  String get login_recover_page_new_password_error {
    return Intl.message(
      'Password must contain letters and numbers, at least 8 characters',
      name: 'login_recover_page_new_password_error',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get login_recover_page_confirm_password {
    return Intl.message(
      '',
      name: 'login_recover_page_confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter the new password`
  String get login_recover_page_confirm_password_hint {
    return Intl.message(
      'Re-enter the new password',
      name: 'login_recover_page_confirm_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get login_recover_page_confirm_password_error {
    return Intl.message(
      'Passwords do not match',
      name: 'login_recover_page_confirm_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successful`
  String get login_recover_page_reset_password_success {
    return Intl.message(
      'Password reset successful',
      name: 'login_recover_page_reset_password_success',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get login_recover_page_cancel {
    return Intl.message(
      'Cancel',
      name: 'login_recover_page_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get login_recover_page_confirm {
    return Intl.message(
      'Confirm',
      name: 'login_recover_page_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_title {
    return Intl.message(
      'Settings',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get settings_light_dark_switch {
    return Intl.message(
      'Dark Mode',
      name: 'settings_light_dark_switch',
      desc: '',
      args: [],
    );
  }

  /// `Change Theme`
  String get settings_change_theme {
    return Intl.message(
      'Change Theme',
      name: 'settings_change_theme',
      desc: '',
      args: [],
    );
  }

  /// `Select Theme`
  String get settings_select_theme {
    return Intl.message(
      'Select Theme',
      name: 'settings_select_theme',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get settings_change_language {
    return Intl.message(
      'Change Language',
      name: 'settings_change_language',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get settings_select_language {
    return Intl.message(
      'Select Language',
      name: 'settings_select_language',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get settings_about_us {
    return Intl.message(
      'About Us',
      name: 'settings_about_us',
      desc: '',
      args: [],
    );
  }

  /// `Nothing here~`
  String get settings_about_us_noting {
    return Intl.message(
      'Nothing here~',
      name: 'settings_about_us_noting',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get settings_logout {
    return Intl.message(
      'Logout',
      name: 'settings_logout',
      desc: '',
      args: [],
    );
  }

  /// `Logout successful`
  String get settings_logout_success {
    return Intl.message(
      'Logout successful',
      name: 'settings_logout_success',
      desc: '',
      args: [],
    );
  }

  /// `Multi-Factor Authentication`
  String get mfa_title {
    return Intl.message(
      'Multi-Factor Authentication',
      name: 'mfa_title',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your MFA verification code`
  String get mfa_hint {
    return Intl.message(
      'Please enter your MFA verification code',
      name: 'mfa_hint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid MFA verification code`
  String get mfa_validation_error {
    return Intl.message(
      'Invalid MFA verification code',
      name: 'mfa_validation_error',
      desc: '',
      args: [],
    );
  }

  /// `Verifying...`
  String get mfa_verifying {
    return Intl.message(
      'Verifying...',
      name: 'mfa_verifying',
      desc: '',
      args: [],
    );
  }

  /// `Click the countdown to skip~`
  String get loading_hint {
    return Intl.message(
      'Click the countdown to skip~',
      name: 'loading_hint',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get loading_skip {
    return Intl.message(
      'Skip',
      name: 'loading_skip',
      desc: '',
      args: [],
    );
  }

  /// `Loading, please try again later`
  String get loading_not_completed {
    return Intl.message(
      'Loading, please try again later',
      name: 'loading_not_completed',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get space_video {
    return Intl.message(
      'Video',
      name: 'space_video',
      desc: '',
      args: [],
    );
  }

  /// `Dynamic`
  String get space_dynamic {
    return Intl.message(
      'Dynamic',
      name: 'space_dynamic',
      desc: '',
      args: [],
    );
  }

  /// `Follower`
  String get space_follower {
    return Intl.message(
      'Follower',
      name: 'space_follower',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get space_following {
    return Intl.message(
      'Subscribe',
      name: 'space_following',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get space_like {
    return Intl.message(
      'Like',
      name: 'space_like',
      desc: '',
      args: [],
    );
  }

  /// `Nothing here~`
  String get space_nothing_hint {
    return Intl.message(
      'Nothing here~',
      name: 'space_nothing_hint',
      desc: '',
      args: [],
    );
  }

  /// `Really nothing here~`
  String get space_nothing_hint_bottom {
    return Intl.message(
      'Really nothing here~',
      name: 'space_nothing_hint_bottom',
      desc: '',
      args: [],
    );
  }

  /// `Upload successful`
  String get space_upload_avatar_success {
    return Intl.message(
      'Upload successful',
      name: 'space_upload_avatar_success',
      desc: '',
      args: [],
    );
  }

  /// `Operation successful`
  String get space_follow_action_success {
    return Intl.message(
      'Operation successful',
      name: 'space_follow_action_success',
      desc: '',
      args: [],
    );
  }

  /// `Upload Avatar`
  String get space_upload_avatar {
    return Intl.message(
      'Upload Avatar',
      name: 'space_upload_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Upload failed`
  String get space_upload_avatar_error {
    return Intl.message(
      'Upload failed',
      name: 'space_upload_avatar_error',
      desc: '',
      args: [],
    );
  }

  /// `Please select the correct image`
  String get space_upload_avatar_not_select {
    return Intl.message(
      'Please select the correct image',
      name: 'space_upload_avatar_not_select',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get space_follow {
    return Intl.message(
      'Follow',
      name: 'space_follow',
      desc: '',
      args: [],
    );
  }

  /// `Followed`
  String get space_followed {
    return Intl.message(
      'Followed',
      name: 'space_followed',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a search term`
  String get search_input_box_no_text_hint {
    return Intl.message(
      'Please enter a search term',
      name: 'search_input_box_no_text_hint',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get search_video {
    return Intl.message(
      'Video',
      name: 'search_video',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get search_user {
    return Intl.message(
      'User',
      name: 'search_user',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get search_follow {
    return Intl.message(
      'Follow',
      name: 'search_follow',
      desc: '',
      args: [],
    );
  }

  /// `Try another keyword~`
  String get search_nothing_hint_bottom {
    return Intl.message(
      'Try another keyword~',
      name: 'search_nothing_hint_bottom',
      desc: '',
      args: [],
    );
  }

  /// `No related users found`
  String get search_nothing_hint_bottom_user {
    return Intl.message(
      'No related users found',
      name: 'search_nothing_hint_bottom_user',
      desc: '',
      args: [],
    );
  }

  /// `No related videos found`
  String get search_nothing_hint_bottom_video {
    return Intl.message(
      'No related videos found',
      name: 'search_nothing_hint_bottom_video',
      desc: '',
      args: [],
    );
  }

  /// `Followed`
  String get search_followed {
    return Intl.message(
      'Followed',
      name: 'search_followed',
      desc: '',
      args: [],
    );
  }

  /// ` Followers`
  String get search_follower {
    return Intl.message(
      ' Followers',
      name: 'search_follower',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get search_loading_hint {
    return Intl.message(
      'Loading...',
      name: 'search_loading_hint',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get video_card_report {
    return Intl.message(
      'Report',
      name: 'video_card_report',
      desc: '',
      args: [],
    );
  }

  /// `Uninterested`
  String get video_card_uninterested {
    return Intl.message(
      'Uninterested',
      name: 'video_card_uninterested',
      desc: '',
      args: [],
    );
  }

  /// `We will try to show you less similar content`
  String get video_card_uninterested_success {
    return Intl.message(
      'We will try to show you less similar content',
      name: 'video_card_uninterested_success',
      desc: '',
      args: [],
    );
  }

  /// `Default`
  String get flex_scheme_default {
    return Intl.message(
      'Default',
      name: 'flex_scheme_default',
      desc: '',
      args: [],
    );
  }

  /// `Material 2 default`
  String get flex_scheme_material {
    return Intl.message(
      'Material 2 default',
      name: 'flex_scheme_material',
      desc: '',
      args: [],
    );
  }

  /// `Material high contrast`
  String get flex_scheme_materialHc {
    return Intl.message(
      'Material high contrast',
      name: 'flex_scheme_materialHc',
      desc: '',
      args: [],
    );
  }

  /// `Blue delight`
  String get flex_scheme_blue {
    return Intl.message(
      'Blue delight',
      name: 'flex_scheme_blue',
      desc: '',
      args: [],
    );
  }

  /// `Indigo nights`
  String get flex_scheme_indigo {
    return Intl.message(
      'Indigo nights',
      name: 'flex_scheme_indigo',
      desc: '',
      args: [],
    );
  }

  /// `Hippie blue`
  String get flex_scheme_hippieBlue {
    return Intl.message(
      'Hippie blue',
      name: 'flex_scheme_hippieBlue',
      desc: '',
      args: [],
    );
  }

  /// `Aqua blue`
  String get flex_scheme_aquaBlue {
    return Intl.message(
      'Aqua blue',
      name: 'flex_scheme_aquaBlue',
      desc: '',
      args: [],
    );
  }

  /// `Brand blues`
  String get flex_scheme_brandBlue {
    return Intl.message(
      'Brand blues',
      name: 'flex_scheme_brandBlue',
      desc: '',
      args: [],
    );
  }

  /// `Deep blue sea`
  String get flex_scheme_deepBlue {
    return Intl.message(
      'Deep blue sea',
      name: 'flex_scheme_deepBlue',
      desc: '',
      args: [],
    );
  }

  /// `Pink sakura`
  String get flex_scheme_sakura {
    return Intl.message(
      'Pink sakura',
      name: 'flex_scheme_sakura',
      desc: '',
      args: [],
    );
  }

  /// `Oh Mandy red`
  String get flex_scheme_mandyRed {
    return Intl.message(
      'Oh Mandy red',
      name: 'flex_scheme_mandyRed',
      desc: '',
      args: [],
    );
  }

  /// `Red tornado`
  String get flex_scheme_red {
    return Intl.message(
      'Red tornado',
      name: 'flex_scheme_red',
      desc: '',
      args: [],
    );
  }

  /// `Red red wine`
  String get flex_scheme_redWine {
    return Intl.message(
      'Red red wine',
      name: 'flex_scheme_redWine',
      desc: '',
      args: [],
    );
  }

  /// `Purple brown`
  String get flex_scheme_purpleBrown {
    return Intl.message(
      'Purple brown',
      name: 'flex_scheme_purpleBrown',
      desc: '',
      args: [],
    );
  }

  /// `Green forest`
  String get flex_scheme_green {
    return Intl.message(
      'Green forest',
      name: 'flex_scheme_green',
      desc: '',
      args: [],
    );
  }

  /// `Green money`
  String get flex_scheme_money {
    return Intl.message(
      'Green money',
      name: 'flex_scheme_money',
      desc: '',
      args: [],
    );
  }

  /// `Green jungle`
  String get flex_scheme_jungle {
    return Intl.message(
      'Green jungle',
      name: 'flex_scheme_jungle',
      desc: '',
      args: [],
    );
  }

  /// `Grey law`
  String get flex_scheme_greyLaw {
    return Intl.message(
      'Grey law',
      name: 'flex_scheme_greyLaw',
      desc: '',
      args: [],
    );
  }

  /// `Willow and wasabi`
  String get flex_scheme_wasabi {
    return Intl.message(
      'Willow and wasabi',
      name: 'flex_scheme_wasabi',
      desc: '',
      args: [],
    );
  }

  /// `Gold sunset`
  String get flex_scheme_gold {
    return Intl.message(
      'Gold sunset',
      name: 'flex_scheme_gold',
      desc: '',
      args: [],
    );
  }

  /// `Mango mojito`
  String get flex_scheme_mango {
    return Intl.message(
      'Mango mojito',
      name: 'flex_scheme_mango',
      desc: '',
      args: [],
    );
  }

  /// `Amber blue`
  String get flex_scheme_amber {
    return Intl.message(
      'Amber blue',
      name: 'flex_scheme_amber',
      desc: '',
      args: [],
    );
  }

  /// `Vesuvius burned`
  String get flex_scheme_vesuviusBurn {
    return Intl.message(
      'Vesuvius burned',
      name: 'flex_scheme_vesuviusBurn',
      desc: '',
      args: [],
    );
  }

  /// `Deep purple`
  String get flex_scheme_deepPurple {
    return Intl.message(
      'Deep purple',
      name: 'flex_scheme_deepPurple',
      desc: '',
      args: [],
    );
  }

  /// `Ebony clay`
  String get flex_scheme_ebonyClay {
    return Intl.message(
      'Ebony clay',
      name: 'flex_scheme_ebonyClay',
      desc: '',
      args: [],
    );
  }

  /// `Barossa`
  String get flex_scheme_barossa {
    return Intl.message(
      'Barossa',
      name: 'flex_scheme_barossa',
      desc: '',
      args: [],
    );
  }

  /// `Shark and orange`
  String get flex_scheme_shark {
    return Intl.message(
      'Shark and orange',
      name: 'flex_scheme_shark',
      desc: '',
      args: [],
    );
  }

  /// `Big stone tulip`
  String get flex_scheme_bigStone {
    return Intl.message(
      'Big stone tulip',
      name: 'flex_scheme_bigStone',
      desc: '',
      args: [],
    );
  }

  /// `Damask and lunar`
  String get flex_scheme_damask {
    return Intl.message(
      'Damask and lunar',
      name: 'flex_scheme_damask',
      desc: '',
      args: [],
    );
  }

  /// `Bahama and trinidad`
  String get flex_scheme_bahamaBlue {
    return Intl.message(
      'Bahama and trinidad',
      name: 'flex_scheme_bahamaBlue',
      desc: '',
      args: [],
    );
  }

  /// `Mallard and valencia`
  String get flex_scheme_mallardGreen {
    return Intl.message(
      'Mallard and valencia',
      name: 'flex_scheme_mallardGreen',
      desc: '',
      args: [],
    );
  }

  /// `Espresso and crema`
  String get flex_scheme_espresso {
    return Intl.message(
      'Espresso and crema',
      name: 'flex_scheme_espresso',
      desc: '',
      args: [],
    );
  }

  /// `Outer space stage`
  String get flex_scheme_outerSpace {
    return Intl.message(
      'Outer space stage',
      name: 'flex_scheme_outerSpace',
      desc: '',
      args: [],
    );
  }

  /// `Blue whale`
  String get flex_scheme_blueWhale {
    return Intl.message(
      'Blue whale',
      name: 'flex_scheme_blueWhale',
      desc: '',
      args: [],
    );
  }

  /// `San Juan blue`
  String get flex_scheme_sanJuanBlue {
    return Intl.message(
      'San Juan blue',
      name: 'flex_scheme_sanJuanBlue',
      desc: '',
      args: [],
    );
  }

  /// `Rosewood`
  String get flex_scheme_rosewood {
    return Intl.message(
      'Rosewood',
      name: 'flex_scheme_rosewood',
      desc: '',
      args: [],
    );
  }

  /// `Blumine`
  String get flex_scheme_blumineBlue {
    return Intl.message(
      'Blumine',
      name: 'flex_scheme_blumineBlue',
      desc: '',
      args: [],
    );
  }

  /// `Flutter Dash`
  String get flex_scheme_flutterDash {
    return Intl.message(
      'Flutter Dash',
      name: 'flex_scheme_flutterDash',
      desc: '',
      args: [],
    );
  }

  /// `Material 3 purple`
  String get flex_scheme_materialBaseline {
    return Intl.message(
      'Material 3 purple',
      name: 'flex_scheme_materialBaseline',
      desc: '',
      args: [],
    );
  }

  /// `Verdun green`
  String get flex_scheme_verdunHemlock {
    return Intl.message(
      'Verdun green',
      name: 'flex_scheme_verdunHemlock',
      desc: '',
      args: [],
    );
  }

  /// `Dell genoa green`
  String get flex_scheme_dellGenoa {
    return Intl.message(
      'Dell genoa green',
      name: 'flex_scheme_dellGenoa',
      desc: '',
      args: [],
    );
  }

  /// `Thunderbird red`
  String get flex_scheme_redM3 {
    return Intl.message(
      'Thunderbird red',
      name: 'flex_scheme_redM3',
      desc: '',
      args: [],
    );
  }

  /// `Lipstick pink`
  String get flex_scheme_pinkM3 {
    return Intl.message(
      'Lipstick pink',
      name: 'flex_scheme_pinkM3',
      desc: '',
      args: [],
    );
  }

  /// `Eggplant purple`
  String get flex_scheme_purpleM3 {
    return Intl.message(
      'Eggplant purple',
      name: 'flex_scheme_purpleM3',
      desc: '',
      args: [],
    );
  }

  /// `Indigo San Marino`
  String get flex_scheme_indigoM3 {
    return Intl.message(
      'Indigo San Marino',
      name: 'flex_scheme_indigoM3',
      desc: '',
      args: [],
    );
  }

  /// `Endeavour blue`
  String get flex_scheme_blueM3 {
    return Intl.message(
      'Endeavour blue',
      name: 'flex_scheme_blueM3',
      desc: '',
      args: [],
    );
  }

  /// `Mosque cyan`
  String get flex_scheme_cyanM3 {
    return Intl.message(
      'Mosque cyan',
      name: 'flex_scheme_cyanM3',
      desc: '',
      args: [],
    );
  }

  /// `Blue stone teal`
  String get flex_scheme_tealM3 {
    return Intl.message(
      'Blue stone teal',
      name: 'flex_scheme_tealM3',
      desc: '',
      args: [],
    );
  }

  /// `Camarone green`
  String get flex_scheme_greenM3 {
    return Intl.message(
      'Camarone green',
      name: 'flex_scheme_greenM3',
      desc: '',
      args: [],
    );
  }

  /// `Verdun lime`
  String get flex_scheme_limeM3 {
    return Intl.message(
      'Verdun lime',
      name: 'flex_scheme_limeM3',
      desc: '',
      args: [],
    );
  }

  /// `Yukon gold yellow`
  String get flex_scheme_yellowM3 {
    return Intl.message(
      'Yukon gold yellow',
      name: 'flex_scheme_yellowM3',
      desc: '',
      args: [],
    );
  }

  /// `Brown orange`
  String get flex_scheme_orangeM3 {
    return Intl.message(
      'Brown orange',
      name: 'flex_scheme_orangeM3',
      desc: '',
      args: [],
    );
  }

  /// `Rust deep orange`
  String get flex_scheme_deepOrangeM3 {
    return Intl.message(
      'Rust deep orange',
      name: 'flex_scheme_deepOrangeM3',
      desc: '',
      args: [],
    );
  }

  /// `Black and white`
  String get flex_scheme_blackWhite {
    return Intl.message(
      'Black and white',
      name: 'flex_scheme_blackWhite',
      desc: '',
      args: [],
    );
  }

  /// `Grey`
  String get flex_scheme_greys {
    return Intl.message(
      'Grey',
      name: 'flex_scheme_greys',
      desc: '',
      args: [],
    );
  }

  /// `Sepia`
  String get flex_scheme_sepia {
    return Intl.message(
      'Sepia',
      name: 'flex_scheme_sepia',
      desc: '',
      args: [],
    );
  }

  /// `Select video`
  String get submit_select_video_hint {
    return Intl.message(
      'Select video',
      name: 'submit_select_video_hint',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get submit_video_title_hint {
    return Intl.message(
      'Title',
      name: 'submit_video_title_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter title`
  String get submit_video_title_input_hint {
    return Intl.message(
      'Enter title',
      name: 'submit_video_title_input_hint',
      desc: '',
      args: [],
    );
  }

  /// ` {count}/{max} characters`
  String submit_video_title_additional_hint(int count, int max) {
    return Intl.message(
      ' $count/$max characters',
      name: 'submit_video_title_additional_hint',
      desc: '',
      args: [count, max],
    );
  }

  /// `Title cannot be empty`
  String get submit_video_title_error {
    return Intl.message(
      'Title cannot be empty',
      name: 'submit_video_title_error',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get submit_video_description_hint {
    return Intl.message(
      'Description',
      name: 'submit_video_description_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter description`
  String get submit_video_description_input_hint {
    return Intl.message(
      'Enter description',
      name: 'submit_video_description_input_hint',
      desc: '',
      args: [],
    );
  }

  /// `Description cannot be empty`
  String get submit_video_description_error {
    return Intl.message(
      'Description cannot be empty',
      name: 'submit_video_description_error',
      desc: '',
      args: [],
    );
  }

  /// `Select category`
  String get submit_video_category_hint {
    return Intl.message(
      'Select category',
      name: 'submit_video_category_hint',
      desc: '',
      args: [],
    );
  }

  /// `Category cannot be empty`
  String get submit_video_category_error {
    return Intl.message(
      'Category cannot be empty',
      name: 'submit_video_category_error',
      desc: '',
      args: [],
    );
  }

  /// `Add tags`
  String get submit_video_tag_hint {
    return Intl.message(
      'Add tags',
      name: 'submit_video_tag_hint',
      desc: '',
      args: [],
    );
  }

  /// `{count} tags entered`
  String submit_video_tag_additional_hint(int count) {
    return Intl.message(
      '$count tags entered',
      name: 'submit_video_tag_additional_hint',
      desc: '',
      args: [count],
    );
  }

  /// `Tags`
  String get submit_popup_tag_label {
    return Intl.message(
      'Tags',
      name: 'submit_popup_tag_label',
      desc: '',
      args: [],
    );
  }

  /// `Enter tags`
  String get submit_popup_tag_hint {
    return Intl.message(
      'Enter tags',
      name: 'submit_popup_tag_hint',
      desc: '',
      args: [],
    );
  }

  /// `Maximum {count} characters`
  String submit_popup_additional_hint(int count) {
    return Intl.message(
      'Maximum $count characters',
      name: 'submit_popup_additional_hint',
      desc: '',
      args: [count],
    );
  }

  /// `Clear`
  String get submit_popup_clear_button {
    return Intl.message(
      'Clear',
      name: 'submit_popup_clear_button',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get submit_popup_confirm_button {
    return Intl.message(
      'Confirm',
      name: 'submit_popup_confirm_button',
      desc: '',
      args: [],
    );
  }

  /// `Duplicate tag`
  String get submit_video_tag_duplicate {
    return Intl.message(
      'Duplicate tag',
      name: 'submit_video_tag_duplicate',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get submit_clear_button {
    return Intl.message(
      'Clear',
      name: 'submit_clear_button',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit_submit_button {
    return Intl.message(
      'Submit',
      name: 'submit_submit_button',
      desc: '',
      args: [],
    );
  }

  /// `No video selected`
  String get submit_video_not_selected {
    return Intl.message(
      'No video selected',
      name: 'submit_video_not_selected',
      desc: '',
      args: [],
    );
  }

  /// `Uploading, please do not close the page`
  String get submit_video_uploading_hint {
    return Intl.message(
      'Uploading, please do not close the page',
      name: 'submit_video_uploading_hint',
      desc: '',
      args: [],
    );
  }

  /// `Uploading...`
  String get submit_video_uploading_hint_bottom {
    return Intl.message(
      'Uploading...',
      name: 'submit_video_uploading_hint_bottom',
      desc: '',
      args: [],
    );
  }

  /// `Upload successful`
  String get submit_video_uploading_success {
    return Intl.message(
      'Upload successful',
      name: 'submit_video_uploading_success',
      desc: '',
      args: [],
    );
  }

  /// `Title cannot be empty`
  String get submit_video_title_empty {
    return Intl.message(
      'Title cannot be empty',
      name: 'submit_video_title_empty',
      desc: '',
      args: [],
    );
  }

  /// `Description cannot be empty`
  String get submit_video_description_empty {
    return Intl.message(
      'Description cannot be empty',
      name: 'submit_video_description_empty',
      desc: '',
      args: [],
    );
  }

  /// `Please select a category`
  String get submit_video_category_empty {
    return Intl.message(
      'Please select a category',
      name: 'submit_video_category_empty',
      desc: '',
      args: [],
    );
  }

  /// `Please add at least one tag`
  String get submit_video_tag_empty {
    return Intl.message(
      'Please add at least one tag',
      name: 'submit_video_tag_empty',
      desc: '',
      args: [],
    );
  }

  /// `My Friends`
  String get friend_title {
    return Intl.message(
      'My Friends',
      name: 'friend_title',
      desc: '',
      args: [],
    );
  }

  /// `Friends are people who follow each other`
  String get friend_about_description {
    return Intl.message(
      'Friends are people who follow each other',
      name: 'friend_about_description',
      desc: '',
      args: [],
    );
  }

  /// `Submission Management`
  String get submission_management_title {
    return Intl.message(
      'Submission Management',
      name: 'submission_management_title',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get submission_management_kind_all {
    return Intl.message(
      'All',
      name: 'submission_management_kind_all',
      desc: '',
      args: [],
    );
  }

  /// `Passed`
  String get submission_management_kind_passed {
    return Intl.message(
      'Passed',
      name: 'submission_management_kind_passed',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get submission_management_kind_review {
    return Intl.message(
      'Review',
      name: 'submission_management_kind_review',
      desc: '',
      args: [],
    );
  }

  /// `Locked`
  String get submission_management_kind_locked {
    return Intl.message(
      'Locked',
      name: 'submission_management_kind_locked',
      desc: '',
      args: [],
    );
  }

  /// `Dynamic`
  String get dynamic_title {
    return Intl.message(
      'Dynamic',
      name: 'dynamic_title',
      desc: '',
      args: [],
    );
  }

  /// `Refresh successful`
  String get dynamic_refresh_success {
    return Intl.message(
      'Refresh successful',
      name: 'dynamic_refresh_success',
      desc: '',
      args: [],
    );
  }

  /// `Load successful`
  String get dynamic_load_success {
    return Intl.message(
      'Load successful',
      name: 'dynamic_load_success',
      desc: '',
      args: [],
    );
  }

  /// `Save image`
  String get dynamic_save_image {
    return Intl.message(
      'Save image',
      name: 'dynamic_save_image',
      desc: '',
      args: [],
    );
  }

  /// `Save failed`
  String get dynamic_save_image_failed {
    return Intl.message(
      'Save failed',
      name: 'dynamic_save_image_failed',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comment_popup_title {
    return Intl.message(
      'Comments',
      name: 'comment_popup_title',
      desc: '',
      args: [],
    );
  }

  /// `Leave a comment~`
  String get reply_comment_popup_hint {
    return Intl.message(
      'Leave a comment~',
      name: 'reply_comment_popup_hint',
      desc: '',
      args: [],
    );
  }

  /// `Comment successful`
  String get reply_comment_popup_submit_success {
    return Intl.message(
      'Comment successful',
      name: 'reply_comment_popup_submit_success',
      desc: '',
      args: [],
    );
  }

  /// `Post Dynamic`
  String get dynamic_post_title {
    return Intl.message(
      'Post Dynamic',
      name: 'dynamic_post_title',
      desc: '',
      args: [],
    );
  }

  /// `Please select the correct image`
  String get dynamic_post_not_select_right_image {
    return Intl.message(
      'Please select the correct image',
      name: 'dynamic_post_not_select_right_image',
      desc: '',
      args: [],
    );
  }

  /// `Upload image`
  String get dynamic_post_upload_image {
    return Intl.message(
      'Upload image',
      name: 'dynamic_post_upload_image',
      desc: '',
      args: [],
    );
  }

  /// `What's on your mind...`
  String get dynamic_post_textarea_hint {
    return Intl.message(
      'What\'s on your mind...',
      name: 'dynamic_post_textarea_hint',
      desc: '',
      args: [],
    );
  }

  /// `There's {count} image(s) selected`
  String dynamic_post_image_count_hint(int count) {
    return Intl.message(
      'There\'s $count image(s) selected',
      name: 'dynamic_post_image_count_hint',
      desc: '',
      args: [count],
    );
  }

  /// `Delete successful`
  String get dynamic_post_delete_image_success {
    return Intl.message(
      'Delete successful',
      name: 'dynamic_post_delete_image_success',
      desc: '',
      args: [],
    );
  }

  /// `Post successful`
  String get dynamic_post_submit_success {
    return Intl.message(
      'Post successful',
      name: 'dynamic_post_submit_success',
      desc: '',
      args: [],
    );
  }

  /// `Followers`
  String get follower_title {
    return Intl.message(
      'Followers',
      name: 'follower_title',
      desc: '',
      args: [],
    );
  }

  /// `Subscriptions`
  String get following_title {
    return Intl.message(
      'Subscriptions',
      name: 'following_title',
      desc: '',
      args: [],
    );
  }

  /// `Liked Videos`
  String get liked_video_title {
    return Intl.message(
      'Liked Videos',
      name: 'liked_video_title',
      desc: '',
      args: [],
    );
  }

  /// `Intro`
  String get video_introduction_title {
    return Intl.message(
      'Intro',
      name: 'video_introduction_title',
      desc: '',
      args: [],
    );
  }

  /// `CMT`
  String get video_comments_title {
    return Intl.message(
      'CMT',
      name: 'video_comments_title',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get video_author_follow {
    return Intl.message(
      'Follow',
      name: 'video_author_follow',
      desc: '',
      args: [],
    );
  }

  /// `Followed`
  String get video_author_followed {
    return Intl.message(
      'Followed',
      name: 'video_author_followed',
      desc: '',
      args: [],
    );
  }

  /// `Spam`
  String get report_spamming {
    return Intl.message(
      'Spam',
      name: 'report_spamming',
      desc: '',
      args: [],
    );
  }

  /// `Abuse`
  String get report_abuse {
    return Intl.message(
      'Abuse',
      name: 'report_abuse',
      desc: '',
      args: [],
    );
  }

  /// `Infringement`
  String get report_infringement {
    return Intl.message(
      'Infringement',
      name: 'report_infringement',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get report_other {
    return Intl.message(
      'Other',
      name: 'report_other',
      desc: '',
      args: [],
    );
  }

  /// `Report successful`
  String get report_submit_success {
    return Intl.message(
      'Report successful',
      name: 'report_submit_success',
      desc: '',
      args: [],
    );
  }

  /// `Please select a report type`
  String get report_not_select_report_type {
    return Intl.message(
      'Please select a report type',
      name: 'report_not_select_report_type',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the reason for the report`
  String get report_not_type_report_reason {
    return Intl.message(
      'Please enter the reason for the report',
      name: 'report_not_type_report_reason',
      desc: '',
      args: [],
    );
  }

  /// `Enter the reason for the report`
  String get report_report_reason_hint {
    return Intl.message(
      'Enter the reason for the report',
      name: 'report_report_reason_hint',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
