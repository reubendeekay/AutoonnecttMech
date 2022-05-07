import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mechanic_admin/models/mechanic_model.dart';
import 'package:mechanic_admin/models/service_model.dart';
import 'package:mechanic_admin/models/user_model.dart';

class RequestModel {
  final String? problem;
  final String? id;
  final DateTime? date;
  final String? vehicleModel;
  final List<File> imageFiles = [];
  List<dynamic>? images = [];
  List<ServiceModel>? services = [];
  final MechanicModel? mechanic;
  final UserModel? user;
  final String? amount;
  final GeoPoint? userLocation;
  final Timestamp? createdAt;
  final String? status;

  RequestModel(
      {this.problem,
      this.date,
      this.id,
      this.vehicleModel,
      this.status,
      this.createdAt,
      this.mechanic,
      this.user,
      this.userLocation,
      this.services,
      this.amount,
      this.images});

  Map<String, dynamic> toJson() {
    return {
      'problem': problem,
      'date': date,
      'vehicleModel': vehicleModel,
      'amount': amount,
      'location': userLocation,
      'status': status,
      'mechanic': {
        'id': mechanic?.id,
        'name': mechanic?.name,
        'profile': mechanic?.profile,
        'phone': mechanic?.phone,
        'address': mechanic?.address,
        'location': mechanic?.location,
      },
      'user': user?.toJson(),
      'services': services?.map((service) => service.toJson()).toList(),
      'images': images,
    };
  }

  factory RequestModel.fromJson(dynamic json) {
    return RequestModel(
      id: json.id,
      problem: json['problem'],
      date: json['date'].toDate(),
      vehicleModel: json['vehicleModel'],
      amount: json['amount'],
      mechanic: json['mechanic'] != null
          ? MechanicModel.fromJson(json['mechanic'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      services: json['services'] == null
          ? []
          : (json['services'] as List<dynamic>)
              .map((service) => ServiceModel.fromJson(service))
              .toList(),
      images: json['images'],
      createdAt: json['createdAt'],
      status: json['status'],
      userLocation: json['location'],
    );
  }
}
