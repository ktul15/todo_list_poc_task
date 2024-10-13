import 'package:bloc/bloc.dart';
import 'package:todo_list_poc_task/core/utils/preference_keys.dart';
import 'package:todo_list_poc_task/feature/profile/presentation/bloc/profile_events.dart';
import 'package:todo_list_poc_task/feature/profile/presentation/bloc/profile_state.dart';

import '../../../../main.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileState> {
  ProfileBloc(super.initialState) {
    on<ProfileImageSelected>(_onProfileImageSelected);
    on<ProfileNameChanged>(_onProfileNameChanged);
    on<ProfileEmailChanged>(_onProfileEmailChanged);
    on<ProfileNameUpdated>(_onProfileNameUpdated);
    on<ProfileEmailUpdated>(_onProfileEmailUpdated);
  }

  void _onProfileImageSelected(ProfileImageSelected event, Emitter emit) async {
    await prefs?.setString(PreferenceKeys.profileImage, event.image);

    emit(
      state.copyWith(
        image: event.image,
      ),
    );
  }

  void _onProfileNameUpdated(ProfileNameUpdated event, Emitter emit) async {
    await prefs?.setString(PreferenceKeys.userName, event.name);

    emit(
      state.copyWith(
        userName: event.name,
      ),
    );
  }

  void _onProfileEmailUpdated(ProfileEmailUpdated event, Emitter emit) async {
    await prefs?.setString(PreferenceKeys.email, event.email);

    emit(
      state.copyWith(
        email: event.email,
      ),
    );
  }

  void _onProfileNameChanged(ProfileNameChanged event, Emitter emit) async {
    emit(
      state.copyWith(
        userName: event.name,
      ),
    );
  }

  void _onProfileEmailChanged(ProfileEmailChanged event, Emitter emit) async {
    emit(
      state.copyWith(
        email: event.email,
      ),
    );
  }
}
