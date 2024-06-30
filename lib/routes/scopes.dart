import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:testinger/di/injects.dart';
import 'package:testinger/presentation/add/controller/add_contact_cubit.dart';
import 'package:testinger/presentation/main/controller/contact_cubit.dart';

@RoutePage<void>(name: 'MainRouter')
class MainScope extends StatelessWidget {
  const MainScope({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactCubit>(
      create: (_) => inject<ContactCubit>(),
      child: const AutoRouter(),
    );
  }
}
