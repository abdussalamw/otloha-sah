import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data_source/models/settings/settings_group_model.dart';
import '../../../../data_source/remote/settings_service.dart';
import 'privacy_groups_state.dart';

class PrivacyGroupsCubit extends Cubit<PrivacyGroupsState> {
  final SettingsApi _privacyGroupsRepository = SettingsApi();

  PrivacyGroupsCubit() : super(PrivacyGroupsInitial());

  List<SettingsGroupModel> privacyGroups = [];

  static PrivacyGroupsCubit get(context) => BlocProvider.of(context);
  Future<void> getPrivacyGroups(String group) async {
    emit(PrivacyGroupsLoading());
    try {
      privacyGroups = await _privacyGroupsRepository.getSettingList(group);
      emit(PrivacyGroupsLoaded(privacyGroups));
    } on Exception catch (e) {
      emit(PrivacyGroupsError(e.toString()));
    }
  }

  Future<void> updatePrivacyGroup(
      SettingsGroupModel privacyGroup, int index) async {
    try {
      await _privacyGroupsRepository.updateSettings(
        group: 'privacy',
        key: privacyGroup.key,
        value: !privacyGroup.value ? 1 : 0,
      );
      privacyGroups[index] = privacyGroup.copyWith(value: !privacyGroup.value);
      emit(PrivacyGroupsLoading());
      emit(PrivacyGroupsLoaded(privacyGroups));
    } on Exception catch (e) {
      emit(PrivacyGroupsError(e.toString()));
    }
  }
}
