import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fulifuli_app/utils/toastification.dart';

class SearchPageTopBar extends StatefulWidget {
  const SearchPageTopBar({super.key, required this.onSearch});

  final Function(String) onSearch;

  @override
  State<StatefulWidget> createState() {
    return _SearchPageTopBarState();
  }
}

class _SearchPageTopBarState extends State<SearchPageTopBar> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: SearchBar(
              hintText: AppLocalizations.of(context)!.home_top_bar_search,
              leading: Icon(
                Icons.search,
                color: Theme.of(context).unselectedWidgetColor,
              ),
              shadowColor: WidgetStatePropertyAll(Theme.of(context).shadowColor.withOpacity(0.4)),
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor),
              side: WidgetStateProperty.all(BorderSide(width: 1.5, color: Theme.of(context).textTheme.labelLarge!.color!)),
              keyboardType: TextInputType.text,
              autoFocus: true,
              onSubmitted: (value) {
                if (value.isEmpty || value == '') {
                  ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.search_input_box_no_text_hint);
                  return;
                }
                widget.onSearch(value);
              },
              onChanged: (value) => {text = value},
            ),
          ),
          TextButton(
            onPressed: () {
              if (text.isEmpty || text == '') {
                ToastificationUtils.showSimpleToastification(context, AppLocalizations.of(context)!.search_input_box_no_text_hint);
                return;
              }
              widget.onSearch(text);
            },
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
            ),
            child: Text(AppLocalizations.of(context)!.home_top_bar_search, style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }
}
