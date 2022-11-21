part of '../github_page.dart';

/// Please do not follow this implementation
/// I was sick and needed to stay rest in hospital
/// After i got discharge will cleaning up this code
///
class SearchList extends StatelessWidget {
  const SearchList({
    super.key,
    required this.value,
    required this.length,
    required this.pagePaginationValue,
    this.userModel,
    this.issueModel,
    this.repoModel,
    this.userHasMore,
    this.issueHasMore,
    this.repoHasMore,
    required this.limit,
    required this.blocContext,
    required this.indexBackToTop,
  });

  final RadioValue value;

  final int length;

  final PagePagination pagePaginationValue;

  final List<UserModel>? userModel;

  final List<IssuesModel>? issueModel;

  final List<RepositoriesModel>? repoModel;

  final bool? userHasMore;

  final bool? issueHasMore;

  final bool? repoHasMore;

  final int limit;

  final BuildContext blocContext;

  final VoidCallback indexBackToTop;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<GithubSearchCubit>(blocContext),
      child: BlocBuilder<GithubSearchCubit, GithubSearchState>(
        builder: (context, state) {
          if (state.pagePaginationValue == PagePagination.lazyLoading) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: length + 1,
                (context, index) {
                  if (value == RadioValue.users) {
                    if (index < length) {
                      return DeallListTile.users(
                        user: userModel![index].login,
                        imageUrl: userModel![index].avatarUrl,
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: userHasMore!
                              ? const CircularProgressIndicator()
                              : const Text('No more data to load'),
                        ),
                      );
                    }
                  } else if (value == RadioValue.issues) {
                    if (index < length) {
                      late int totalIssues;
                      if (issueModel![index].issues == null) {
                        // if issues is null will be default by 0
                        totalIssues = 0;
                      } else {
                        var openIssues =
                            issueModel![index].issues?.openIssues ?? 0;
                        var closedIssues =
                            issueModel![index].issues?.closedIssues ?? 0;
                        totalIssues = openIssues + closedIssues;
                      }
                      return DeallListTile.issues(
                        title: issueModel![index].title,
                        imageUrl: issueModel![index].user.avatarUrl,
                        updateDate: DateFormat('dd-MM-yyyy')
                            .format(issueModel![index].updatedAt),
                        issues: '$totalIssues Issues',
                        states: issueModel![index].state ?? 'Unknown',
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: issueHasMore!
                              ? const CircularProgressIndicator()
                              : const Text('No more data to load'),
                        ),
                      );
                    }
                  } else if (value == RadioValue.repositories) {
                    if (index < length) {
                      return DeallListTile.repo(
                        repoTitle: repoModel![index].repoTitle,
                        imageUrl: repoModel![index].owner.avatarUrl,
                        createdDate: DateFormat('dd-MM-yyyy')
                            .format(repoModel![index].createdAt),
                        watchers: '${repoModel![index].watchers} watchers',
                        stars: '${repoModel![index].stars} stars',
                        forks: '${repoModel![index].forks} forks',
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: repoHasMore!
                              ? const CircularProgressIndicator()
                              : const Text('No more data to load'),
                        ),
                      );
                    }
                  }
                  return Container();
                },
              ),
            );
          } else if (state.pagePaginationValue == PagePagination.withIndex) {
            late int selectedPageNumber;
            late int limitLength;
            late int indexItem;

            if (state.radioValue == RadioValue.users) {
              selectedPageNumber = state.userSelectedPage!;

              if (selectedPageNumber == state.userPage && !state.userHasMore) {
                limitLength = state.userModel.length -
                    (state.limit * (selectedPageNumber - 1));
              } else {
                limitLength = state.limit;
              }
            } else if (state.radioValue == RadioValue.issues) {
              selectedPageNumber = state.issuesSelectedPage!;

              if (selectedPageNumber == state.issuesPage &&
                  !state.issuesHasMore) {
                limitLength = state.issueModel.length -
                    (state.limit * (selectedPageNumber - 1));
              } else {
                limitLength = state.limit;
              }
            } else if (state.radioValue == RadioValue.repositories) {
              selectedPageNumber = state.repoSelectedPage!;

              if (selectedPageNumber == state.repoPage && !state.repoHasMore) {
                limitLength = state.repoModel.length -
                    (state.limit * (selectedPageNumber - 1));
              } else {
                limitLength = state.limit;
              }
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: limitLength + 1,
                (context, index) {
                  if (selectedPageNumber != 1) {
                    indexItem = index +
                        (state.limit * selectedPageNumber) -
                        state.limit;
                  } else {
                    indexItem = index;
                  }
                  if (value == RadioValue.users) {
                    if (index < limitLength) {
                      return DeallListTile.users(
                        user: userModel![indexItem].login,
                        imageUrl: userModel![indexItem].avatarUrl,
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: NumberPaginator(
                            initialPage: selectedPageNumber - 1,
                            numberPages: state.userHasMore
                                ? state.userPage! + 1
                                : state.userPage!,
                            onPageChange: (int page) {
                              indexBackToTop();
                              if (page + 1 > state.userPage!) {
                                context
                                    .read<GithubSearchCubit>()
                                    .selectedPageNumber(page + 1);

                                context.read<GithubSearchCubit>().fetchData();
                              } else {
                                context
                                    .read<GithubSearchCubit>()
                                    .selectedPageNumber(page + 1);
                              }
                            },
                          ),
                        ),
                      );
                    }
                  } else if (value == RadioValue.issues) {
                    if (index < limitLength) {
                      late int totalIssues;
                      if (issueModel![indexItem].issues == null) {
                        // if issues is null will be default by 0
                        totalIssues = 0;
                      } else {
                        var openIssues =
                            issueModel![indexItem].issues?.openIssues ?? 0;
                        var closedIssues =
                            issueModel![indexItem].issues?.closedIssues ?? 0;
                        totalIssues = openIssues + closedIssues;
                      }
                      return DeallListTile.issues(
                        title: issueModel![indexItem].title,
                        imageUrl: issueModel![indexItem].user.avatarUrl,
                        updateDate: DateFormat('dd-MM-yyyy')
                            .format(issueModel![indexItem].updatedAt),
                        issues: '$totalIssues Issues',
                        states: issueModel![indexItem].state ?? 'Unknown',
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: NumberPaginator(
                            initialPage: selectedPageNumber - 1,
                            numberPages: state.issuesHasMore
                                ? state.issuesPage! + 1
                                : state.issuesPage!,
                            onPageChange: (int page) {
                              indexBackToTop();
                              if (page + 1 > state.issuesPage!) {
                                context
                                    .read<GithubSearchCubit>()
                                    .selectedPageNumber(page + 1);

                                context.read<GithubSearchCubit>().fetchData();
                              } else {
                                context
                                    .read<GithubSearchCubit>()
                                    .selectedPageNumber(page + 1);
                              }
                            },
                          ),
                        ),
                      );
                    }
                  } else if (value == RadioValue.repositories) {
                    if (index < limitLength) {
                      return DeallListTile.repo(
                        repoTitle: repoModel![indexItem].repoTitle,
                        imageUrl: repoModel![indexItem].owner.avatarUrl,
                        createdDate: DateFormat('dd-MM-yyyy')
                            .format(repoModel![indexItem].createdAt),
                        watchers: '${repoModel![indexItem].watchers} watchers',
                        stars: '${repoModel![indexItem].stars} stars',
                        forks: '${repoModel![indexItem].forks} forks',
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: NumberPaginator(
                            initialPage: selectedPageNumber - 1,
                            numberPages: state.repoHasMore
                                ? state.repoPage! + 1
                                : state.repoPage!,
                            onPageChange: (int page) {
                              indexBackToTop();
                              if (page + 1 > state.repoPage!) {
                                context
                                    .read<GithubSearchCubit>()
                                    .selectedPageNumber(page + 1);

                                context.read<GithubSearchCubit>().fetchData();
                              } else {
                                context
                                    .read<GithubSearchCubit>()
                                    .selectedPageNumber(page + 1);
                              }
                            },
                          ),
                        ),
                      );
                    }
                  }
                  return Container();
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
