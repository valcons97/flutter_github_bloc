import 'package:deall/core/core.dart';
import 'package:debounce_builder/debounce_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

import 'cubit/enums.dart';
import 'cubit/github_search_cubit.dart';
import 'model/models.dart';

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
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        context.read<GithubSearchCubit>().fetchData(true);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void backToTop() {
    controller.jumpTo(
      controller.position.minScrollExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GithubSearchCubit, GithubSearchState>(
          builder: (context, state) {
            late Widget view;

            /// When user search and resulting in empty content
            final Widget emptyView = SliverFillRemaining(
              hasScrollBody: true,
              child: Center(
                child: Text(
                  "There is no data called ${state.search}",
                ),
              ),
            );

            /// Widget for user list view
            final Widget usersListView;

            state.userModel.isNotEmpty
                ? usersListView = SearchList(
                    value: state.radioValue,
                    length: state.userModel.length,
                    userModel: state.userModel,
                    userHasMore: state.userHasMore,
                    pagePaginationValue: state.pagePaginationValue,
                  )
                : usersListView = emptyView;

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
                state.issueModel.isNotEmpty
                    ? view = SearchList(
                        value: state.radioValue,
                        length: state.issueModel.length,
                        issueModel: state.issueModel,
                        issueHasMore: state.issuesHasMore,
                        pagePaginationValue: state.pagePaginationValue,
                      )
                    : view = emptyView;
              } else if (state.radioValue == RadioValue.repositories) {
                state.repoModel.isNotEmpty
                    ? view = SearchList(
                        value: state.radioValue,
                        length: state.repoModel.length,
                        repoModel: state.repoModel,
                        repoHasMore: state.repoHasMore,
                        pagePaginationValue: state.pagePaginationValue,
                      )
                    : view = emptyView;
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
                        ? controller
                        : null,
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
                            controller: controller,
                            backToTop: backToTop,
                          ),
                          PagingHeader(
                            pagePaginationValue: state.pagePaginationValue,
                            pageSelected: state.pageSelected,
                            scrollSelected: state.scrollSelected,
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
