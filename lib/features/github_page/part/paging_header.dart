part of '../github_page.dart';

/// Header for selecting lazyscroll
/// or index
class PagingHeader extends StatelessWidget {
  const PagingHeader(
      {super.key,
      required this.pagePaginationValue,
      required this.pageSelected,
      required this.scrollSelected});

  final PagePagination pagePaginationValue;

  final bool scrollSelected;

  final bool pageSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DeallChip(
            text: 'Lazy Loading',
            selected: scrollSelected,
            onSelected: (val) {
              if (pagePaginationValue != PagePagination.lazyLoading) {
                context
                    .read<GithubSearchCubit>()
                    .setPaging(PagePagination.lazyLoading);
              }
            },
          ),
        ),
        Expanded(
          child: DeallChip(
            text: 'With Index',
            selected: pageSelected,
            onSelected: (val) {
              if (pagePaginationValue != PagePagination.withIndex) {
                context
                    .read<GithubSearchCubit>()
                    .setPaging(PagePagination.withIndex);
              }
            },
          ),
        ),
      ],
    );
  }
}
