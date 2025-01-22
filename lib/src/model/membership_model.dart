// To parse this JSON data, do
//
//     final membershipModel = membershipModelFromJson(jsonString);

import 'dart:convert';

MembershipModel membershipModelFromJson(String str) =>
    MembershipModel.fromJson(json.decode(str));

String membershipModelToJson(MembershipModel data) =>
    json.encode(data.toJson());

class MembershipModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<Membership>? membership;

  MembershipModel({
    this.success,
    this.statusCode,
    this.message,
    this.membership,
  });

  MembershipModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    List<Membership>? membership,
  }) =>
      MembershipModel(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        membership: membership ?? this.membership,
      );

  factory MembershipModel.fromJson(Map<String, dynamic> json) =>
      MembershipModel(
         success: json['success'] ?? false,
        statusCode: json['status_code'] ?? 500,
        message: json['message'] ?? 'Error',
        membership: json["membership"] == null && json["membership"] == []
            ? []
            : List<Membership>.from(
                json["membership"]!.map((x) => Membership.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "membership": membership == null
            ? []
            : List<dynamic>.from(membership!.map((x) => x.toJson())),
      };
}

class Membership {
  final String? profileId;
  final DateTime? baptismDate;
  final String? baptismChurch;
  final String? baptismPastor;
  final String? membershipRole;
  final String? baptismChurchCity;
  final String? baptismChurchCountry;
  final List<MembershipHistory>? membershipHistory; 

  Membership({
    this.profileId,
    this.baptismDate,
    this.baptismChurch,
    this.baptismPastor,
    this.membershipRole,
    this.baptismChurchCity,
    this.baptismChurchCountry,
    this.membershipHistory ,
  });

  Membership copyWith({
    String? profileId,
    DateTime? baptismDate,
    String? baptismChurch,
    String? baptismPastor,
    String? membershipRole,
    String? baptismChurchCity,
    String? baptismChurchCountry,
    List<MembershipHistory>? membershipHistory,
  }) =>
      Membership(
        profileId: profileId ?? this.profileId,
        baptismDate: baptismDate ?? this.baptismDate,
        baptismChurch: baptismChurch ?? this.baptismChurch,
        baptismPastor: baptismPastor ?? this.baptismPastor,
        membershipRole: membershipRole ?? this.membershipRole,
        baptismChurchCity: baptismChurchCity ?? this.baptismChurchCity,
        baptismChurchCountry: baptismChurchCountry ?? this.baptismChurchCountry,
        membershipHistory: membershipHistory ?? this.membershipHistory,
      );

  factory Membership.fromJson(Map<String, dynamic> json) => Membership(
        profileId: json["profileId"],
        baptismDate: json["baptismDate"] == null
            ? null
            : DateTime.parse(json["baptismDate"]),
        baptismChurch: json["baptismChurch"],
        baptismPastor: json["baptismPastor"],
        membershipRole: json["membershipRole"],
        baptismChurchCity: json["baptismChurchCity"],
        baptismChurchCountry: json["baptismChurchCountry"],
        membershipHistory: json["membershipHistory"] == null
            ? []
            : List<MembershipHistory>.from(
                json["membershipHistory"]!.map((x) => MembershipHistory.fromJson(x))),

      );

  Map<String, dynamic> toJson() => {
        "profileId": profileId,
        "baptismDate":
            "${baptismDate!.year.toString().padLeft(4, '0')}-${baptismDate!.month.toString().padLeft(2, '0')}-${baptismDate!.day.toString().padLeft(2, '0')}",
        "baptismChurch": baptismChurch,
        "baptismPastor": baptismPastor,
        "membershipRole": membershipRole,
        "baptismChurchCity": baptismChurchCity,
        "baptismChurchCountry": baptismChurchCountry,
        "membershipHistory": membershipHistory == null
            ? []
            : List<dynamic>.from(membershipHistory!.map((x) => x.toJson())),
      };
}

class MembershipHistory {
  final DateTime? dateStart;
  final DateTime? dateReturned;
  final String? observations;

  MembershipHistory({
    this.dateStart,
    this.dateReturned,
    this.observations,
  });

  MembershipHistory copyWith({
    DateTime? dateStart,
    DateTime? dateReturned,
    String? observations,
  }) =>
      MembershipHistory(
        dateStart: dateStart ?? this.dateStart,
        dateReturned: dateReturned ?? this.dateReturned,
        observations: observations ?? this.observations,
      );

  factory MembershipHistory.fromJson(Map<String, dynamic> json) =>
      MembershipHistory(
        dateStart: json["dateStart"] == null
            ? null
            : DateTime.parse(json["dateStart"]),
        dateReturned: json["dateReturned"] == null
            ? null
            : DateTime.parse(json["dateReturned"]),


        observations: json["observations"],
      );

  Map<String, dynamic> toJson() => {
        "dateStart": dateStart,
        "dateReturned": dateReturned,
        "observations": observations,
      };
}
