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

  static String getFlexSchemeLocalizedName(String name) {
    var nameMap = {
      'material': S.current.flex_scheme_material,
      'materialHc': S.current.flex_scheme_materialHc,
      'blue': S.current.flex_scheme_blue,
      'indigo': S.current.flex_scheme_indigo,
      'hippieBlue': S.current.flex_scheme_hippieBlue,
      'aquaBlue': S.current.flex_scheme_aquaBlue,
      'brandBlue': S.current.flex_scheme_brandBlue,
      'deepBlue': S.current.flex_scheme_deepBlue,
      'sakura': S.current.flex_scheme_sakura,
      'mandyRed': S.current.flex_scheme_mandyRed,
      'red': S.current.flex_scheme_red,
      'redWine': S.current.flex_scheme_redWine,
      'purpleBrown': S.current.flex_scheme_purpleBrown,
      'green': S.current.flex_scheme_green,
      'money': S.current.flex_scheme_money,
      'jungle': S.current.flex_scheme_jungle,
      'greyLaw': S.current.flex_scheme_greyLaw,
      'wasabi': S.current.flex_scheme_wasabi,
      'gold': S.current.flex_scheme_gold,
      'mango': S.current.flex_scheme_mango,
      'amber': S.current.flex_scheme_amber,
      'vesuviusBurn': S.current.flex_scheme_vesuviusBurn,
      'deepPurple': S.current.flex_scheme_deepPurple,
      'ebonyClay': S.current.flex_scheme_ebonyClay,
      'barossa': S.current.flex_scheme_barossa,
      'shark': S.current.flex_scheme_shark,
      'bigStone': S.current.flex_scheme_bigStone,
      'damask': S.current.flex_scheme_damask,
      'bahamaBlue': S.current.flex_scheme_bahamaBlue,
      'mallardGreen': S.current.flex_scheme_mallardGreen,
      'espresso': S.current.flex_scheme_espresso,
      'outerSpace': S.current.flex_scheme_outerSpace,
      'blueWhale': S.current.flex_scheme_blueWhale,
      'sanJuanBlue': S.current.flex_scheme_sanJuanBlue,
      'rosewood': S.current.flex_scheme_rosewood,
      'blumineBlue': S.current.flex_scheme_blumineBlue,
      'flutterDash': S.current.flex_scheme_flutterDash,
      'materialBaseline': S.current.flex_scheme_materialBaseline,
      'verdunHemlock': S.current.flex_scheme_verdunHemlock,
      'dellGenoa': S.current.flex_scheme_dellGenoa,
      'redM3': S.current.flex_scheme_redM3,
      'pinkM3': S.current.flex_scheme_pinkM3,
      'purpleM3': S.current.flex_scheme_purpleM3,
      'indigoM3': S.current.flex_scheme_indigoM3,
      'blueM3': S.current.flex_scheme_blueM3,
      'cyanM3': S.current.flex_scheme_cyanM3,
      'tealM3': S.current.flex_scheme_tealM3,
      'greenM3': S.current.flex_scheme_greenM3,
      'limeM3': S.current.flex_scheme_limeM3,
      'yellowM3': S.current.flex_scheme_yellowM3,
      'orangeM3': S.current.flex_scheme_orangeM3,
      'deepOrangeM3': S.current.flex_scheme_deepOrangeM3,
      'blackWhite': S.current.flex_scheme_blackWhite,
      'greys': S.current.flex_scheme_greys,
      'sepia': S.current.flex_scheme_sepia,
    };
    return nameMap[name] ?? "sakura";
  }
}
