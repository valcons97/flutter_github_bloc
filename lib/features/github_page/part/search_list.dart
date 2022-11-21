part of '../github_page.dart';

class SearchList extends StatelessWidget {
  const SearchList({
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
          if (state.pagePaginationValue == PagePagination.lazyLoading) {
            return LazyScrollList(blocContext: blocContext, length: length);
          } else if (state.pagePaginationValue == PagePagination.withIndex) {
            return IndexList(
                length: length,
                blocContext: blocContext,
                indexBackToTop: indexBackToTop);
          }
          return Container();
        },
      ),
    );
  }
}
