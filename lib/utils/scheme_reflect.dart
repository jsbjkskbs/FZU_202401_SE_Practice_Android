import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';

import '../generated/l10n.dart';

class SchemeReflect {
  static FlexScheme getFlexScheme(String name, {FlexScheme defaultScheme = FlexScheme.sakura}) {
    for (var value in FlexScheme.values) {
      if (value.name == name) {
        debugPrint('SchemeReflect.getFlexScheme: Found scheme name: $name');
        return value;
      }
    }
    debugPrint('SchemeReflect.getFlexScheme: Unknown scheme name: $name');
    return defaultScheme;
  }

  static String getFlexSchemeLocalizedName(String name, BuildContext context) {
    var nameMap = {
      'material': S.of(context).flex_scheme_material,
      'materialHc': S.of(context).flex_scheme_materialHc,
      'blue': S.of(context).flex_scheme_blue,
      'indigo': S.of(context).flex_scheme_indigo,
      'hippieBlue': S.of(context).flex_scheme_hippieBlue,
      'aquaBlue': S.of(context).flex_scheme_aquaBlue,
      'brandBlue': S.of(context).flex_scheme_brandBlue,
      'deepBlue': S.of(context).flex_scheme_deepBlue,
      'sakura': S.of(context).flex_scheme_sakura,
      'mandyRed': S.of(context).flex_scheme_mandyRed,
      'red': S.of(context).flex_scheme_red,
      'redWine': S.of(context).flex_scheme_redWine,
      'purpleBrown': S.of(context).flex_scheme_purpleBrown,
      'green': S.of(context).flex_scheme_green,
      'money': S.of(context).flex_scheme_money,
      'jungle': S.of(context).flex_scheme_jungle,
      'greyLaw': S.of(context).flex_scheme_greyLaw,
      'wasabi': S.of(context).flex_scheme_wasabi,
      'gold': S.of(context).flex_scheme_gold,
      'mango': S.of(context).flex_scheme_mango,
      'amber': S.of(context).flex_scheme_amber,
      'vesuviusBurn': S.of(context).flex_scheme_vesuviusBurn,
      'deepPurple': S.of(context).flex_scheme_deepPurple,
      'ebonyClay': S.of(context).flex_scheme_ebonyClay,
      'barossa': S.of(context).flex_scheme_barossa,
      'shark': S.of(context).flex_scheme_shark,
      'bigStone': S.of(context).flex_scheme_bigStone,
      'damask': S.of(context).flex_scheme_damask,
      'bahamaBlue': S.of(context).flex_scheme_bahamaBlue,
      'mallardGreen': S.of(context).flex_scheme_mallardGreen,
      'espresso': S.of(context).flex_scheme_espresso,
      'outerSpace': S.of(context).flex_scheme_outerSpace,
      'blueWhale': S.of(context).flex_scheme_blueWhale,
      'sanJuanBlue': S.of(context).flex_scheme_sanJuanBlue,
      'rosewood': S.of(context).flex_scheme_rosewood,
      'blumineBlue': S.of(context).flex_scheme_blumineBlue,
      'flutterDash': S.of(context).flex_scheme_flutterDash,
      'materialBaseline': S.of(context).flex_scheme_materialBaseline,
      'verdunHemlock': S.of(context).flex_scheme_verdunHemlock,
      'dellGenoa': S.of(context).flex_scheme_dellGenoa,
      'redM3': S.of(context).flex_scheme_redM3,
      'pinkM3': S.of(context).flex_scheme_pinkM3,
      'purpleM3': S.of(context).flex_scheme_purpleM3,
      'indigoM3': S.of(context).flex_scheme_indigoM3,
      'blueM3': S.of(context).flex_scheme_blueM3,
      'cyanM3': S.of(context).flex_scheme_cyanM3,
      'tealM3': S.of(context).flex_scheme_tealM3,
      'greenM3': S.of(context).flex_scheme_greenM3,
      'limeM3': S.of(context).flex_scheme_limeM3,
      'yellowM3': S.of(context).flex_scheme_yellowM3,
      'orangeM3': S.of(context).flex_scheme_orangeM3,
      'deepOrangeM3': S.of(context).flex_scheme_deepOrangeM3,
      'blackWhite': S.of(context).flex_scheme_blackWhite,
      'greys': S.of(context).flex_scheme_greys,
      'sepia': S.of(context).flex_scheme_sepia,
    };
    return nameMap[name] ?? "sakura";
  }
}
