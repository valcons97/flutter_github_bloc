part of '../github_page.dart';

class RadioHeader extends StatelessWidget {
  const RadioHeader({
    super.key,
    this.groupValue,
    required this.blocContext,
    required this.controller,
    required this.backToTop,
    required this.indexBackToTop,
  });

  final Object? groupValue;

  final BuildContext blocContext;

  final ScrollController controller;

  final VoidCallback backToTop;

  final VoidCallback indexBackToTop;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<GithubSearchCubit>(blocContext),
      child: BlocBuilder<GithubSearchCubit, GithubSearchState>(
        builder: (context, state) {
          return Row(
            children: [
              DeallRadioButton(
                value: RadioValue.users,
                groupValue: groupValue,
                title: 'User',
                onChanged: (val) {
                  if (groupValue != RadioValue.users) {
                    context
                        .read<GithubSearchCubit>()
                        .setRadio(RadioValue.users);
                    if (state.search != null) {
                      if (state.pagePaginationValue ==
                          PagePagination.lazyLoading) {
                        backToTop();
                      } else {
                        indexBackToTop();
                      }

                      context.read<GithubSearchCubit>().fetchData();
                    }
                  }
                },
              ),
              DeallRadioButton(
                value: RadioValue.issues,
                groupValue: groupValue,
                title: 'Issues',
                onChanged: (val) {
                  if (groupValue != RadioValue.issues) {
                    context
                        .read<GithubSearchCubit>()
                        .setRadio(RadioValue.issues);
                    if (state.search != null) {
                      if (state.pagePaginationValue ==
                          PagePagination.lazyLoading) {
                        backToTop();
                      } else {
                        indexBackToTop();
                      }
                      context.read<GithubSearchCubit>().fetchData();
                    }
                  }
                },
              ),
              DeallRadioButton(
                value: RadioValue.repositories,
                groupValue: groupValue,
                title: 'Repositories',
                onChanged: (val) {
                  if (groupValue != RadioValue.repositories) {
                    context
                        .read<GithubSearchCubit>()
                        .setRadio(RadioValue.repositories);
                    if (state.search != null) {
                      if (state.pagePaginationValue ==
                          PagePagination.lazyLoading) {
                        backToTop();
                      } else {
                        indexBackToTop();
                      }

                      context.read<GithubSearchCubit>().fetchData();
                    }
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}
