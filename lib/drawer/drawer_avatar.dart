import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/mechanic_profile/edit_profile_screen.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';

import 'package:provider/provider.dart';

class ProgerssAvatar extends StatefulWidget {
  const ProgerssAvatar({Key? key}) : super(key: key);

  @override
  State<ProgerssAvatar> createState() => _ProgerssAvatarState();
}

class _ProgerssAvatarState extends State<ProgerssAvatar>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _controller;

  @override
  void initState() {
    if (mounted) {
      _controller = AnimationController(
          vsync: this, duration: const Duration(seconds: 1));

      _animation = Tween(begin: 0.0, end: 0.4).animate(_controller!)
        ..addListener(() {});

      _controller!.forward();
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mounted ? _controller!.reverse() : null;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    return InkWell(
      onTap: () {
        Get.to(() => const EditMechanicDetails());
      },
      child: Container(
        margin: const EdgeInsets.only(right: 210),
        width: 110,
        height: 110,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: _animation!.value,
              strokeWidth: 4,
              valueColor: const AlwaysStoppedAnimation(kPrimaryColor),
              backgroundColor: Colors.grey.withOpacity(0.2),
            ),
            Center(
                child: CircleAvatar(
                    radius: 45.0,
                    backgroundImage:
                        CachedNetworkImageProvider(user.user!.imageUrl!))),
          ],
        ),
      ),
    );
  }
}
