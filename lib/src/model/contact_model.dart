class ContactModel {
  final String? id;
  final String? profileId;
  final String? phone;
  final String? mobilePhone;
  final String? email;

  ContactModel({
    this.id,
    this.profileId,
    this.phone,
    this.mobilePhone,
    this.email,
  });

  ContactModel copyWith({
    String? id,
    String? profileId,
    String? phone,
    String? mobilePhone,
    String? email,
  }) {
    return ContactModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      phone: phone ?? this.phone,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      email: email ?? this.email,
    );
  }

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String?,
      profileId: json['profile_id'] as String?,
      phone: json['phone'] as String?,
      mobilePhone: json['mobilePhone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'phone': phone,
      'mobilePhone': mobilePhone,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'ContactModel(id: $id, profileId: $profileId, phone: $phone, '
        'mobilePhone: $mobilePhone, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactModel &&
        other.id == id &&
        other.profileId == profileId &&
        other.phone == phone &&
        other.mobilePhone == mobilePhone &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        profileId.hashCode ^
        phone.hashCode ^
        mobilePhone.hashCode ^
        email.hashCode;
  }
}
