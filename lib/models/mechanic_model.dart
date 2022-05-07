import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mechanic_admin/models/analytics_model.dart';

class MechanicModel {
  final String? name;
  final String? profile;
  final File? profileFile;
  List<dynamic>? images = [];
  List<File>? fileImages = [];
  final String? phone;
  final String? description;
  final String? openingTime;
  final String? closingTime;
  final String? address;
  final AnalyticsModel? analytics;
  final String? status;
  List<dynamic>? services = [];
  final String? nationalId;
  final File? nationalIdFile;
  final String? permit;
  final File? permitFile;
  //FIREBASE CLASS FOR LONGITUDE AND LATITUDE
  final GeoPoint? location;
  final String? id;

  MechanicModel({
    this.name,
    this.profile,
    this.phone,
    this.description,
    this.openingTime,
    this.fileImages,
    this.profileFile,
    this.closingTime,
    this.analytics,
    this.address,
    this.location,
    this.status,
    this.id,
    this.images,
    this.services,
    this.nationalId,
    this.permit,
    this.nationalIdFile,
    this.permitFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profile': profile,
      'phone': phone,
      'description': description,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'address': address,
      'location': location,
      'nationalId': nationalId,
      'permit': permit,
      'id': id,
      'images': images,
      'status': 'pending',
      'services':
          services == null ? [] : services!.map((e) => e.toJson()).toList(),
    };
  }

  factory MechanicModel.fromJson(dynamic json) {
    return MechanicModel(
      address: json['address'],
      name: json['name'],
      phone: json['phone'],
      description: json['description'],
      profile: json['profile'],
      openingTime: json['openingTime'],
      location: json['location'],
      id: json['id'],
      closingTime: json['closingTime'],
      services: json['services'],
      images: json['images'],
      status: json['status'],
      nationalId: json['nationalId'],
      permit: json['permit'],
    );
  }
}
