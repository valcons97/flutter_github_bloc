part of '../github_page.dart';

class PagingHeader extends StatelessWidget {
  const PagingHeader(
      {super.key,
      required this.chipValue,
      required this.pageSelected,
      required this.scrollSelected});

  final ChipValue chipValue;

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
              if (chipValue != ChipValue.lazyLoading) {
                context
                    .read<GithubSearchCubit>()
                    .setPaging(ChipValue.lazyLoading);
              }
            },
          ),
        ),
        Expanded(
          child: DeallChip(
            text: 'With Index',
            selected: pageSelected,
            onSelected: (val) {
              if (chipValue != ChipValue.withIndex) {
                context
                    .read<GithubSearchCubit>()
                    .setPaging(ChipValue.withIndex);
              }
            },
          ),
        ),
      ],
    );
  }
}
