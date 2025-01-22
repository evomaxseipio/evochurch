


class ExpensesTypeResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<ExpensesTypeModel> expenseTypes;

  ExpensesTypeResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.expenseTypes,
  });

  factory ExpensesTypeResponse.fromJson(Map<String, dynamic> json) =>
      ExpensesTypeResponse(
        success: json["success"],
        statusCode: json["status_code"],
        message: json["message"],
        expenseTypes: List<ExpensesTypeModel>.from(
            json["expense_types"].map((x) => ExpensesTypeModel.fromMap(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "expense_types": List<dynamic>.from(expenseTypes.map((x) => x.toMap())),
      };
}

class ExpensesTypeModel {
  final int? expensesTypeId;
  final int churchId;
  final String expensesName;
  final String expensesCategory;
  final String? expensesDescription;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExpensesTypeModel({
    this.expensesTypeId,
    required this.churchId,
    required this.expensesName,
    required this.expensesCategory,
    this.expensesDescription,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Factory method to create an object from a Map (e.g., from database)
  factory ExpensesTypeModel.fromMap(Map<String, dynamic> map) {
    return ExpensesTypeModel(
      expensesTypeId: map['expenses_type_id'],
      churchId: map['church_id'],
      expensesName: map['expenses_name'],
      expensesCategory: map['expenses_category'],
      expensesDescription: map['expenses_description'],
      isActive: map['is_active'] ?? true,
      createdAt: map['created_at'] is String
          ? DateTime.parse(map['created_at'])
          : map['created_at'] ?? DateTime.now(),
      updatedAt: map['updated_at'] is String
          ? DateTime.parse(map['updated_at'])
          : map['updated_at'] ?? DateTime.now(),
    );
  }

  // Method to convert an object to a Map (e.g., for database)
  Map<String, dynamic> toMap() {
    return {
      'expenses_type_id': expensesTypeId,
      'church_id': churchId,
      'expenses_name': expensesName,
      'expenses_category': expensesCategory,
      'expenses_description': expensesDescription,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Method to create a copy of the object
  ExpensesTypeModel copyWith({
    int? expensesTypeId,
    int? churchId,
    String? expensesName,
    String? expensesCategory,
    String? expensesDescription,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpensesTypeModel(
      expensesTypeId: expensesTypeId ?? this.expensesTypeId,
      churchId: churchId ?? this.churchId,
      expensesName: expensesName ?? this.expensesName,
      expensesCategory: expensesCategory ?? this.expensesCategory,
      expensesDescription: expensesDescription ?? this.expensesDescription,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Optional: JSON serialization methods
  factory ExpensesTypeModel.fromJson(Map<String, dynamic> json) =>
      ExpensesTypeModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

