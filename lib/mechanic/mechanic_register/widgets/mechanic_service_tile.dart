import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:mechanic_admin/helpers/cached_image.dart';
import 'package:mechanic_admin/mechanic/edit_service.dart';
import 'package:mechanic_admin/models/service_model.dart';

final myColor =
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.6);

class MechanicServiceTile extends StatelessWidget {
  const MechanicServiceTile({Key? key, required this.service})
      : super(key: key);

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => EditServiceScreen(service: service));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  10), // This clips the child            ),
              child: cachedImage(
                service.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AspectRatio(
              aspectRatio: 1.3,
              child: Container(
                decoration: BoxDecoration(
                  color: myColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              )),
          AspectRatio(
            aspectRatio: 1.3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    service.serviceName!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(3.0, 3.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'KES ${service.price}',
                    style: const TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(3.0, 3.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
