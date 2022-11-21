import 'package:deall/core/core.dart';
import 'package:debounce_builder/debounce_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:number_paginator/number_paginator.dart';

import 'cubit/github_search_cubit.dart';

part 'part/index_list.dart';
part 'part/lazy_scroll_list.dart';
part 'part/paging_header.dart';
part 'part/radio_header.dart';
part 'part/search_header.dart';
part 'part/search_list.dart';

class GithubPage extends StatefulWidget {
  const GithubPage({super.key});

  @override
  State<GithubPage> createState() => _GithubPageState();
}

class _GithubPageState extends State<GithubPage> {
  final lazyController = ScrollController();
  final indexController = ScrollController();

  @override
  void initState() {
    super.initState();
    lazyController.addListener(() {
      if (lazyController.position.maxScrollExtent == lazyController.offset) {
        context.read<GithubSearchCubit>().fetchData();
      }
    });
  }

  @override
  void dispose() {
    lazyController.dispose();
    super.dispose();
  }

  void backToTop() {
    lazyController.jumpTo(
      lazyController.position.minScrollExtent,
    );
  }

  void indexBackToTop() {
    indexController.jumpTo(
      indexController.position.minScrollExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GithubSearchCubit, GithubSearchState>(
          builder: (context, state) {
            late Widget view;

            /// Widget for user list view
            final Widget usersListView;

            /// Widget for user list view
            final Widget issuesListView;

            /// Widget for user list view
            final Widget repoListView;

            /// When user search and resulting in empty content
            final Widget emptyView = SliverFillRemaining(
              hasScrollBody: true,
              child: Center(
                child: Text(
                  "There is no data called ${state.search}",
                ),
              ),
            );

            usersListView = state.userModel.isNotEmpty
                ? usersListView = SearchList(
                    length: state.userModel.length,
                    blocContext: context,
                    indexBackToTop: indexBackToTop,
                  )
                : usersListView = emptyView;

            issuesListView = state.issueModel.isNotEmpty
                ? view = SearchList(
                    length: state.issueModel.length,
                    blocContext: context,
                    indexBackToTop: indexBackToTop,
                  )
                : view = emptyView;

            repoListView = state.repoModel.isNotEmpty
                ? view = SearchList(
                    length: state.repoModel.length,
                    blocContext: context,
                    indexBackToTop: indexBackToTop,
                  )
                : view = emptyView;

            /// When state is initial
            if (state.state == CubitState.initial) {
              view = const SliverFillRemaining(
                hasScrollBody: true,
                child: Center(
                  child: Text('Please search'),
                ),
              );
            }

            /// When state is loading show circular progress
            else if (state.state == CubitState.loading) {
              view = const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            /// When state is loaded
            else if (state.state == CubitState.loaded) {
              /// Radio value is users
              if (state.radioValue == RadioValue.users) {
                view = usersListView;
              }

              /// Radio value is issues
              else if (state.radioValue == RadioValue.issues) {
                view = issuesListView;
              }

              /// Radio value is repositories
              else if (state.radioValue == RadioValue.repositories) {
                view = repoListView;
              }
            }

            /// When state is error loading show error message
            else if (state.state == CubitState.errorLoading) {
              view = SliverFillRemaining(
                hasScrollBody: true,
                child: Center(
                  child: Text(
                    state.errorMessage ?? '',
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomScrollView(
                controller:
                    state.pagePaginationValue == PagePagination.lazyLoading
                        ? lazyController
                        : indexController,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    flexibleSpace: SearchHeader(blocContext: context),
                  ),
                  SliverStickyHeader(
                    header: Container(
                      color: context.res.colors.bgLightGray,
                      child: Column(
                        children: [
                          RadioHeader(
                            groupValue: state.radioValue,
                            blocContext: context,
                            controller: lazyController,
                            backToTop: backToTop,
                            indexBackToTop: indexBackToTop,
                          ),
                          PagingHeader(
                            pagePaginationValue: state.pagePaginationValue,
                            pageSelected: state.pageSelected,
                            scrollSelected: state.lazyScrollSelected,
                          ),
                        ],
                      ),
                    ),
                    sliver: view,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
