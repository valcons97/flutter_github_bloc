part of '../github_page.dart';

class SearchList extends StatelessWidget {
  const SearchList({
    super.key,
    required this.value,
    required this.length,
    this.userModel,
    this.issueModel,
    this.repoModel,
  });

  final RadioValue value;

  final int length;

  final List<UserModel>? userModel;

  final List<IssuesModel>? issueModel;

  final List<RepositoriesModel>? repoModel;

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
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          } else if (value == RadioValue.issues) {
            late int totalIssues;
            if (issueModel![index].issues == null) {
              // if issues is null will be default by 0
              totalIssues = 0;
            } else {
              var openIssues = issueModel![index].issues?.openIssues ?? 0;
              var closedIssues = issueModel![index].issues?.closedIssues ?? 0;
              totalIssues = openIssues + closedIssues;
            }
            if (index < length) {
              return DeallListTile.issues(
                title: issueModel![index].title,
                imageUrl: issueModel![index].user.avatarUrl,
                updateDate: DateFormat('dd-MM-yyyy')
                    .format(issueModel![index].updatedAt),
                issues: '$totalIssues Issues',
                states: issueModel![index].state ?? 'Unknown',
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          } else if (value == RadioValue.repositories) {
            return DeallListTile.repo(
              repoTitle: repoModel![index].repoTitle,
              imageUrl: repoModel![index].owner.avatarUrl,
              createdDate:
                  DateFormat('dd-MM-yyyy').format(repoModel![index].createdAt),
              watchers: '${repoModel![index].watchers} watchers',
              stars: '${repoModel![index].stars} stars',
              forks: '${repoModel![index].forks} forks',
            );
          }
          return Container();
        },
      ),
    );
  }
}
