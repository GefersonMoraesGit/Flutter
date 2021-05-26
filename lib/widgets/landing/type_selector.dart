import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/helpers/theme_preference.dart';
import 'package:haumea/screens/post_by_tag.dart';
import 'package:provider/provider.dart';

class TypeSelector extends StatelessWidget {
  const TypeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isFrench = Provider.of<AppLanguage>(context).appLocal == Locale('fr');
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return ColoredBox(
      color: themeNotifier.getOppositeTheme().scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.only(top: Constants.PADDING, bottom: Constants.PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(AppLocalizations.of(context)!.translate('by_type').toUpperCase(),
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30, fontFamily: 'DINCondensed')),
            ),
            Padding(
              padding: const EdgeInsets.only(top: Constants.PADDING, left: Constants.PADDING),
              child: Column(
                children: [
                  getRow(context: context, tagKey: 'alternative', tagID: isFrench ? 1048 : 1052),
                  getRow(context: context, tagKey: 'electro', tagID: isFrench ? 1062 : 376),
                  getRow(context: context, tagKey: 'ambient', tagID: isFrench ? 125 : 366),
                  getRow(context: context, tagKey: 'pop', tagID: isFrench ? 1042 : 1044),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getRow({context, tagKey, tagID}) {
    return Row(children: [
      Flexible(flex: 1, fit: FlexFit.tight, child: Text('')),
      Flexible(
        flex: 4,
        fit: FlexFit.tight,
        child: InkWell(
            child: Text("${AppLocalizations.of(context)!.translate(tagKey)}",
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontFamily: 'DINCondensed')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostByTag(tagKey: tagKey, tagID: tagID),
                ),
              );
            }),
      ),
      Flexible(
        flex: 2,
        fit: FlexFit.tight,
        child: Text('→',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
            )),
      )
    ]);
  }
}
