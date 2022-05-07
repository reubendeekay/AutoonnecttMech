import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mechanic_admin/helpers/my_ratings.dart';
import 'package:mechanic_admin/models/review_model.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text(
              'Reviews',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            elevation: 0.5,
            iconTheme: const IconThemeData(color: Colors.black)),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('mechanics/$uid/reviews')
              .snapshots(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('No Reviews Yet'),
              );
            }

            List<DocumentSnapshot> docs = snapshot.data!.docs;

            return ListView(
              children: docs
                  .map((e) => ReviewTile(review: ReviewModel.fromJson(e)))
                  .toList(),
            );
          },
        ));
  }
}

class ReviewTile extends StatelessWidget {
  final ReviewModel review;
  const ReviewTile({
    Key? key,
    required this.review,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(review.imageUrl!)),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review.fullName!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2.5,
                ),
                Row(
                  children: [
                    Ratings(
                      rating: review.rating!,
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd/MM/yyyy').format(
                        review.createdAt!.toDate(),
                      ),
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(
                  height: 2.5,
                ),
                Text(
                  review.review!,
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.grey[400]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
