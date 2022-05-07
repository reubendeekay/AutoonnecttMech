import 'package:flutter/material.dart';
import 'package:mechanic_admin/helpers/my_shimmer.dart';

class ServiceTileShimmer extends StatelessWidget {
  const ServiceTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Row(
        children: [
          MyShimmer(
            child: Container(
              width: size.width * 0.25,
              height: double.infinity,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyShimmer(
                child: Container(
                  height: 15,
                  width: size.height * 0.5,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              MyShimmer(
                child: Container(
                  height: 10,
                  width: size.height * 0.3,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              MyShimmer(
                child: Container(
                  height: 12,
                  width: size.height * 0.2,
                  color: Colors.grey,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
