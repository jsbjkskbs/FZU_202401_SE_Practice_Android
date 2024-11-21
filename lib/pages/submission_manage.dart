import 'package:flutter/material.dart';
import 'package:fulifuli_app/widgets/submission_manage_page/submission_manage_tabs_container.dart';

import '../generated/l10n.dart';

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(S.current.submission_management_title),
      ),
      body: Center(
        child: SubmissionManageTabsContainer(
          tabs: [
            S.current.submission_management_kind_all,
            S.current.submission_management_kind_passed,
            S.current.submission_management_kind_review,
            S.current.submission_management_kind_locked
          ],
        ),
      ),
    );
  }
}
