import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../generated/l10n.dart';

class EmptyPlaceHolder extends StatelessWidget {
  const EmptyPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TDImage(
            assetUrl: 'assets/images/cute/konata_dancing.webp',
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.6,
          ),
          Text(
            S.of(context).empty_placeholder_hint,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}
