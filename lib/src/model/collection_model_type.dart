// Collection Type Model
class CollectionType {
  final int id;
  final String name;
  final String description;
  final bool isActive = true;
  bool isPrimary = false;


  CollectionType({
    required this.id,
    required this.name,
    required this.description,
    this.isPrimary = false,
  });

  factory CollectionType.fromJson(Map<String, dynamic> json) {
    return CollectionType(
      id: json['collection_type_id'],
      name: json['collection_type_name'],
      description: json['collection_type_description'],
      isPrimary: json['is_primary'] == false ? false : true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collection_type_id': id,
      'collection_type_name': name,
      'collection_type_description': description,
      'collection_type_status': isActive ? 'active' : 'inactive',
      'is_primary': isPrimary,
    };
  }

  CollectionType copyWith({
    int? id,
    String? name,
    String? description,
    bool? isActive,
  }) {
    return CollectionType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isPrimary: isPrimary,
    );
  }
}
