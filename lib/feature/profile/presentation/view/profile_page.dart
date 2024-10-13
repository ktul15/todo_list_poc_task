import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_poc_task/core/utils/preference_keys.dart';
import 'package:todo_list_poc_task/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:todo_list_poc_task/feature/profile/presentation/bloc/profile_state.dart';
import 'package:todo_list_poc_task/feature/profile/presentation/view/profile_view.dart';

import '../../../../main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("asdf: ${prefs?.getString(PreferenceKeys.profileImage)}");
    return BlocProvider(
      create: (_) => ProfileBloc(
        ProfileState(
          isLoading: true,
          userName: prefs?.getString(PreferenceKeys.userName) ?? "",
          image: prefs?.getString(PreferenceKeys.profileImage) ?? "",
          email: prefs?.getString(PreferenceKeys.email) ?? "",
        ),
      ),
      child: ProfileView(),
    );
  }
}
