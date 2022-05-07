import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_admin/helpers/cached_image.dart';

class MechanicPhotos extends StatelessWidget {
  MechanicPhotos(this.pictures, {Key? key}) : super(key: key);
  List<dynamic> pictures;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: pictures
          .map((e) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: AspectRatio(
                aspectRatio: 16 / 7,
                child: cachedImage(
                  e,
                  fit: BoxFit.cover,
                ),
              )))
          .toList(),
      options: CarouselOptions(
        aspectRatio: 16 / 7,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 10),
        autoPlayAnimationDuration: const Duration(seconds: 2),
        autoPlayCurve: Curves.fastLinearToSlowEaseIn,
        // enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
