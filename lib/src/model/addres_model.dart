class AddressModel {
  final String? id;
  final String? profileId;
  final String? streetAddress;
  final String? stateProvince;
  final String? country;
  final String? cityState;
  final DateTime? createdAt;

  AddressModel({
    this.id,
    this.profileId,
    this.streetAddress,
    this.stateProvince,
    this.country,
    this.cityState,
    this.createdAt,
  });


  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      profileId: json['profile_id'],
      streetAddress: json['streetAddress'],
      stateProvince: json['stateProvince'],
      country: json['country'],
      cityState: json['cityState'],
      createdAt: json['createAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'streetAddress': streetAddress,
      'stateProvince': stateProvince,
      'country': country,
      'cityState': cityState,
      'createdAt': createdAt?.toIso8601String(),
    };
  }


  
  AddressModel copyWith({
    String? id,
    String? profileId,
    String? streetAddress,
    String? stateProvince,
    String? country,
    String? cityState,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      streetAddress: streetAddress ?? this.streetAddress,
      stateProvince: stateProvince ?? this.stateProvince,
      country: country ?? this.country,
      cityState: cityState ?? this.cityState,
      createdAt: createdAt ?? this.createdAt,
    );
  }


  @override
  String toString() {
    return 'AddressModel(id: $id, profileId: $profileId, streetAddress: $streetAddress, '
        'stateProvince: $stateProvince, country: $country, cityState: $cityState, '
        'createdAt: $createdAt)';
  }
}
