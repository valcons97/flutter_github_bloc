part of 'github_search_cubit.dart';

class GithubSearchState extends Equatable {
  const GithubSearchState({
    required this.cubitState,
    required this.radioValue,
    required this.chipValue,
    this.search,
    this.usersSearch,
    this.issuesSearch,
    this.reposSearch,
    required this.userModel,
    required this.issueModel,
    required this.repoModel,
    this.errorMessage,
    this.userPage = 1,
    this.issuesPage = 1,
    this.repoPage = 1,
  });

  final CubitState cubitState;

  final RadioValue radioValue;

  final ChipValue chipValue;

  final String? search;
  final String? usersSearch;
  final String? issuesSearch;
  final String? reposSearch;

  final int? userPage;
  final int? issuesPage;
  final int? repoPage;

  final List<UserModel> userModel;
  final List<IssuesModel> issueModel;
  final List<RepositoriesModel> repoModel;

  final String? errorMessage;

  bool get scrollSelected => chipValue == ChipValue.lazyLoading;

  bool get pageSelected => chipValue == ChipValue.withIndex;

  @override
  List<Object?> get props => [
        cubitState,
        radioValue,
        chipValue,
        search,
        usersSearch,
        issuesSearch,
        reposSearch,
        userModel,
        issueModel,
        repoModel,
        userPage,
        issuesPage,
        repoPage,
      ];

  GithubSearchState copyWith({
    CubitState? cubitState,
    RadioValue? radioValue,
    RadioValue? lastValue,
    ChipValue? chipValue,
    String? search,
    String? usersSearch,
    String? issuesSearch,
    String? reposSearch,
    int? userPage,
    int? issuesPage,
    int? repoPage,
    List<UserModel>? userModel,
    List<IssuesModel>? issueModel,
    List<RepositoriesModel>? repoModel,
    String? errorMessage,
  }) {
    return GithubSearchState(
      cubitState: cubitState ?? this.cubitState,
      radioValue: radioValue ?? this.radioValue,
      chipValue: chipValue ?? this.chipValue,
      search: search ?? this.search,
      usersSearch: usersSearch ?? this.usersSearch,
      issuesSearch: issuesSearch ?? this.issuesSearch,
      reposSearch: reposSearch ?? this.reposSearch,
      userPage: userPage ?? this.userPage,
      issuesPage: issuesPage ?? this.issuesPage,
      repoPage: repoPage ?? this.repoPage,
      userModel: userModel ?? this.userModel,
      issueModel: issueModel ?? this.issueModel,
      repoModel: repoModel ?? this.repoModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
