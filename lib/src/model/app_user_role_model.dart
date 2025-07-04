class AppUserRole {
  final int? id;
  final String name;
  final String description;
  final String status;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppUserRole({
    this.id,
    required this.name,
    required this.description,
    this.status = 'active',
    this.isPrimary = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert from JSON (Supabase response)
  factory AppUserRole.fromJson(Map<String, dynamic> json) {
    return AppUserRole(
      id: json['app_users_role_id'],
      name: json['app_users_role_name'],
      description: json['app_users_role_description'],
      status: json['app_users_role_status'],
      isPrimary: json['is_primary'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Convert to JSON (For inserting/updating in Supabase)
  Map<String, dynamic> toJson() {
    return {
      'app_users_role_id': id,
      'app_users_role_name': name,
      'app_users_role_description': description,
      'app_users_role_status': status,
      'is_primary': isPrimary,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // CopyWith method for immutability
  AppUserRole copyWith({
    int? id,
    String? name,
    String? description,
    String? status,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUserRole(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
