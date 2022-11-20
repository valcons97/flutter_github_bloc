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
            cubitState: CubitState.initial,
            radioValue: RadioValue.users,
            chipValue: ChipValue.lazyLoading,
            userModel: [],
            issueModel: [],
            repoModel: [],
          ),
        );

  void fetchData(String? value, bool fetchMore) {
    late String uri;

    final String baseUrl = dotenv.getString('BASE_URL');

    final radioValue = (state).radioValue;

    if (value == null) {
      value == (state).search;
    }

    // Constant limit per page is 10
    uri = '$baseUrl${radioValue.name}?q=$value&per_page=10';

    cacheOrFetch(uri, radioValue, fetchMore);
  }

  // Fetching users data
  Future<void> fetchUsersData(
      String val, String uri, String radioValue, bool fetchMore) async {
    List<UserModel> currentList = [];

    currentList.addAll((state).userModel);
    late List<UserModel> list;
    try {
      if (!fetchMore) {
        emit(state.copyWith(cubitState: CubitState.loading));
      }

      final response =
          await http.get(Uri.parse('$uri&page=${(state).userPage}'));

      if (response.statusCode == 200) {
        list = (json.decode(response.body)['items'] as List)
            .map((data) => UserModel.fromJson(data))
            .toList();

        currentList.addAll(list);

        emit(
          state.copyWith(
            cubitState: CubitState.loaded,
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
          cubitState: CubitState.errorLoading,
          errorMessage:
              "Error: Please contact support about this error \n${e.toString()}",
        ),
      );
    }
  }

  // Fetching Issues Data
  Future<void> fetchIssuesData(
      String val, String uri, String radioValue) async {
    late List<IssuesModel> list;

    try {
      emit(state.copyWith(cubitState: CubitState.loading));
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        list = (json.decode(response.body)['items'] as List)
            .map((data) => IssuesModel.fromJson(data))
            .toList();

        emit(
          state.copyWith(
            cubitState: CubitState.loaded,
            issueModel: list,
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
          cubitState: CubitState.errorLoading,
          errorMessage:
              "Error: Please contact support about this error \n${e.toString()}",
        ),
      );
    }
  }

  // Fetching Repositories Data
  Future<void> fetchRepoData(String val, String uri, String radioValue) async {
    late List<RepositoriesModel> list;

    try {
      emit(state.copyWith(cubitState: CubitState.loading));
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        list = (json.decode(response.body)['items'] as List)
            .map((data) => RepositoriesModel.fromJson(data))
            .toList();

        debugPrint(list.toString());

        emit(
          state.copyWith(
            cubitState: CubitState.loaded,
            repoModel: list,
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
          cubitState: CubitState.errorLoading,
          errorMessage:
              'Error: Please contact support about this error \n${e.toString()}',
        ),
      );
    }
  }

  Future<void> cacheOrFetch(
      String uri, RadioValue radioValue, bool fetchMore) async {
    // When radio button value is users
    if (radioValue == RadioValue.users) {
      if ((state).userModel.isEmpty) {
        await fetchUsersData(
            (state).search ?? "", uri, radioValue.name, fetchMore);
      } else {
        if ((state).usersSearch != (state).search) {
          emptyData(radioValue);
          await fetchUsersData(
              (state).search ?? "", uri, radioValue.name, fetchMore);
        } else if (fetchMore) {
          emit(state.copyWith(userPage: (state).userPage! + 1));
          await fetchUsersData(
              (state).search ?? "", uri, radioValue.name, fetchMore);
        } else {
          emit(state.copyWith(cubitState: CubitState.loaded));
        }
      }
    }
    // When radio button value is issues
    else if (radioValue == RadioValue.issues) {
      if ((state).issueModel.isEmpty) {
        await fetchIssuesData((state).search ?? "", uri, radioValue.name);
      } else {
        if ((state).issuesSearch != (state).search) {
          emptyData(radioValue);
          await fetchIssuesData((state).search ?? "", uri, radioValue.name);
        } else if (fetchMore) {
          emit(state.copyWith(issuesPage: (state).userPage! + 1));
          await fetchIssuesData((state).search ?? "", uri, radioValue.name);
        } else {
          emit(
            state.copyWith(
              cubitState: CubitState.loaded,
            ),
          );
        }
      }
    }
    // When radio button value is issues
    else if (radioValue == RadioValue.repositories) {
      if ((state).repoModel.isEmpty) {
        await fetchRepoData((state).search ?? "", uri, radioValue.name);
      } else {
        if ((state).reposSearch != (state).search) {
          emptyData(radioValue);
          await fetchRepoData((state).search ?? "", uri, radioValue.name);
        } else if (fetchMore) {
          emit(state.copyWith(repoPage: (state).userPage! + 1));
          await fetchRepoData((state).search ?? "", uri, radioValue.name);
        } else {
          emit(state.copyWith(cubitState: CubitState.loaded));
        }
      }
    }
  }

  void setRadio(RadioValue value) {
    emit(state.copyWith(radioValue: value));
  }

  void setSearch(String value) {
    emit(state.copyWith(search: value));
  }

  void setPaging(ChipValue chipValue) {
    emit(state.copyWith(chipValue: chipValue));
  }

  void error403() {
    emit(
      state.copyWith(
        cubitState: CubitState.errorLoading,
        errorMessage: "Error: this Api has a limit of 10 hits per minute",
      ),
    );
  }

  void emptyData(RadioValue radioValue) {
    if (radioValue == RadioValue.users) {
      emit(
        state.copyWith(
          userModel: [],
          userPage: 1,
        ),
      );
    }
    // When radio button value is issues
    else if (radioValue == RadioValue.issues) {
      emit(
        state.copyWith(
          issueModel: [],
          issuesPage: 1,
        ),
      );
    }
    // When radio button value is repo
    else if (radioValue == RadioValue.repositories) {
      emit(
        state.copyWith(
          repoModel: [],
          repoPage: 1,
        ),
      );
    }
  }
}
