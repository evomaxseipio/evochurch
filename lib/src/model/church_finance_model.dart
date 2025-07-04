// To parse this JSON data, do
//
//     final churchFinanceData = churchFinanceDataFromJson(jsonString);

import 'dart:convert';

ChurchFinanceData churchFinanceDataFromJson(String str) =>
    ChurchFinanceData.fromJson(json.decode(str));

String churchFinanceDataToJson(ChurchFinanceData data) =>
    json.encode(data.toJson());

class ChurchFinanceData {
  bool success;
  int statusCode;
  String message;
  ChurchCollectionHeaderDetails churchCollectionHeaderDetails;
  List<ChurchCollectionChartData> churchCollectionChartData;
  List<ChurchCollectionList> churchCollectionList;

  ChurchFinanceData({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.churchCollectionHeaderDetails,
    required this.churchCollectionChartData,
    required this.churchCollectionList,
  });

  ChurchFinanceData copyWith({
    bool? success,
    int? statusCode,
    String? message,
    ChurchCollectionHeaderDetails? collectionHeaderDetails,
    List<ChurchCollectionChartData>? collectionChartData,
    List<ChurchCollectionList>? collectionList,
  }) =>
      ChurchFinanceData(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        churchCollectionHeaderDetails:
            collectionHeaderDetails ?? this.churchCollectionHeaderDetails,
        churchCollectionChartData:
            collectionChartData ?? this.churchCollectionChartData,
        churchCollectionList: collectionList ?? this.churchCollectionList,
      );

  factory ChurchFinanceData.fromJson(Map<String, dynamic> json) =>
      ChurchFinanceData(
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
        churchCollectionHeaderDetails: ChurchCollectionHeaderDetails.fromJson(
            json["collection_header_details"]),
        churchCollectionChartData: List<ChurchCollectionChartData>.from(
            json["collection_chart_data"]
                .map((x) => ChurchCollectionChartData.fromJson(x))),
        churchCollectionList: List<ChurchCollectionList>.from(
            json["collection_list"]
                .map((x) => ChurchCollectionList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "collection_header_details": churchCollectionHeaderDetails.toJson(),
        "collection_chart_data": List<dynamic>.from(
            churchCollectionChartData.map((x) => x.toJson())),
        "collection_list":
            List<dynamic>.from(churchCollectionList.map((x) => x.toJson())),
      };
}

class ChurchCollectionChartData {
  String month;
  int tithes;
  int offering;
  int donation;

  ChurchCollectionChartData({
    required this.month,
    required this.tithes,
    required this.offering,
    required this.donation,
  });

  ChurchCollectionChartData copyWith({
    String? month,
    int? tithes,
    int? offering,
    int? donation,
  }) =>
      ChurchCollectionChartData(
        month: month ?? this.month,
        tithes: tithes ?? this.tithes,
        offering: offering ?? this.offering,
        donation: donation ?? this.donation,
      );

  factory ChurchCollectionChartData.fromJson(Map<String, dynamic> json) =>
      ChurchCollectionChartData(
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

class ChurchCollectionHeaderDetails {
  int churchId;
  int offeringAmount;
  int donationAmount;
  int tithesAmount;
  int totalContributions;

  ChurchCollectionHeaderDetails({
    required this.churchId,
    required this.offeringAmount,
    required this.donationAmount,
    required this.tithesAmount,
    required this.totalContributions,
  });

  ChurchCollectionHeaderDetails copyWith({
    int? churchId,
    int? offeringAmount,
    int? donationAmount,
    int? tithesAmount,
    int? totalContributions,
  }) =>
      ChurchCollectionHeaderDetails(
        churchId: churchId ?? this.churchId,
        offeringAmount: offeringAmount ?? this.offeringAmount,
        donationAmount: donationAmount ?? this.donationAmount,
        tithesAmount: tithesAmount ?? this.tithesAmount,
        totalContributions: totalContributions ?? this.totalContributions,
      );

  factory ChurchCollectionHeaderDetails.fromJson(Map<String, dynamic> json) =>
      ChurchCollectionHeaderDetails(
        churchId: json["church_id"],
        offeringAmount: json["offering_amount"],
        donationAmount: json["donation_amount"],
        tithesAmount: json["tithes_amount"],
        totalContributions: json["total_contributions"],
      );

  Map<String, dynamic> toJson() => {
        "church_id": churchId,
        "offering_amount": offeringAmount,
        "donation_amount": donationAmount,
        "tithes_amount": tithesAmount,
        "total_contributions": totalContributions,
      };
}

class ChurchCollectionList {
  int churchId;
  String profileId;
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

  ChurchCollectionList({
    required this.churchId,
    required this.profileId,
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

  ChurchCollectionList copyWith({
    int? churchId,
    String? profileId,
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
      ChurchCollectionList(
        churchId: churchId ?? this.churchId,
        profileId: profileId ?? this.profileId,
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

  factory ChurchCollectionList.fromJson(Map<String, dynamic> json) =>
      ChurchCollectionList(
        churchId: json["church_id"],
        profileId: json["profile_id"],
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
        "profile_id": profileId,
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
