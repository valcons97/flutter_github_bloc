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
    this.limit = 25,
    this.userHasMore = true,
    this.issuesHasMore = true,
    this.repoHasMore = true,
    this.userSelectedPage = 1,
    this.issuesSelectedPage = 1,
    this.repoSelectedPage = 1,
  });

  /// State for initial,loading,loaded and error
  final CubitState state;

  /// Radio value for users, issues, repositories
  final RadioValue radioValue;

  /// For choosing lazy loading or index
  final PagePagination pagePaginationValue;

  /// Store text search
  final String? search;
  final String? usersSearch;
  final String? issuesSearch;
  final String? reposSearch;

  /// Store last page of fetched data
  final int? userPage;
  final int? issuesPage;
  final int? repoPage;

  /// Limit for fetching data
  final int limit;

  /// Boolean when each value has more data
  final bool userHasMore;
  final bool issuesHasMore;
  final bool repoHasMore;

  /// Model data
  final List<UserModel> userModel;
  final List<IssuesModel> issueModel;
  final List<RepositoriesModel> repoModel;

  /// For last selected page
  final int? userSelectedPage;
  final int? issuesSelectedPage;
  final int? repoSelectedPage;

  final String? errorMessage;

  bool get lazyScrollSelected =>
      pagePaginationValue == PagePagination.lazyLoading;

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
        repoHasMore,
        userSelectedPage,
        issuesSelectedPage,
        repoSelectedPage,
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
    int? userSelectedPage,
    int? issuesSelectedPage,
    int? repoSelectedPage,
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
      userSelectedPage: userSelectedPage ?? this.userSelectedPage,
      issuesSelectedPage: issuesSelectedPage ?? this.issuesSelectedPage,
      repoSelectedPage: repoSelectedPage ?? this.repoSelectedPage,
    );
  }
}
