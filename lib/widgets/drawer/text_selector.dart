import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/theme_preference.dart';
import 'package:provider/provider.dart';

class TextSelector extends StatefulWidget {
  TextSelector({Key? key}) : super(key: key);

  @override
  _TextSelectporState createState() => _TextSelectporState();
}

class _TextSelectporState extends State<TextSelector> {
  int textSize = 1;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeNotifier>(context);
    textSize = themeChange.getTextSize();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(AppLocalizations.of(context)!.translate('text_size')),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(AppLocalizations.of(context)!.translate('system'),
                    style: TextStyle(
                        fontWeight: textSize == 0 ? FontWeight.bold : FontWeight.normal,
                        decoration: textSize == 0 ? TextDecoration.underline : TextDecoration.none)),
              ),
              onTap: () {
                setState(() {
                  textSize = 0;
                  themeChange.setTextSize(textSize);
                });
              },
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text('A',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: textSize == 1 ? FontWeight.bold : FontWeight.normal,
                        decoration: textSize == 1 ? TextDecoration.underline : TextDecoration.none)),
              ),
              onTap: () {
                setState(() {
                  textSize = 1;
                  themeChange.setTextSize(textSize);
                });
              },
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text('A',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: textSize == 2 ? FontWeight.bold : FontWeight.normal,
                        decoration: textSize == 2 ? TextDecoration.underline : TextDecoration.none)),
              ),
              onTap: () {
                setState(() {
                  textSize = 2;
                  themeChange.setTextSize(textSize);
                });
              },
            ),
            InkWell(
              child: Text('A',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: textSize == 3 ? FontWeight.bold : FontWeight.normal,
                      decoration: textSize == 3 ? TextDecoration.underline : TextDecoration.none)),
              onTap: () {
                setState(() {
                  textSize = 3;
                  themeChange.setTextSize(textSize);
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
