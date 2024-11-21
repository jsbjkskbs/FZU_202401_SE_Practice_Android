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
        title: Text(S.of(context).submission_management_title),
      ),
      body: Center(
        child: SubmissionManageTabsContainer(
          tabs: [
            S.of(context).submission_management_kind_all,
            S.of(context).submission_management_kind_passed,
            S.of(context).submission_management_kind_review,
            S.of(context).submission_management_kind_locked
          ],
        ),
      ),
    );
  }
}
