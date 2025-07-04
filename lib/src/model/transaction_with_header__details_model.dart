// To parse this JSON data, do
//
//     final TransactionWithHeaderDetailsModel = TransactionWithHeaderDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:evochurch/src/model/transaction_model.dart';

TransactionWithHeaderDetailsModel transactionWithHeaderDetailsModelFromJson(String str) =>
    TransactionWithHeaderDetailsModel.fromJson(json.decode(str));

String tansactionWithHeaderDetailsModelToJson(TransactionWithHeaderDetailsModel data) =>
    json.encode(data.toJson());

class TransactionWithHeaderDetailsModel {
  bool success;
  int statusCode;
  String message;
  HeaderDetails headerDetails;
  List<TransactionModel> transactionModel;

  TransactionWithHeaderDetailsModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.headerDetails,
    required this.transactionModel,
  });

  TransactionWithHeaderDetailsModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    HeaderDetails? headerDetails,
    List<TransactionModel>? transactionModel,
  }) =>
      TransactionWithHeaderDetailsModel(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        headerDetails: headerDetails ?? this.headerDetails,
        transactionModel: transactionModel ?? this.transactionModel,
      );

  factory TransactionWithHeaderDetailsModel.fromJson(Map<String, dynamic> json) =>
      TransactionWithHeaderDetailsModel(
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
        headerDetails: HeaderDetails.fromJson(json["header_details"]),
        transactionModel: List<TransactionModel>.from(
            json["transaction_list"].map((x) => TransactionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "header_details": headerDetails.toJson(),
        "transaction_list":
            List<dynamic>.from(transactionModel.map((x) => x.toJson())),
      };
}

class HeaderDetails {
  int churchId;
  int totalTransactions;
  int targetAmount;
  int totalContributions;
  int pendingTransactions;
  int approvedTransactions;
  int totalMinusPendingTransactions;

  HeaderDetails({
    required this.churchId,
    required this.totalTransactions,
    required this.targetAmount,
    required this.totalContributions,
    required this.pendingTransactions,
    required this.approvedTransactions,
    required this.totalMinusPendingTransactions,
  });

  HeaderDetails copyWith({
    int? churchId,
    String? fundId,
    String? fundName,
    int? totalTransactions,
    int? targetAmount,
    int? totalContributions,
    int? pendingTransactions,
    int? approvedTransactions,
    int? totalMinusPendingTransactions,
  }) =>
      HeaderDetails(
        churchId: churchId ?? this.churchId,
        totalTransactions: totalTransactions ?? this.totalTransactions,
        targetAmount: targetAmount ?? this.targetAmount,
        totalContributions: totalContributions ?? this.totalContributions,
        pendingTransactions: pendingTransactions ?? this.pendingTransactions,
        approvedTransactions: approvedTransactions ?? this.approvedTransactions,
        totalMinusPendingTransactions:
            totalMinusPendingTransactions ?? this.totalMinusPendingTransactions,
      );

  factory HeaderDetails.fromJson(Map<String, dynamic> json) => HeaderDetails(
        churchId: json["church_id"],
        totalTransactions: json["total_transactions"],
        targetAmount: json["target_amount"],
        totalContributions: json["total_contributions"],
        pendingTransactions: json["pending_transactions"],
        approvedTransactions: json["approved_transactions"],
        totalMinusPendingTransactions: json["total_minus_pending_transactions"],
      );

  Map<String, dynamic> toJson() => {
        "church_id": churchId,
        "total_transactions": totalTransactions,
        "target_amount": targetAmount,
        "total_contributions": totalContributions,
        "pending_transactions": pendingTransactions,
        "approved_transactions": approvedTransactions,
        "total_minus_pending_transactions": totalMinusPendingTransactions,
      };
}
