import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mechanic_admin/finances/widget/expenses_chart.dart';
import 'package:mechanic_admin/finances/widget/finance_top.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/manage_bookings/manage_bookings_screen.dart';
import 'package:mechanic_admin/manage_bookings/reviews_screen.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';

import 'package:provider/provider.dart';

class FinanceOverviewScreen extends StatefulWidget {
  const FinanceOverviewScreen({Key? key}) : super(key: key);

  @override
  State<FinanceOverviewScreen> createState() => _FinanceOverviewScreenState();
}

class _FinanceOverviewScreenState extends State<FinanceOverviewScreen> {
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mechanic = Provider.of<AuthProvider>(context).mechanic!.analytics;

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Your Account', style: TextStyle(color: kPrimaryColor)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const FinanceTop(),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ManageBookingsScreen());
                  },
                  child: buildDetails(
                    title: 'Total Requests',
                    value: mechanic!.requests!.toString(),
                  ),
                ),
              ),
              Expanded(
                child: buildDetails(
                  title: 'Total Income',
                  value: 'KES ' + mechanic.totalEarnings!.toString(),
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const ReviewsScreen());
                  },
                  child: buildDetails(
                    title: 'Ratings Earned',
                    value: (mechanic.rating! / mechanic.ratingCount!)
                        .toStringAsFixed(1),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ManageBookingsScreen());
                  },
                  child: buildDetails(
                    title: 'Pending requests',
                    value: mechanic.pendingRequests! < 0
                        ? '0'
                        : mechanic.pendingRequests!.toString(),
                  ),
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
          const SizedBox(height: 10),
          title('Recent Transactions'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            width: size.width,
            height: 200,
            child: LineChart(
              mainData(isLoaded: isLoaded),
              swapAnimationCurve: Curves.linear,
              swapAnimationDuration: const Duration(milliseconds: 4000),
            ),
          ),
        ],
      ),
    );
  }

  Widget title(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}

Widget buildDetails({String? title, String? value, IconData? icon}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
    padding: const EdgeInsets.all(15),
    color: Colors.blueGrey.withOpacity(0.1),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon ?? Icons.calendar_today_outlined,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            const SizedBox(height: 2.5),
            Text(
              value!,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ],
        ),
      ],
    ),
  );
}
