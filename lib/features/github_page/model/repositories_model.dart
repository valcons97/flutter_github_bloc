import 'package:equatable/equatable.dart';

import 'models.dart';

class RepositoriesModel extends Equatable {
  const RepositoriesModel({
    required this.repoTitle,
    required this.owner,
    required this.createdAt,
    required this.watchers,
    required this.stars,
    required this.forks,
  });

  final String repoTitle;

  final UserModel owner;

  final DateTime createdAt;

  final int watchers;

  final int stars;

  final int forks;

  factory RepositoriesModel.fromJson(Map<String, dynamic> json) =>
      RepositoriesModel(
        repoTitle: json["name"],
        owner: UserModel.fromJson(json["owner"]),
        createdAt: DateTime.parse(json["created_at"]),
        watchers: json["watchers_count"],
        stars: json["stargazers_count"],
        forks: json["forks_count"],
      );

  @override
  List<Object?> get props => [
        repoTitle,
        owner,
        createdAt,
        watchers,
        stars,
        forks,
      ];
}
