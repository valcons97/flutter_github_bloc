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
        context.read<GithubSearchCubit>().fetchData(null, true);
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

            Widget emptyView = SliverFillRemaining(
              hasScrollBody: true,
              child: Center(
                child: Text(
                  "There is no data called ${state.search}",
                ),
              ),
            );

            if (state.cubitState == CubitState.initial) {
              view = const SliverFillRemaining(
                hasScrollBody: true,
                child: Center(
                  child: Text('Please search'),
                ),
              );
            } else if (state.cubitState == CubitState.loading) {
              view = const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state.cubitState == CubitState.loaded) {
              if (state.radioValue == RadioValue.users) {
                if (state.userModel.isNotEmpty) {
                  view = SearchList(
                    value: state.radioValue,
                    length: state.userModel.length,
                    userModel: state.userModel,
                  );
                } else {
                  view = emptyView;
                }
              } else if (state.radioValue == RadioValue.issues) {
                if (state.issueModel.isNotEmpty) {
                  view = SearchList(
                    value: state.radioValue,
                    length: state.issueModel.length,
                    issueModel: state.issueModel,
                  );
                } else {
                  view = emptyView;
                }
              } else if (state.radioValue == RadioValue.repositories) {
                if (state.repoModel.isNotEmpty) {
                  view = SearchList(
                    value: state.radioValue,
                    length: state.repoModel.length,
                    repoModel: state.repoModel,
                  );
                } else {
                  view = emptyView;
                }
              }
            } else if (state.cubitState == CubitState.errorLoading) {
              view = SliverFillRemaining(
                hasScrollBody: true,
                child: Center(
                  child: Text(
                    state.errorMessage ?? '',
                  ),
                ),
              );
            }

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        SearchHeader(blocContext: context),
                      ],
                    ),
                  ),
                ];
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomScrollView(
                  controller: controller,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
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
                              chipValue: state.chipValue,
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
              ),
            );
          },
        ),
      ),
    );
  }
}
