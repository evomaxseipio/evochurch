// To parse this JSON data, do
//
//     final memberFinanceData = memberFinanceDataFromJson(jsonString);

import 'dart:convert';

MemberFinanceData memberFinanceDataFromJson(String str) =>
    MemberFinanceData.fromJson(json.decode(str));

String memberFinanceDataToJson(MemberFinanceData data) =>
    json.encode(data.toJson());

class MemberFinanceData {
  bool success;
  int statusCode;
  String message;
  CollectionHeaderDetails collectionHeaderDetails;
  List<CollectionChartData> collectionChartData;
  List<CollectionList> collectionList;

  MemberFinanceData({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.collectionHeaderDetails,
    required this.collectionChartData,
    required this.collectionList,
  });

  MemberFinanceData copyWith({
    bool? success,
    int? statusCode,
    String? message,
    CollectionHeaderDetails? collectionHeaderDetails,
    List<CollectionChartData>? collectionChartData,
    List<CollectionList>? collectionList,
  }) =>
      MemberFinanceData(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        collectionHeaderDetails:
            collectionHeaderDetails ?? this.collectionHeaderDetails,
        collectionChartData: collectionChartData ?? this.collectionChartData,
        collectionList: collectionList ?? this.collectionList,
      );

  factory MemberFinanceData.fromJson(Map<String, dynamic> json) =>
      MemberFinanceData(
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
        collectionHeaderDetails:
            CollectionHeaderDetails.fromJson(json["collection_header_details"]),
        collectionChartData: List<CollectionChartData>.from(
            json["collection_chart_data"]
                .map((x) => CollectionChartData.fromJson(x))),
        collectionList: List<CollectionList>.from(
            json["collection_list"].map((x) => CollectionList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "collection_header_details": collectionHeaderDetails.toJson(),
        "collection_chart_data":
            List<dynamic>.from(collectionChartData.map((x) => x.toJson())),
        "collection_list":
            List<dynamic>.from(collectionList.map((x) => x.toJson())),
      };
}

class CollectionChartData {
  String month;
  int tithes;
  int offering;
  int donation;

  CollectionChartData({
    required this.month,
    required this.tithes,
    required this.offering,
    required this.donation,
  });

  CollectionChartData copyWith({
    String? month,
    int? tithes,
    int? offering,
    int? donation,
  }) =>
      CollectionChartData(
        month: month ?? this.month,
        tithes: tithes ?? this.tithes,
        offering: offering ?? this.offering,
        donation: donation ?? this.donation,
      );

  factory CollectionChartData.fromJson(Map<String, dynamic> json) =>
      CollectionChartData(
        month: json["month"],
        tithes: json["tithes"],
        offering: json["offering"],
        donation: json["donation"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "tithes": tithes,
        "offering": offering,
        "donation": donation,
      };
}

class CollectionHeaderDetails {
  int churchId;
  String profileId;
  int offeringAmount;
  int donationAmount;
  int tithesAmount;
  int totalContributions;

  CollectionHeaderDetails({
    required this.churchId,
    required this.profileId,
    required this.offeringAmount,
    required this.donationAmount,
    required this.tithesAmount,
    required this.totalContributions,
  });

  CollectionHeaderDetails copyWith({
    int? churchId,
    String? profileId,
    int? offeringAmount,
    int? donationAmount,
    int? tithesAmount,
    int? totalContributions,
  }) =>
      CollectionHeaderDetails(
        churchId: churchId ?? this.churchId,
        profileId: profileId ?? this.profileId,
        offeringAmount: offeringAmount ?? this.offeringAmount,
        donationAmount: donationAmount ?? this.donationAmount,
        tithesAmount: tithesAmount ?? this.tithesAmount,
        totalContributions: totalContributions ?? this.totalContributions,
      );

  factory CollectionHeaderDetails.fromJson(Map<String, dynamic> json) =>
      CollectionHeaderDetails(
        churchId: json["church_id"],
        profileId: json["profile_id"],
        offeringAmount: json["offering_amount"],
        donationAmount: json["donation_amount"],
        tithesAmount: json["tithes_amount"],
        totalContributions: json["total_contributions"],
      );

  Map<String, dynamic> toJson() => {
        "church_id": churchId,
        "profile_id": profileId,
        "offering_amount": offeringAmount,
        "donation_amount": donationAmount,
        "tithes_amount": tithesAmount,
        "total_contributions": totalContributions,
      };
}

class CollectionList {
  int churchId;
  String collectionId;
  int collectionType;
  String collectionTypeName;
  DateTime collectionDate;
  int collectionAmount;
  bool isAnonymous;
  String paymentMethod;
  String comments;
  bool isActive;
  String fundId;

  CollectionList({
    required this.churchId,
    required this.collectionId,
    required this.collectionType,
    required this.collectionTypeName,
    required this.collectionDate,
    required this.collectionAmount,
    required this.isAnonymous,
    required this.paymentMethod,
    required this.comments,
    required this.isActive,
    required this.fundId,
  });

  CollectionList copyWith({
    int? churchId,
    String? collectionId,
    int? collectionType,
    String? collectionTypeName,
    DateTime? collectionDate,
    int? collectionAmount,
    bool? isAnonymous,
    String? paymentMethod,
    String? comments,
    bool? isActive,
    String? fundId,
  }) =>
      CollectionList(
        churchId: churchId ?? this.churchId,
        collectionId: collectionId ?? this.collectionId,
        collectionType: collectionType ?? this.collectionType,
        collectionTypeName: collectionTypeName ?? this.collectionTypeName,
        collectionDate: collectionDate ?? this.collectionDate,
        collectionAmount: collectionAmount ?? this.collectionAmount,
        isAnonymous: isAnonymous ?? this.isAnonymous,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        comments: comments ?? this.comments,
        isActive: isActive ?? this.isActive,
        fundId: fundId ?? this.fundId,
      );

  factory CollectionList.fromJson(Map<String, dynamic> json) => CollectionList(
        churchId: json["church_id"],
        collectionId: json["collection_id"],
        collectionType: json["collection_type"],
        collectionTypeName: json["collection_type_name"],
        collectionDate: DateTime.parse(json["collection_date"]),
        collectionAmount: json["collection_amount"],
        isAnonymous: json["is_anonymous"],
        paymentMethod: json["payment_method"],
        comments: json["comments"],
        isActive: json["is_active"],
        fundId: json["fund_id"],
      );

  Map<String, dynamic> toJson() => {
        "church_id": churchId,
        "collection_id": collectionId,
        "collection_type": collectionType,
        "collection_type_name": collectionTypeName,
        "collection_date":
            "${collectionDate.year.toString().padLeft(4, '0')}-${collectionDate.month.toString().padLeft(2, '0')}-${collectionDate.day.toString().padLeft(2, '0')}",
        "collection_amount": collectionAmount,
        "is_anonymous": isAnonymous,
        "payment_method": paymentMethod,
        "comments": comments,
        "is_active": isActive,
        "fund_id": fundId,
      };
}
