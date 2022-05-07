import 'package:flutter/material.dart';
import 'package:mechanic_admin/helpers/cached_image.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/models/service_model.dart';

class ServiceTile extends StatelessWidget {
  final ServiceModel service;
  const ServiceTile(this.service, {Key? key, this.isFile = false})
      : super(key: key);
  final bool isFile;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.1,
      constraints: const BoxConstraints(minHeight: 70),
      child: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              SizedBox(
                  width: size.width * 0.25,
                  height: size.height * 0.1,
                  child: isFile
                      ? Image.file(
                          service.imageFile!,
                          fit: BoxFit.cover,
                        )
                      : cachedImage(
                          service.imageUrl!,
                          fit: BoxFit.cover,
                        )),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    service.serviceName!,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    'KES ' + service.price!,
                    style: const TextStyle(color: kPrimaryColor),
                  ),
                ],
              ))
            ],
          )),
          const Divider()
        ],
      ),
    );
  }
}
