import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';
import 'package:otloha_sah_flutter/data_source/remote/entites_service.dart';
import 'package:otloha_sah_flutter/data_source/remote/profiles_service.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/sections/users_list_section_state.dart';

class UsersListSectionCubit extends Cubit<UsersListSectionState> {
  UsersListSectionCubit() : super(UsersListSectionLoading());

  final ProfilesService _profilesService = ProfilesService();

  getMyFriends() async {
    emit(UsersListSectionLoading());
    List<BaseUser> users = await _profilesService.getMyFriends();
    users = users
        .map<BaseUser>((e) =>
            e.copyWith(relationships: e.relationships!.copyWith(friend: true)))
        .toList();
    emit(UsersListSectionLoaded(users: users));
  }

  getMyStydents() async {
    emit(UsersListSectionLoading());
    List<Student> users = await _profilesService.getMyStydents();
    emit(UsersListSectionLoaded(users: users));
  }

  getStudents() async {
    emit(UsersListSectionLoading());
    List<Student> users = await _profilesService.getStudents();
    emit(UsersListSectionLoaded(users: users));
  }

  getTeachers() async {
    emit(UsersListSectionLoading());
    List<Teacher> users = await _profilesService.getTeachers();
    emit(UsersListSectionLoaded(users: users));
  }
}

class EntitiesSectionCubit extends Cubit<EntitiesSectionState> {
  EntitiesSectionCubit() : super(EntitiesSectionLoading());

  final EntitiesServices _entitiesServices = EntitiesServices();

  getEntities() async {
    emit(EntitiesSectionLoading());
    List<Entity> entities = await _entitiesServices.getEntities();
    emit(EntitiesSectionLoaded(entities: entities));
  }
}
