import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.login,
    required this.avatarUrl,
  });

  final String login;

  final String avatarUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        login: json["login"],
        avatarUrl: json["avatar_url"],
      );

  @override
  List<Object?> get props => [login, avatarUrl];
}
