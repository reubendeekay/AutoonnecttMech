import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:mechanic_admin/auth/reset_password_screen.dart';

import 'package:url_launcher/url_launcher.dart';

class ResetPasswordSuccess extends StatelessWidget {
  const ResetPasswordSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const Spacer(),
          SizedBox(height: 200, child: Lottie.asset('assets/email.json')),
          const Text(
            'Check your mail',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 39, vertical: 15),
            child: Text(
              'We have sent a password recover instructions from to your email',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey[500]),
            ),
          ),
          SizedBox(
            width: 160,
            height: 40,
            child: RaisedButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  AndroidIntent intent = const AndroidIntent(
                    action: 'android.intent.action.MAIN',
                    category: 'android.intent.category.APP_EMAIL',
                  );
                  intent.launch().catchError((e) {});
                } else if (Platform.isIOS) {
                  launch("message://").catchError((e) {});
                }
              },
              color: const Color(0xffF5A623),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'Open email app',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Skip, I\'ll confirm later',
              style: TextStyle(color: Colors.blueGrey[500]),
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Text(
              'Did not receive the email? Check your spam folder',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey[500], fontSize: 13),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: GestureDetector(
              onTap: () => Get.off(() => const ResetPasswordScreen()),
              child: RichText(
                text: TextSpan(
                  text: 'or ',
                  style: TextStyle(color: Colors.blueGrey[500], fontSize: 13),
                  children: [
                    TextSpan(
                      text: 'try another email address',
                      style: TextStyle(
                        color: Colors.blueGrey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
