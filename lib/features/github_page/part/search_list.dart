part of '../github_page.dart';

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

  @override
  Widget build(BuildContext context) {
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
                var openIssues = issueModel![index].issues?.openIssues ?? 0;
                var closedIssues = issueModel![index].issues?.closedIssues ?? 0;
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
  }
}
