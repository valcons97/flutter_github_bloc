part of '../github_page.dart';

/// Widget for lazy loading
class LazyScrollList extends StatelessWidget {
  const LazyScrollList({
    super.key,
    required this.blocContext,
    required this.length,
  });

  final BuildContext blocContext;

  final int length;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<GithubSearchCubit>(blocContext),
      child: BlocBuilder<GithubSearchCubit, GithubSearchState>(
        builder: (context, state) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: length + 1,
              (context, index) {
                if (state.radioValue == RadioValue.users) {
                  if (index < length) {
                    return DeallListTile.users(
                      user: state.userModel[index].login,
                      imageUrl: state.userModel[index].avatarUrl,
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: state.userHasMore
                            ? const CircularProgressIndicator()
                            : const Text('No more data to load'),
                      ),
                    );
                  }
                } else if (state.radioValue == RadioValue.issues) {
                  if (index < length) {
                    late int totalIssues;
                    if (state.issueModel[index].issues == null) {
                      // if issues is null will be default by 0
                      totalIssues = 0;
                    } else {
                      var openIssues =
                          state.issueModel[index].issues?.openIssues ?? 0;
                      var closedIssues =
                          state.issueModel[index].issues?.closedIssues ?? 0;
                      totalIssues = openIssues + closedIssues;
                    }
                    return DeallListTile.issues(
                      title: state.issueModel[index].title,
                      imageUrl: state.issueModel[index].user.avatarUrl,
                      updateDate: DateFormat('dd-MM-yyyy')
                          .format(state.issueModel[index].updatedAt),
                      issues: '$totalIssues Issues',
                      states: state.issueModel[index].state ?? 'Unknown',
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: state.issuesHasMore
                            ? const CircularProgressIndicator()
                            : const Text('No more data to load'),
                      ),
                    );
                  }
                } else if (state.radioValue == RadioValue.repositories) {
                  if (index < length) {
                    return DeallListTile.repo(
                      repoTitle: state.repoModel[index].repoTitle,
                      imageUrl: state.repoModel[index].owner.avatarUrl,
                      createdDate: DateFormat('dd-MM-yyyy')
                          .format(state.repoModel[index].createdAt),
                      watchers: '${state.repoModel[index].watchers} watchers',
                      stars: '${state.repoModel[index].stars} stars',
                      forks: '${state.repoModel[index].forks} forks',
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: state.repoHasMore
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
        },
      ),
    );
  }
}
