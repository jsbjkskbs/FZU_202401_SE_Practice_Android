import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/submission_manage_page/submission_manage_tabs_container.dart';

class SubmissionManagePage extends StatefulWidget {
  const SubmissionManagePage({super.key});

  static const String routeName = '/submission/manage';

  @override
  State<StatefulWidget> createState() {
    return _SubmissionManagePageState();
  }
}

class _SubmissionManagePageState extends State<SubmissionManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submission Management'),
      ),
      body: Center(
        child: SubmissionManageTabsContainer(
          tabs: [
            'All',
            'Passed',
            'Review',
            'Locked',
          ],
        ),
      ),
    );
  }
}
