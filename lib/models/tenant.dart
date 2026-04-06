class Tenant {
  final int? id;
  final String? name;
  final String? slug;

  Tenant({
    this.id,
    this.name,
    this.slug,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }
}