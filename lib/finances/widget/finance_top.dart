import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mechanic_admin/finances/widget/withdraw_widget.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';

import 'package:provider/provider.dart';

class FinanceTop extends StatelessWidget {
  const FinanceTop({Key? key}) : super(key: key);

  String amount(String amount) {
    return amount.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final balance = Provider.of<AuthProvider>(context).mechanic!.analytics;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 70,
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.blueGrey[300],
            borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset('assets/images/coin.png')),
              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Balance',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    'KES ' + balance!.balance!.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // ),
              const Spacer(),

              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (ctx) {
                        return const WithdrawWidget();
                      });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Icon(
                    FontAwesomeIcons.moneyBill,
                    color: Colors.pinkAccent,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
