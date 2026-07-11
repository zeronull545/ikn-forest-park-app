import 'user_model.dart';

class PostModel {
  final int id;
  final String content;
  final String? imageUrl;
  final UserModel user;
  final String? parkName;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByMe;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.user,
    this.parkName,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByMe = false,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      user: UserModel.fromJson(json['user']),
      parkName: json['park_name'],
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      isLikedByMe: json['is_liked_by_me'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  PostModel copyWith({
    bool? isLikedByMe,
    int? likesCount,
    int? commentsCount,
  }) {
    return PostModel(
      id: id,
      content: content,
      imageUrl: imageUrl,
      user: user,
      parkName: parkName,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      createdAt: createdAt,
    );
  }
}
