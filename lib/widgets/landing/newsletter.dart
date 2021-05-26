import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haumea/helpers/app_language.dart';
import 'package:haumea/helpers/constants.dart';
import 'package:haumea/helpers/theme_preference.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Newsletter extends StatefulWidget {
  const Newsletter({Key? key}) : super(key: key);

  @override
  _NewsletterState createState() => _NewsletterState();
}

class _NewsletterState extends State<Newsletter> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  late String email;
  bool isLoading = false;
  bool haumea = true;
  bool artist = false;
  @override
  Widget build(BuildContext context) {
    var isFrench = Provider.of<AppLanguage>(context).appLocal == Locale('fr');
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return ColoredBox(
      color: themeNotifier.getOppositeTheme().scaffoldBackgroundColor,
      child: Container(
          padding: EdgeInsets.only(top: Constants.PADDING, left: 10, right: 10, bottom: Constants.PADDING),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text('NEWSLETTER',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30, fontFamily: 'DINCondensed')),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10),
                child: Text(AppLocalizations.of(context)!.translate('newsletter_intro'),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15, fontFamily: 'georgia')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(5))),
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              checkColor: Theme.of(context).primaryColor,
                              activeColor: Theme.of(context).accentColor, // color of tick Mark
                              value: haumea,
                              onChanged: (bool? value) {
                                setState(() {
                                  haumea = value!;
                                });
                              },
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: InkWell(
                            child: Text(AppLocalizations.of(context)!.translate('newsletter_haumea'),
                                style: TextStyle(color: Theme.of(context).primaryColor)),
                            onTap: () {
                              setState(() {
                                haumea = !haumea;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(5))),
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: artist,
                              onChanged: (bool? value) {
                                setState(() {
                                  artist = value!;
                                });
                              },
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: InkWell(
                            child: Text(AppLocalizations.of(context)!.translate('newsletter_artist'),
                                style: TextStyle(color: Theme.of(context).primaryColor)),
                            onTap: () {
                              setState(() {
                                artist = !artist;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      TextFormField(
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0.0)),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                          hintText: AppLocalizations.of(context)!.translate('newsletter_placeholder'),
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
                          filled: true,
                        ),
                        onSaved: (email) => this.email = email!,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                      ),
                      if (isLoading)
                        Positioned(
                            child: Container(
                                padding: EdgeInsets.all(8.0),
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(strokeWidth: 2)),
                            right: 10,
                            top: 8)
                      else
                        Positioned(
                          child: Container(
                            height: 48,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => sendEmail(context, isFrench ? "fr" : "en"),
                                  child: Container(
                                    color: Theme.of(context).primaryColor,
                                    padding: EdgeInsets.only(top: 6, bottom: 5, left: 5, right: 5),
                                    height: 30,
                                    child: Text(AppLocalizations.of(context)!.translate('newsletter_submit'),
                                        style: TextStyle(
                                            backgroundColor: Theme.of(context).primaryColor,
                                            color: Theme.of(context).accentColor)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          right: 10,
                          top: 0,
                        )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  sendEmail(context, language) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      var message;
      try {
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> jsonRqst = {
          "email_address": this.email,
          "status": "pending",
          "tags": ["from_mobile"],
          "language": language
        };
        if (haumea) {
          jsonRqst["tags"].add("recap");
        }
        if (artist) {
          jsonRqst["tags"].add("artiste");
        }
        final response = await http.post(
          Uri.parse('https://us-central1-haumea-3f751.cloudfunctions.net/mailChimp'),
          // Uri.parse('http://localhost:5001/haumea-3f751/us-central1/mailChimp'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Access-Control-Allow-Origin': '*',
          },
          body: jsonEncode(jsonRqst),
        );
        if (response.statusCode == 200) {
          message = "Check your email for confirmation!";
          this._emailController.clear();
        } else {
          message = response.body;
          if (message == null) {
            message = "An error occured while adding you to the newsletter";
          }
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        message = "Something went wrong, please try again";
        setState(() {
          isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).accentColor,
        content: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: Text(message, style: TextStyle(color: Theme.of(context).primaryColor))),
        duration: Duration(seconds: 5),
      ));
    }
  }
}
