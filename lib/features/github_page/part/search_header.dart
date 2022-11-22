part of '../github_page.dart';

/// Header for search with textformfield widget
class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key, required this.blocContext});

  final BuildContext blocContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<GithubSearchCubit>(blocContext),
      child: BlocBuilder<GithubSearchCubit, GithubSearchState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: DebounceBuilder(
              delay: const Duration(milliseconds: 1500),
              builder: (context, debounce) {
                return TextFormField(
                  initialValue: state.search,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    hintText: "Search",
                    prefixIcon: Icon(
                      Icons.search,
                      color: context.res.colors.textGray,
                    ),
                  ),
                  onChanged: (val) => debounce(() {
                    if (val.isNotEmpty && state.search != val) {
                      context.read<GithubSearchCubit>().setSearch(val);
                      context.read<GithubSearchCubit>().fetchData();
                    }
                  }),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
