import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:testinger/core/core.dart';
import 'package:testinger/domain/entities/contact_list_entity.dart';
import 'package:testinger/presentation/main/controller/contact_cubit.dart';
import 'package:testinger/routes/routes.dart';

@RoutePage<void>()
class ContactPage extends StatefulWidget implements AutoRouteWrapper {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();

  @override
  Widget wrappedRoute(BuildContext context) => this;
}

class _ContactPageState extends State<ContactPage> {
  final _refreshController = RefreshController();
  final _searchController = TextEditingController();
  late ContactCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ContactCubit>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _cubit.getData(isForce: true),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showDialog(
                context: context,
                builder: (dCtx) {
                  return SimpleDialog(
                    contentPadding: EdgeInsets.all(4.w),
                    children: [
                      TextFormField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 4.w),
                      ElevatedButton(
                        onPressed: () {
                          _cubit.search(_searchController.text);
                          _searchController.clear();
                          dCtx.router.maybePop();
                        },
                        child: const Text('Search'),
                      ),
                      SizedBox(height: 4.w),
                      ElevatedButton(
                        onPressed: () {
                          _cubit.getData();
                          dCtx.router.maybePop();
                        },
                        child: const Text('clear'),
                      ),
                    ],
                  );
                });
          },
        ),
        title: const Text('Contacts'),
        actions: [
          IconButton(
            onPressed: () {
              context.router
                  .push(AddContactRouter())
                  .then((_) => _cubit.getData());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocConsumer<ContactCubit, ContactState>(
        buildWhen: (old, current) => current != old,
        listener: (context, state) {},
        builder: (context, state) {
          return SmartRefresher(
            controller: _refreshController,
            onRefresh: () => _cubit.getData(isForce: true),
            child: state.data.maybeWhen(
              loading: (msg) =>
                  const Center(child: CircularProgressIndicator()),
              failed: (msg, data, code) => Center(child: Text(msg)),
              success: (data) {
                _refreshController.refreshCompleted();
                final dataList = data as List<ContactListEntity>;
                return GridView.builder(
                  padding: EdgeInsets.all(4.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.w,
                    mainAxisSpacing: 4.w,
                  ),
                  itemBuilder: (ctx, index) {
                    final data = dataList[index];
                    return InkWell(
                      onTap: () {
                        context.router
                            .push(AddContactRouter(id: data.id))
                            .then((_) => _cubit.getData());
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: CircleAvatar(
                                radius: 25.sp,
                                backgroundColor: Constants.main,
                              ),
                            ),
                            SizedBox(height: 2.w),
                            Text(data.name),
                            SizedBox(height: 4.w),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: dataList.length,
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
