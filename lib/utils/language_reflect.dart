import 'package:flutter/cupertino.dart';

import '../generated/l10n.dart';

class LanguageReflect {
  static String categoryReflect(BuildContext context, String category) {
    switch (category) {
      case '生活':
        return S.of(context).home_tabs_life;
      case '知识':
        return S.of(context).home_tabs_knowledge;
      case '军事':
        return S.of(context).home_tabs_military;
      case '游戏':
        return S.of(context).home_tabs_game;
      case '影音':
        return S.of(context).home_tabs_vitascope;
      case '新闻':
        return S.of(context).home_tabs_news;
    }
    return category;
  }

  static String reportReflect(BuildContext context, String report) {
    switch (report) {
      case '垃圾信息':
        return S.of(context).report_spamming;
      case '侮辱性语言':
        return S.of(context).report_abuse;
      case '侵权行为':
        return S.of(context).report_infringement;
      case '其他':
        return S.of(context).report_other;
    }
    return report;
  }
}
