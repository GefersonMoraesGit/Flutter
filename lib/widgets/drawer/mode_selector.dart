import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/theme_preference.dart';
import 'package:provider/provider.dart';

class ModeSelector extends StatefulWidget {
  const ModeSelector({
    Key? key,
  }) : super(key: key);

  @override
  _ModeSelectorState createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {
  late bool darkMode;
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeNotifier>(context);
    darkMode = themeChange.getTheme(true) == darkTheme;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text('Mode'),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Text(AppLocalizations.of(context)!.translate('light')),
            onTap: () {
              setState(() {
                darkMode = false;
                themeChange.setTheme(darkMode ? darkTheme : lightTheme);
              });
            },
          ),
          Switch(
            value: darkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
                themeChange.setTheme(darkMode ? darkTheme : lightTheme);
              });
            },
            activeTrackColor: Colors.grey,
            activeColor: Colors.white,
          ),
          InkWell(
              child: Text(AppLocalizations.of(context)!.translate('dark')),
              onTap: () {
                setState(() {
                  darkMode = true;
                  themeChange.setTheme(darkMode ? darkTheme : lightTheme);
                });
              }),
        ],
      )
    ]);
  }
}
