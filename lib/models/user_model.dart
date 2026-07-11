class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int totalVisits;
  final int totalPosts;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.totalVisits = 0,
    this.totalPosts = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
      totalVisits: json['total_visits'] ?? 0,
      totalPosts: json['total_posts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'total_visits': totalVisits,
      'total_posts': totalPosts,
    };
  }
}
