import 'dart:math';
import 'dart:developer' as dev;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:testinger/core/core.dart';
import 'package:testinger/data/models/contact_model.dart';
import 'package:testinger/di/injects.dart';
import 'package:testinger/domain/entities/contact_detail_entity.dart';
import 'package:testinger/presentation/add/controller/add_contact_cubit.dart';

@RoutePage<void>()
class AddContactPage extends StatefulWidget implements AutoRouteWrapper {
  final String? id;

  const AddContactPage({super.key, this.id});

  @override
  State<AddContactPage> createState() => _AddContactPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<AddContactCubit>(
      create: (_) => inject<AddContactCubit>(),
      child: this,
    );
  }
}

class _AddContactPageState extends State<AddContactPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  late AddContactCubit _cubit;
  late LoadingDialog _loadingDialog;
  DateTime? _currentDate;
  ContactDetailEntity? _currentData;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AddContactCubit>();
    _loadingDialog = LoadingDialog(context);
    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _cubit.getDetail(widget.id!),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20.w,
        leading: TextButton(
          onPressed: () => context.router.maybePop(),
          child: Text(
            'Cancel',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Constants.main),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_keyForm.currentState?.validate() ?? false) {
                if (widget.id != null) {
                  final data = ContactModel(
                    id: widget.id!,
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    email: _emailController.text,
                    dob: _currentDate?.toddMMyyyy,
                  );
                  _cubit.editData(data);
                } else {
                  final data = ContactModel(
                    id: Random().nextInt(1000).toString(),
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    email: _emailController.text,
                    dob: _currentDate?.toddMMyyyy,
                  );
                  _cubit.createData(data);
                }
              }
            },
            child: Text(
              'Save',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Constants.main),
            ),
          )
        ],
      ),
      body: BlocConsumer<AddContactCubit, AddContactState>(
        buildWhen: (old, current) => current != old,
        listener: (context, state) {
          state.dataDetail.whenOrNull(
            success: (data) {
              data as ContactDetailEntity;
              if (_currentData != data) {
                _firstNameController.text = data.firstName;
                _lastNameController.text = data.lastName;
                _emailController.text = data.email;
                _dateController.text = data.dob?.toddMMMMyyyy ?? '';
                _currentDate = data.dob;
                _currentData = data;
              }
            },
            failed: (msg, data, code) => dev.log('Error $msg'),
          );

          state.dataSubmit.whenOrNull(
            loading: (msg) => _loadingDialog.show(),
            success: (data) {
              _loadingDialog.dismiss();
              ShowNotify.success(msg: 'Success');
              context.router.maybePop();
            },
            failed: (msg, data, code) {
              _loadingDialog.dismiss();
              ShowNotify.error(msg: msg);
            },
          );
        },
        builder: (context, state) {
          return state.dataDetail.maybeWhen(
            loading: (msg) => const Center(child: CircularProgressIndicator()),
            orElse: () {
              return SingleChildScrollView(
                child: Form(
                  key: _keyForm,
                  child: Column(
                    children: [
                      SizedBox(height: 4.w),
                      CircleAvatar(
                        radius: 45.sp,
                        backgroundColor: Constants.main,
                      ),
                      SizedBox(height: 6.w),
                      Container(
                        width: double.infinity,
                        color: Colors.black12,
                        padding: EdgeInsets.all(4.w),
                        child: Text(
                          'Main Information',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(height: 1),
                      SizedBox(height: 2.w),
                      ItemList(
                          title: 'First Name',
                          controller: _firstNameController),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: const Divider(),
                      ),
                      ItemList(
                          title: 'Last Name', controller: _lastNameController),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: const Divider(),
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.black12,
                        padding: EdgeInsets.all(4.w),
                        child: Text(
                          'Sub Information',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(height: 1),
                      SizedBox(height: 2.w),
                      ItemList(
                        title: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: const Divider(),
                      ),
                      ItemList(
                        title: 'DOB',
                        controller: _dateController,
                        readOnly: true,
                        onTap: () async {
                          final data = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                            currentDate: _currentDate,
                          );
                          if (data != _currentDate) {
                            _currentDate = data;
                            _dateController.text =
                                _currentDate?.toddMMMMyyyy ?? '';
                          }
                        },
                        suffixIcon: const Icon(Icons.calendar_month),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: const Divider(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType? keyboardType;

  const ItemList({
    super.key,
    required this.title,
    required this.controller,
    this.suffixIcon,
    this.onTap,
    this.keyboardType,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 4.w),
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 7,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: suffixIcon,
            ),
            onTap: onTap,
            readOnly: readOnly,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Required';
              } else {
                return null;
              }
            },
          ),
        ),
        SizedBox(width: 4.w),
      ],
    );
  }
}
