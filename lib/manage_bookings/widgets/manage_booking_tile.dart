import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/mechanic/manage_bookings/widgets/admin_booking_details.dart';
import 'package:mechanic_admin/models/request_model.dart';

class ManageBookingsTile extends StatelessWidget {
  const ManageBookingsTile({Key? key, required this.booking}) : super(key: key);

  final RequestModel booking;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: kPrimaryColor,
        backgroundImage: CachedNetworkImageProvider(booking.user!.imageUrl ??
            'https://www.theupcoming.co.uk/wp-content/themes/topnews/images/tucuser-avatar-new.png'),
      ),
      title: Text(booking.services!.first.serviceName!),
      subtitle: Text('By ' + booking.user!.fullName!),
      // trailing: const Text(booking),
      onTap: () {
        Get.to(() => AdminBookingDetails(booking: booking));
      },
    );
  }
}
