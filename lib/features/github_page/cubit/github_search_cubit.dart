import 'dart:convert';

import 'package:deall/utils/lib/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../model/models.dart';
import 'enums.dart';

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

    final radioValue = state.radioValue;

    uri =
        '$baseUrl${radioValue.name}?q=${state.search}&per_page=${state.limit}';

    if (state.search != null) {
      cacheOrFetch(uri, radioValue);
    }
  }

  /// Fetching users data
  Future<void> fetchUsersData(
      String val, String uri, String radioValue, bool fetchMore) async {
    List<UserModel> currentList = [];

    currentList.addAll(state.userModel);
    late List<UserModel> list;
    try {
      if (currentList.isEmpty ||
          state.pagePaginationValue == PagePagination.withIndex) {
        /// State wont go to loading when fetching more
        emit(state.copyWith(state: CubitState.loading));
      }

      final response = await http.get(Uri.parse('$uri&page=${state.userPage}'));

      if (response.statusCode == 200) {
        list = (json.decode(response.body)['items'] as List)
            .map((data) => UserModel.fromJson(data))
            .toList();

        currentList.addAll(list);

        if (list.length < state.limit) {
          emit(state.copyWith(userHasMore: false));
        }

        emit(
          state.copyWith(
            state: CubitState.loaded,
            userModel: currentList,
            usersSearch: val,
          ),
        );
      } else {
        if (response.statusCode == 403) {
          error403();
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          state: CubitState.errorLoading,
          errorMessage:
              "Error: Please contact support about this error \n${e.toString()}",
        ),
      );
    }
  }

  /// Fetching Issues Data
  Future<void> fetchIssuesData(
      String val, String uri, String radioValue, bool fetchMore) async {
    List<IssuesModel> currentList = [];

    currentList.addAll(state.issueModel);
    late List<IssuesModel> list;

    try {
      if (currentList.isEmpty ||
          state.pagePaginationValue == PagePagination.withIndex) {
        /// State wont go to loading when fetching more
        emit(state.copyWith(state: CubitState.loading));
      }

      final response =
          await http.get(Uri.parse('$uri&page=${state.issuesPage}'));

      if (response.statusCode == 200) {
        list = (json.decode(response.body)['items'] as List)
            .map((data) => IssuesModel.fromJson(data))
            .toList();

        currentList.addAll(list);

        if (list.length < state.limit) {
          emit(state.copyWith(issuesHasMore: false));
        }

        emit(
          state.copyWith(
            state: CubitState.loaded,
            issueModel: currentList,
            issuesSearch: val,
          ),
        );
      } else {
        if (response.statusCode == 403) {
          error403();
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          state: CubitState.errorLoading,
          errorMessage:
              "Error: Please contact support about this error \n${e.toString()}",
        ),
      );
    }
  }

  /// Fetching Repositories Data
  Future<void> fetchRepoData(
      String val, String uri, String radioValue, bool fetchMore) async {
    List<RepositoriesModel> currentList = [];

    currentList.addAll(state.repoModel);
    late List<RepositoriesModel> list;

    try {
      if (currentList.isEmpty ||
          state.pagePaginationValue == PagePagination.withIndex) {
        /// State wont go to loading when fetching more
        emit(state.copyWith(state: CubitState.loading));
      }

      debugPrint('$uri&page=${state.repoPage}');
      final response = await http.get(Uri.parse('$uri&page=${state.repoPage}'));

      if (response.statusCode == 200) {
        list = (json.decode(response.body)['items'] as List)
            .map((data) => RepositoriesModel.fromJson(data))
            .toList();

        currentList.addAll(list);

        if (list.length < state.limit) {
          emit(state.copyWith(repoHasMore: false));
        }

        emit(
          state.copyWith(
            state: CubitState.loaded,
            repoModel: currentList,
            reposSearch: val,
          ),
        );
      } else {
        if (response.statusCode == 403) {
          error403();
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          state: CubitState.errorLoading,
          errorMessage:
              'Error: Please contact support about this error \n${e.toString()}',
        ),
      );
    }
  }

  Future<void> cacheOrFetch(
    String uri,
    RadioValue radioValue,
  ) async {
    /// When radio button value is users
    if (radioValue == RadioValue.users) {
      if (state.userModel.isEmpty) {
        await fetchUsersData(
            state.search ?? "", uri, radioValue.name, (state.userHasMore));
      } else {
        if (state.usersSearch != state.search) {
          emptyData();
          await fetchUsersData(
              state.search ?? "", uri, radioValue.name, (state.userHasMore));
        } else if ((state.userHasMore)) {
          emit(state.copyWith(userPage: state.userPage! + 1));

          await fetchUsersData(
              state.search ?? "", uri, radioValue.name, (state.userHasMore));
        } else {
          emit(state.copyWith(state: CubitState.loaded));
        }
      }
    }

    /// When radio button value is issues
    else if (radioValue == RadioValue.issues) {
      if (state.issueModel.isEmpty) {
        debugPrint(state.issueModel.length.toString());
        await fetchIssuesData(
            state.search ?? "", uri, radioValue.name, (state.issuesHasMore));
      } else {
        if (state.issuesSearch != state.search) {
          emptyData();
          await fetchIssuesData(
              state.search ?? "", uri, radioValue.name, (state.issuesHasMore));
        } else if ((state.issuesHasMore)) {
          emit(state.copyWith(issuesPage: state.issuesPage! + 1));
          await fetchIssuesData(
              state.search ?? "", uri, radioValue.name, (state.issuesHasMore));
        } else {
          emit(
            state.copyWith(
              state: CubitState.loaded,
            ),
          );
        }
      }
    }

    /// When radio button value is repositories
    else if (radioValue == RadioValue.repositories) {
      ///
      /// When Repositories Model is empty or first search
      if (state.repoModel.isEmpty) {
        await fetchRepoData(
            state.search ?? "", uri, radioValue.name, (state.repoHasMore));
      } else {
        ///
        /// When repositories search is not same with current search fetch new data
        if (state.reposSearch != state.search) {
          emptyData();
          await fetchRepoData(
              state.search ?? "", uri, radioValue.name, (state.repoHasMore));
        }

        /// When repositories search has more data in lazy loading
        else if ((state.repoHasMore)) {
          emit(state.copyWith(repoPage: state.repoPage! + 1));
          await fetchRepoData(
              state.search ?? "", uri, radioValue.name, (state.repoHasMore));
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

  /// Clear data when user search new value
  void emptyData() {
    ///
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
      emit(
        state.copyWith(
          userSelectedPage: value,
        ),
      );
    }
    if (state.radioValue == RadioValue.issues) {
      emit(
        state.copyWith(
          issuesSelectedPage: value,
        ),
      );
    }
    if (state.radioValue == RadioValue.repositories) {
      emit(
        state.copyWith(
          repoSelectedPage: value,
        ),
      );
    }
  }
}
