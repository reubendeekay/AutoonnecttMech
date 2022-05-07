import 'dart:io';

class ServiceModel {
  final String? id;
  final String? serviceName;
  final File? imageFile;
  final String? imageUrl;
  final String? price;

  ServiceModel(
      {this.id, this.serviceName, this.imageFile, this.imageUrl, this.price});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      serviceName: json['serviceName'],
      imageUrl: json['imageUrl'],
      price: json['price'],
    );
  }
}
