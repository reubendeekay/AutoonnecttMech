class AnalyticsModel {
  final double? balance;
  final double? totalEarnings;
  final int? requests;
  final double? rating;
  final int? completedRequests;
  final int? pendingRequests;
  final int? ratingCount;

  AnalyticsModel(
      {this.balance,
      this.totalEarnings,
      this.requests,
      this.rating,
      this.completedRequests,
      this.pendingRequests,
      this.ratingCount});

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'totalEarnings': totalEarnings,
      'requests': requests,
      'rating': rating,
      'completedRequests': completedRequests,
      'pendingRequests': pendingRequests,
      'ratingCount': ratingCount,
    };
  }

  factory AnalyticsModel.fromJson(dynamic json) {
    return AnalyticsModel(
      balance: double.parse(json['balance'].toString()),
      totalEarnings: double.parse(json['totalEarnings'].toString()),
      rating: double.parse(json['rating'].toString()),
      requests: json['requests'],
      completedRequests: json['completedRequests'],
      pendingRequests: json['pendingRequests'],
      ratingCount: json['ratingCount'],
    );
  }
}
