import 'dart:convert';

import 'package:deall/utils/lib/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../model/models.dart';

part 'enums.dart';
part 'github_search_state.dart';

@injectable
class GithubSearchCubit extends Cubit<GithubSearchState> {
  GithubSearchCubit()
      : super(
          const GithubSearchState(
            state: CubitState.initial,
            radioValue: RadioValue.users,
            pagePaginationValue: PagePagination.lazyLoading,
            userModel: [],
            issueModel: [],
            repoModel: [],
          ),
        );

  void fetchData() {
    late String uri;

    final String baseUrl = dotenv.getString('BASE_URL');

    uri =
        '$baseUrl${state.radioValue.name}?q=${state.search}&per_page=${state.limit}';

    if (state.search != null) {
      cacheOrFetch(uri);
    }
  }

  /// Fetching users data
  Future<void> fetchUsersData(
    String uri,
  ) async {
    List<UserModel> currentList = [];
    late List<UserModel> list;

    currentList.addAll(state.userModel);

    try {
      /// State wont go to loading when fetching more
      /// except page index
      if (currentList.isEmpty ||
          state.pagePaginationValue == PagePagination.withIndex) {
        emit(state.copyWith(state: CubitState.loading));
      }

      final response = await http.get(Uri.parse('$uri&page=${state.userPage}'));

      if (response.statusCode == 200) {
        list = (json.decode(response.body)['items'] as List)
            .map((data) => UserModel.fromJson(data))
            .toList();

        currentList.addAll(list);

        /// Stop getting more data when list length is
        /// less than limit
        if (list.length < state.limit) {
          emit(state.copyWith(userHasMore: false));
        }

        emit(
          state.copyWith(
            state: CubitState.loaded,
            userModel: currentList,
            usersSearch: state.search,
          ),
        );
      } else {
        if (response.statusCode == 403) {
          error403();
        }
      }
    } catch (error) {
      errorSupport(error.toString());
    }
  }

  /// Fetching Issues Data
  Future<void> fetchIssuesData(
    String uri,
  ) async {
    List<IssuesModel> currentList = [];
    late List<IssuesModel> list;

    currentList.addAll(state.issueModel);

    try {
      /// State wont go to loading when fetching more
      /// except page index
      if (currentList.isEmpty ||
          state.pagePaginationValue == PagePagination.withIndex) {
        emit(state.copyWith(state: CubitState.loading));
      }

      final response =
          await http.get(Uri.parse('$uri&page=${state.issuesPage}'));

      if (response.statusCode == 200) {
        list = (json.decode(response.body)['items'] as List)
            .map((data) => IssuesModel.fromJson(data))
            .toList();

        currentList.addAll(list);

        /// Stop getting more data when list length is
        /// less than limit
        if (list.length < state.limit) {
          emit(state.copyWith(issuesHasMore: false));
        }

        emit(
          state.copyWith(
            state: CubitState.loaded,
            issueModel: currentList,
            issuesSearch: state.search,
          ),
        );
      } else {
        if (response.statusCode == 403) {
          error403();
        }
      }
    } catch (error) {
      errorSupport(error.toString());
    }
  }

  /// Fetching Repositories Data
  Future<void> fetchRepoData(String uri) async {
    List<RepositoriesModel> currentList = [];
    late List<RepositoriesModel> list;

    currentList.addAll(state.repoModel);

    try {
      /// State wont go to loading when fetching more
      /// except page index
      if (currentList.isEmpty ||
          state.pagePaginationValue == PagePagination.withIndex) {
        emit(state.copyWith(state: CubitState.loading));
      }

      final response = await http.get(Uri.parse('$uri&page=${state.repoPage}'));

      if (response.statusCode == 200) {
        list = (json.decode(response.body)['items'] as List)
            .map((data) => RepositoriesModel.fromJson(data))
            .toList();

        currentList.addAll(list);

        /// Stop getting more data when list length is
        /// less than limit
        if (list.length < state.limit) {
          emit(state.copyWith(repoHasMore: false));
        }

        emit(
          state.copyWith(
            state: CubitState.loaded,
            repoModel: currentList,
            reposSearch: state.search,
          ),
        );
      } else {
        if (response.statusCode == 403) {
          error403();
        }
      }
    } catch (error) {
      errorSupport(error.toString());
    }
  }

  /// Cache but without memory yet
  Future<void> cacheOrFetch(
    String uri,
  ) async {
    /// When radio button value is users
    if (state.radioValue == RadioValue.users) {
      /// When User Model is empty or first search
      if (state.userModel.isEmpty) {
        await fetchUsersData(uri);
      } else {
        /// When user search is not same with current search fetch new data
        if (state.usersSearch != state.search) {
          emptyData();
          await fetchUsersData(uri);
        }

        /// When users search has more data
        else if ((state.userHasMore)) {
          emit(state.copyWith(userPage: state.userPage! + 1));

          await fetchUsersData(uri);
        }

        /// When there is no need to fetch new data will show loaded state
        else {
          emit(state.copyWith(state: CubitState.loaded));
        }
      }
    }

    /// When radio button value is issues
    else if (state.radioValue == RadioValue.issues) {
      /// When Issue Model is empty or first search
      if (state.issueModel.isEmpty) {
        await fetchIssuesData(uri);
      } else {
        /// When issues search is not same with current search fetch new data
        if (state.issuesSearch != state.search) {
          emptyData();
          await fetchIssuesData(uri);
        }

        /// When issues search has more data
        else if ((state.issuesHasMore)) {
          emit(state.copyWith(issuesPage: state.issuesPage! + 1));
          await fetchIssuesData(uri);
        }

        /// When there is no need to fetch new data will show loaded state
        else {
          emit(state.copyWith(state: CubitState.loaded));
        }
      }
    }

    /// When radio button value is repositories
    else if (state.radioValue == RadioValue.repositories) {
      /// When Repositories Model is empty or first search
      if (state.repoModel.isEmpty) {
        await fetchRepoData(uri);
      } else {
        /// When repositories search is not same with current search fetch new data
        if (state.reposSearch != state.search) {
          emptyData();
          await fetchRepoData(uri);
        }

        /// When repositories search has more data
        else if ((state.repoHasMore)) {
          emit(state.copyWith(repoPage: state.repoPage! + 1));
          await fetchRepoData(uri);
        }

        /// When there is no need to fetch new data will show loaded state
        else {
          emit(state.copyWith(state: CubitState.loaded));
        }
      }
    }
  }

  /// Set Radio button value to Users/Issues/Repositories
  void setRadio(RadioValue value) {
    emit(state.copyWith(radioValue: value));
  }

  /// Set Search value
  void setSearch(String value) {
    emit(state.copyWith(search: value));
  }

  /// Set LazyLoading or PageIndex
  void setPaging(PagePagination pagePaginationValue) {
    emit(state.copyWith(pagePaginationValue: pagePaginationValue));
  }

  /// When response is 403 show this error message
  void error403() {
    emit(
      state.copyWith(
        state: CubitState.errorLoading,
        errorMessage: "Error: this Api has a limit of 10 hits per minute",
      ),
    );
  }

  /// When error and needed to contact Support
  void errorSupport(String error) {
    emit(
      state.copyWith(
        state: CubitState.errorLoading,
        errorMessage: 'Error: Please contact support about this error \n$error',
      ),
    );
  }

  /// Clear data when user search new value
  void emptyData() {
    /// When radio button value is users
    if (state.radioValue == RadioValue.users) {
      emit(
        state.copyWith(
          userModel: [],
          userPage: 1,
          userHasMore: true,
          userSelectedPage: 1,
        ),
      );
    }

    /// When radio button value is issues
    else if (state.radioValue == RadioValue.issues) {
      emit(
        state.copyWith(
          issueModel: [],
          issuesPage: 1,
          issuesHasMore: true,
          issuesSelectedPage: 1,
        ),
      );
    }

    /// When radio button value is repositories
    else if (state.radioValue == RadioValue.repositories) {
      emit(
        state.copyWith(
          repoModel: [],
          repoPage: 1,
          repoHasMore: true,
          repoSelectedPage: 1,
        ),
      );
    }
  }

  /// Set selected page number
  void selectedPageNumber(int value) {
    ///
    /// When radio button value is users
    if (state.radioValue == RadioValue.users) {
      emit(state.copyWith(userSelectedPage: value));
    }
    if (state.radioValue == RadioValue.issues) {
      emit(state.copyWith(issuesSelectedPage: value));
    }
    if (state.radioValue == RadioValue.repositories) {
      emit(state.copyWith(repoSelectedPage: value));
    }
  }
}
