import 'package:flutter/cupertino.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Image(image: AssetImage('assets/images/cute/konata_dancing.webp')),
    );
  }
}
