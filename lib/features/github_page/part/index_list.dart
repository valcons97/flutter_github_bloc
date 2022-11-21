part of '../github_page.dart';

/// Widget for indexed list
class IndexList extends StatelessWidget {
  const IndexList({
    super.key,
    required this.length,
    required this.blocContext,
    required this.indexBackToTop,
  });

  final int length;

  final BuildContext blocContext;

  final VoidCallback indexBackToTop;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<GithubSearchCubit>(blocContext),
      child: BlocBuilder<GithubSearchCubit, GithubSearchState>(
        builder: (context, state) {
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
                  indexItem =
                      index + (state.limit * selectedPageNumber) - state.limit;
                } else {
                  indexItem = index;
                }
                if (state.radioValue == RadioValue.users) {
                  if (index < limitLength) {
                    return DeallListTile.users(
                      user: state.userModel[indexItem].login,
                      imageUrl: state.userModel[indexItem].avatarUrl,
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
                } else if (state.radioValue == RadioValue.issues) {
                  if (index < limitLength) {
                    late int totalIssues;
                    if (state.issueModel[indexItem].issues == null) {
                      // if issues is null will be default by 0
                      totalIssues = 0;
                    } else {
                      var openIssues =
                          state.issueModel[indexItem].issues?.openIssues ?? 0;
                      var closedIssues =
                          state.issueModel[indexItem].issues?.closedIssues ?? 0;
                      totalIssues = openIssues + closedIssues;
                    }
                    return DeallListTile.issues(
                      title: state.issueModel[indexItem].title,
                      imageUrl: state.issueModel[indexItem].user.avatarUrl,
                      updateDate: DateFormat('dd-MM-yyyy')
                          .format(state.issueModel[indexItem].updatedAt),
                      issues: '$totalIssues Issues',
                      states: state.issueModel[indexItem].state ?? 'Unknown',
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
                } else if (state.radioValue == RadioValue.repositories) {
                  if (index < limitLength) {
                    return DeallListTile.repo(
                      repoTitle: state.repoModel[indexItem].repoTitle,
                      imageUrl: state.repoModel[indexItem].owner.avatarUrl,
                      createdDate: DateFormat('dd-MM-yyyy')
                          .format(state.repoModel[indexItem].createdAt),
                      watchers:
                          '${state.repoModel[indexItem].watchers} watchers',
                      stars: '${state.repoModel[indexItem].stars} stars',
                      forks: '${state.repoModel[indexItem].forks} forks',
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
        },
      ),
    );
  }
}
