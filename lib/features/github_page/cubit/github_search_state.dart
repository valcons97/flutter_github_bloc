part of 'github_search_cubit.dart';

class GithubSearchState extends Equatable {
  const GithubSearchState({
    required this.state,
    required this.radioValue,
    required this.pagePaginationValue,
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
    this.limit = 15,
    this.userHasMore = true,
    this.issuesHasMore = true,
    this.repoHasMore = true,
  });

  /// State for initial,loading,loaded and error
  final CubitState state;

  /// Radio value for users, issues, repositories
  final RadioValue radioValue;

  ///
  final PagePagination pagePaginationValue;

  final String? search;
  final String? usersSearch;
  final String? issuesSearch;
  final String? reposSearch;

  final int? userPage;
  final int? issuesPage;
  final int? repoPage;

  final int limit;

  final bool userHasMore;
  final bool issuesHasMore;
  final bool repoHasMore;

  final List<UserModel> userModel;
  final List<IssuesModel> issueModel;
  final List<RepositoriesModel> repoModel;

  final String? errorMessage;

  bool get scrollSelected => pagePaginationValue == PagePagination.lazyLoading;

  bool get pageSelected => pagePaginationValue == PagePagination.withIndex;

  @override
  List<Object?> get props => [
        state,
        radioValue,
        pagePaginationValue,
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
        userHasMore,
        issuesHasMore,
        repoHasMore
      ];

  GithubSearchState copyWith({
    CubitState? state,
    RadioValue? radioValue,
    PagePagination? pagePaginationValue,
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
    bool? userHasMore,
    bool? issuesHasMore,
    bool? repoHasMore,
  }) {
    return GithubSearchState(
      state: state ?? this.state,
      radioValue: radioValue ?? this.radioValue,
      pagePaginationValue: pagePaginationValue ?? this.pagePaginationValue,
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
      userHasMore: userHasMore ?? this.userHasMore,
      issuesHasMore: issuesHasMore ?? this.issuesHasMore,
      repoHasMore: repoHasMore ?? this.repoHasMore,
    );
  }
}
