class Admin {
  final int id;
  final String name;
  final String email;
  final String department;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] ?? 0,
      name: json['name'] ?? '-',
      email: json['email'] ?? '-',
      // fallback company.name hanya supaya jalan di JSONPlaceholder
      department: json['department'] ?? json['company']?['name'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'department': department,
      };
}
