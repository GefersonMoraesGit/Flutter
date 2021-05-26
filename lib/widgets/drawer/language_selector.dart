import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({
    Key? key,
  }) : super(key: key);

  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late bool french;
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    french = appLanguage.appLocal == Locale("fr");
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(AppLocalizations.of(context)!.translate('language')),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Container(width: 24, height: 24, child: Image.asset('assets/icons/flag_us.png')),
            onTap: () {
              setState(() {
                french = false;
                appLanguage.changeLanguage(Locale("en"));
              });
            },
          ),
          Switch(
            value: french,
            onChanged: (value) {
              setState(() {
                french = value;
                appLanguage.changeLanguage(appLanguage.appLocal == Locale("fr") ? Locale("en") : Locale("fr"));
              });
            },
            activeTrackColor: Colors.grey,
            activeColor: Colors.white,
          ),
          InkWell(
              child: Container(width: 24, height: 24, child: Image.asset('assets/icons/flag_fr.png')),
              onTap: () {
                setState(() {
                  french = true;
                  appLanguage.changeLanguage(Locale("fr"));
                });
              }),
        ],
      )
    ]);
  }
}
