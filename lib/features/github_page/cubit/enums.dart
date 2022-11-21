part of 'github_search_cubit.dart';

enum CubitState {
  initial,
  loading,
  loaded,
  errorLoading,
}

enum RadioValue {
  users,
  issues,
  repositories,
}

enum PagePagination {
  lazyLoading,
  withIndex,
}
