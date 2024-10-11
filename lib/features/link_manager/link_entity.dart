class LinkEntity {
  final String id;
  final String name;
  final String url;
  final List<String> tags;
  final DateTime createdAt;

  const LinkEntity({
    required this.id,
    required this.name,
    required this.url,
    required this.tags,
    required this.createdAt,
  });

  factory LinkEntity.fromJson(Map<String, dynamic> json) {
    return LinkEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      tags: List<String>.from(json['tags'] as List<dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
