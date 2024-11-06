import 'package:uuid/uuid.dart';

import 'dart:convert';

class FundsModel {
  bool success;
  int statusCode;
  String message;
  List<FundModel> fund;

  FundsModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.fund,
  });

  FundsModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    List<FundModel>? fund,
  }) =>
      FundsModel(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        fund: fund ?? this.fund,
      );

  factory FundsModel.fromJson(Map<String, dynamic> json) => FundsModel(
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
        fund: List<FundModel>.from(
            json["fund_list"].map((x) => FundModel.fromMap(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "fund_list": List<dynamic>.from(fund.map((x) => x.toMap())),
      };
}

class FundModel {
  final String fundId;
  final String fundName;
  final String? description;
  final double? targetAmount;
  final DateTime startDate;
  final DateTime? endDate;
  final double totalContributions;
  final DateTime createdAt;
  final DateTime updatedAt;

  FundModel({
    String? fundId,
    required this.fundName,
    this.description,
    this.targetAmount,
    required this.startDate,
    this.endDate,
    this.totalContributions = 0.0,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : fundId = fundId ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Method to create a Fund object from a Map (e.g., from database)
  factory FundModel.fromMap(Map<String, dynamic> map) {
    return FundModel(
      fundId: map['fund_id'],
      fundName: map['fund_name'],
      description: map['description'],
      targetAmount: map['target_amount'],
      startDate: DateTime.parse(map['start_date']),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      totalContributions: map['total_contributions'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  // Method to convert a Fund object to a Map (e.g., for database)
  Map<String, dynamic> toMap() {
    return {
      'fund_id': fundId,
      'fund_name': fundName,
      'description': description,
      'target_amount': targetAmount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'total_contributions': totalContributions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Method to create a copy of the Fund object
  FundModel copyWith({
    String? fundId,
    String? fundName,
    String? description,
    double? targetAmount,
    DateTime? startDate,
    DateTime? endDate,
    double? totalContributions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FundModel(
      fundId: fundId ?? this.fundId,
      fundName: fundName ?? this.fundName,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalContributions: totalContributions ?? this.totalContributions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
