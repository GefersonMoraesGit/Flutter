import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/models/bottom_tab_provider.dart';
import 'package:provider/provider.dart';

class SeeMore extends StatelessWidget {
  final tabIndex;
  final double size;

  const SeeMore({Key? key, this.tabIndex, this.size = 250.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigationProvider = Provider.of<BottomNavigationBarProvider>(context);
    return InkWell(
      child: Column(
        children: [
          Container(
              height: size,
              width: size,
              decoration: new BoxDecoration(
                color: Colors.black,
              ),
              child: Center(
                  child: Text(AppLocalizations.of(context)!.translate('see_more').toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'DINCondensed', fontSize: 30, color: Colors.white)))),
        ],
      ),
      onTap: () {
        navigationProvider.currentIndex = this.tabIndex;
      },
    );
  }
}
