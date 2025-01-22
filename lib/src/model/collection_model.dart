import 'package:evochurch/src/model/collection_model_type.dart';

class CollectionModel {
  final String? collectionId;
  final String? fundId; // Make fundId nullable
  final String? profileId;
  final int? collectionType; // Use CollectionType object
  final double collectionAmount;
  final DateTime collectionDate; // Use DateTime for date
  final bool isAnonymous;
  final String? paymentMethod;
  final String? comments; // Make comments nullable

  CollectionModel({
    this.collectionId,
    this.fundId,
    this.profileId,
    this.collectionType,
    required this.collectionAmount,
    required this.collectionDate,
    required this.isAnonymous,
    this.paymentMethod,
    this.comments,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      collectionId: json['collection_id'],
      fundId: json['fund_id'],
      profileId: json['profile_id'],
      collectionType: json['collection_type'], // Parse collectionType
      collectionAmount: json['collection_amount'].toDouble(),
      collectionDate: DateTime.parse(json['collection_date']), // Parse date string
      isAnonymous: json['is_anonymous'],
      paymentMethod: json['payment_method'],
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collection_id': collectionId,
      'fund_id': fundId,
      'profile_id': profileId,
      'collection_type': collectionType,
      'collection_amount': collectionAmount,
      'collection_date':
          collectionDate.toIso8601String(), // Format date as ISO8601 string
      'is_anonymous': isAnonymous,
      'payment_method': paymentMethod,
      'comments': comments,
    };
  }

  CollectionModel copyWith({
    String? collectionId,
    String? fundId,
    String? profileId,
    int? collectionType,
    double? collectionAmount,
    DateTime? collectionDate,
    bool? isAnonymous,
    String? paymentMethod,
    String? comments,
  }) {
    return CollectionModel(
      collectionId: collectionId ?? this.collectionId,
      fundId: fundId ?? this.fundId,
      profileId: profileId ?? this.profileId,
      collectionType: collectionType ?? this.collectionType,
      collectionAmount: collectionAmount ?? this.collectionAmount,
      collectionDate: collectionDate ?? this.collectionDate,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      comments: comments ?? this.comments,
    );
  }
}
