import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:testinger/presentation/add/add_contact_page.dart';
import 'package:testinger/presentation/main/contact_page.dart';
import 'package:testinger/routes/scopes.dart';

part 'routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Router')
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      path: '/',
      page: MainRouter.page,
      initial: true,
      children: [
        AutoRoute(
          path: '',
          page: ContactRouter.page,
        ),
        AutoRoute(
          path: 'add',
          page: AddContactRouter.page,
        ),
      ],
    ),
  ];
}
