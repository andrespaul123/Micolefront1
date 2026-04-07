class Tenant {
  final int? id;
  final String? name;
  final String? slug;
  final String? logo;

  Tenant({
    this.id,
    this.name,
    this.slug,
    this.logo,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      logo: json['logo'],
    );
  }
}