import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      'material': AppLocalizations.of(context)!.flex_scheme_material,
      'materialHc': AppLocalizations.of(context)!.flex_scheme_materialHc,
      'blue': AppLocalizations.of(context)!.flex_scheme_blue,
      'indigo': AppLocalizations.of(context)!.flex_scheme_indigo,
      'hippieBlue': AppLocalizations.of(context)!.flex_scheme_hippieBlue,
      'aquaBlue': AppLocalizations.of(context)!.flex_scheme_aquaBlue,
      'brandBlue': AppLocalizations.of(context)!.flex_scheme_brandBlue,
      'deepBlue': AppLocalizations.of(context)!.flex_scheme_deepBlue,
      'sakura': AppLocalizations.of(context)!.flex_scheme_sakura,
      'mandyRed': AppLocalizations.of(context)!.flex_scheme_mandyRed,
      'red': AppLocalizations.of(context)!.flex_scheme_red,
      'redWine': AppLocalizations.of(context)!.flex_scheme_redWine,
      'purpleBrown': AppLocalizations.of(context)!.flex_scheme_purpleBrown,
      'green': AppLocalizations.of(context)!.flex_scheme_green,
      'money': AppLocalizations.of(context)!.flex_scheme_money,
      'jungle': AppLocalizations.of(context)!.flex_scheme_jungle,
      'greyLaw': AppLocalizations.of(context)!.flex_scheme_greyLaw,
      'wasabi': AppLocalizations.of(context)!.flex_scheme_wasabi,
      'gold': AppLocalizations.of(context)!.flex_scheme_gold,
      'mango': AppLocalizations.of(context)!.flex_scheme_mango,
      'amber': AppLocalizations.of(context)!.flex_scheme_amber,
      'vesuviusBurn': AppLocalizations.of(context)!.flex_scheme_vesuviusBurn,
      'deepPurple': AppLocalizations.of(context)!.flex_scheme_deepPurple,
      'ebonyClay': AppLocalizations.of(context)!.flex_scheme_ebonyClay,
      'barossa': AppLocalizations.of(context)!.flex_scheme_barossa,
      'shark': AppLocalizations.of(context)!.flex_scheme_shark,
      'bigStone': AppLocalizations.of(context)!.flex_scheme_bigStone,
      'damask': AppLocalizations.of(context)!.flex_scheme_damask,
      'bahamaBlue': AppLocalizations.of(context)!.flex_scheme_bahamaBlue,
      'mallardGreen': AppLocalizations.of(context)!.flex_scheme_mallardGreen,
      'espresso': AppLocalizations.of(context)!.flex_scheme_espresso,
      'outerSpace': AppLocalizations.of(context)!.flex_scheme_outerSpace,
      'blueWhale': AppLocalizations.of(context)!.flex_scheme_blueWhale,
      'sanJuanBlue': AppLocalizations.of(context)!.flex_scheme_sanJuanBlue,
      'rosewood': AppLocalizations.of(context)!.flex_scheme_rosewood,
      'blumineBlue': AppLocalizations.of(context)!.flex_scheme_blumineBlue,
      'flutterDash': AppLocalizations.of(context)!.flex_scheme_flutterDash,
      'materialBaseline': AppLocalizations.of(context)!.flex_scheme_materialBaseline,
      'verdunHemlock': AppLocalizations.of(context)!.flex_scheme_verdunHemlock,
      'dellGenoa': AppLocalizations.of(context)!.flex_scheme_dellGenoa,
      'redM3': AppLocalizations.of(context)!.flex_scheme_redM3,
      'pinkM3': AppLocalizations.of(context)!.flex_scheme_pinkM3,
      'purpleM3': AppLocalizations.of(context)!.flex_scheme_purpleM3,
      'indigoM3': AppLocalizations.of(context)!.flex_scheme_indigoM3,
      'blueM3': AppLocalizations.of(context)!.flex_scheme_blueM3,
      'cyanM3': AppLocalizations.of(context)!.flex_scheme_cyanM3,
      'tealM3': AppLocalizations.of(context)!.flex_scheme_tealM3,
      'greenM3': AppLocalizations.of(context)!.flex_scheme_greenM3,
      'limeM3': AppLocalizations.of(context)!.flex_scheme_limeM3,
      'yellowM3': AppLocalizations.of(context)!.flex_scheme_yellowM3,
      'orangeM3': AppLocalizations.of(context)!.flex_scheme_orangeM3,
      'deepOrangeM3': AppLocalizations.of(context)!.flex_scheme_deepOrangeM3,
      'blackWhite': AppLocalizations.of(context)!.flex_scheme_blackWhite,
      'greys': AppLocalizations.of(context)!.flex_scheme_greys,
      'sepia': AppLocalizations.of(context)!.flex_scheme_sepia,
    };
    return nameMap[name] ?? "sakura";
  }
}
