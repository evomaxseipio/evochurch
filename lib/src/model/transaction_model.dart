import 'dart:convert';

TransactionListModel transactionListModelFromJson(String str) =>
    TransactionListModel.fromJson(json.decode(str));

String transactionListModelToJson(TransactionListModel data) =>
    json.encode(data.toJson());

class TransactionListModel {
  bool success;
  int statusCode;
  String message;
  List<TransactionModel> transactionListModel;

  TransactionListModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.transactionListModel,
  });

  TransactionListModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    List<TransactionModel>? transactionListModel,
  }) =>
      TransactionListModel(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        transactionListModel: transactionListModel ?? this.transactionListModel,
      );

  factory TransactionListModel.fromJson(Map<String, dynamic> json) =>
      TransactionListModel(
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
        transactionListModel: List<TransactionModel>.from(
            json["transaction_list"].map((x) => TransactionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "transaction_list":
            List<dynamic>.from(transactionListModel.map((x) => x.toJson())),
      };
}

class TransactionModel {
  int churchId;
  int transactionId;
  DateTime transactionDate;
  int transactionAmount;
  String transactionDescription;
  String transactionStatus;
  int expensesTypeId;
  String profileId;
  String createdBy;
  String? authorizedProfileId;
  String? authorizedBy;
  String? authorizedComments;
  DateTime? authorizationDate;
  String fundId;
  String fundName;
  String paymentMethod;

  TransactionModel({
    required this.churchId,
    required this.transactionId,
    required this.transactionDate,
    required this.transactionAmount,
    required this.transactionDescription,
    required this.transactionStatus,
    required this.expensesTypeId,
    required this.profileId,
    required this.createdBy,
    this.authorizedProfileId,
    this.authorizedBy,
    this.authorizedComments,
    this.authorizationDate,
    required this.fundId,
    required this.fundName,
    required this.paymentMethod,
  });

  TransactionModel copyWith({
    int? churchId,
    int? transactionId,
    DateTime? transactionDate,
    int? transactionAmount,
    String? transactionDescription,
    String? transactionStatus,
    int? expensesTypeId,
    String? profileId,
    String? createdBy,
    String? authorizedProfileId,
    String? authorizedBy,
    String? authorizedComments,
    DateTime? authorizationDate,
    String? fundId,
    String? fundName,
    String? paymentMethod,
  }) =>
      TransactionModel(
        churchId: churchId ?? this.churchId,
        transactionId: transactionId ?? this.transactionId,
        transactionDate: transactionDate ?? this.transactionDate,
        transactionAmount: transactionAmount ?? this.transactionAmount,
        transactionDescription:transactionDescription ?? this.transactionDescription,
        transactionStatus: transactionStatus ?? this.transactionStatus,
        expensesTypeId: expensesTypeId ?? this.expensesTypeId,
        profileId: profileId ?? this.profileId,
        createdBy: createdBy ?? this.createdBy,
        authorizedProfileId: authorizedProfileId ?? this.authorizedProfileId,
        authorizedBy: authorizedBy ?? this.authorizedBy,
        authorizedComments: authorizedComments ?? this.authorizedComments,
        authorizationDate: authorizationDate ?? this.authorizationDate,
        fundId: fundId ?? this.fundId,
        fundName: fundName ?? this.fundName,
        paymentMethod: paymentMethod ?? this.paymentMethod,
      );

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        churchId: json["churchId"],
        transactionId: json["transactionId"],
        transactionDate: DateTime.parse(json["transactionDate"]),
        transactionAmount: json["transactionAmount"],
        transactionDescription: json["transactionDescription"],
        transactionStatus: json["transactionStatus"],
        expensesTypeId: json["expensesTypeId"],
        profileId: json["profileId"],
        createdBy: json["createdBy"],
        authorizedProfileId: json["authorizedProfileId"],
        authorizedBy: json["authorizedBy"],
        authorizedComments: json["authorizedComments"] ?? 'null',
        // Safe parsing for nullable DateTime
        authorizationDate: json["authorizationDate"] != null
            ? DateTime.parse(json["authorizationDate"])
            : DateTime.now(),
        fundId: json["fundId"],
        fundName: json["fundName"],
        paymentMethod: json["paymentMethod"],
      );

  Map<String, dynamic> toJson() => {
        "churchId": churchId,
        "transactionId": transactionId,
        "transactionDate":
            "${transactionDate.year.toString().padLeft(4, '0')}-${transactionDate.month.toString().padLeft(2, '0')}-${transactionDate.day.toString().padLeft(2, '0')}",
        "transactionAmount": transactionAmount,
        "transactionDescription": transactionDescription,
        "transactionStatus": transactionStatus,
        "expensesTypeId": expensesTypeId,
        "profileId": profileId,
        "createdBy": createdBy,
        "authorizedProfileId": authorizedProfileId,
        "authorizedBy": authorizedBy,
        "authorizedComments": authorizedComments,
        // Safe conversion for nullable DateTime
        "authorizationDate": authorizationDate?.toIso8601String(),
        "fundId": fundId,
        "fundName": fundName,
        "paymentMethod": paymentMethod,
      };
}
