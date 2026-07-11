import 'user_model.dart';

class CommentModel {
  final int id;
  final int postId;
  final String content;
  final UserModel user;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    required this.user,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      postId: json['post_id'] is int ? json['post_id'] : int.parse(json['post_id'].toString()),
      content: json['content'] ?? '',
      user: UserModel.fromJson(json['user']),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
}
