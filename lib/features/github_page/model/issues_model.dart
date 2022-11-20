import 'package:equatable/equatable.dart';

import 'models.dart';

class IssuesModel extends Equatable {
  const IssuesModel({
    required this.title,
    required this.user,
    required this.updatedAt,
    this.state,
    this.issues,
  });

  final String title;

  final UserModel user;

  final DateTime updatedAt;

  final String? state;

  final MilestoneModel? issues;

  factory IssuesModel.fromJson(Map<String, dynamic> json) => IssuesModel(
        title: json["title"],
        user: UserModel.fromJson(json["user"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        state: json["state"],
        issues: json["milestone"] == null
            ? null
            : MilestoneModel.fromJson(json["milestone"]),
      );

  @override
  List<Object?> get props => [
        title,
        user,
        updatedAt,
        state,
        issues,
      ];
}

class MilestoneModel extends Equatable {
  const MilestoneModel({
    required this.openIssues,
    required this.closedIssues,
  });

  final int openIssues;

  final int closedIssues;

  factory MilestoneModel.fromJson(Map<String, dynamic> json) => MilestoneModel(
        openIssues: json["open_issues"],
        closedIssues: json["closed_issues"],
      );

  @override
  List<Object?> get props => [
        openIssues,
        closedIssues,
      ];
}
