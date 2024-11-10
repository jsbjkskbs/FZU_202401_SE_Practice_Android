import 'package:flutter/cupertino.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Image(image: AssetImage('assets/images/cute/konata_dancing.webp')),
    );
  }
}
