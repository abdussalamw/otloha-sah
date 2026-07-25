import 'package:equatable/equatable.dart';
import '../../../../data_source/models/settings/settings_group_model.dart';

abstract class PrivacyGroupsState extends Equatable {}

class PrivacyGroupsInitial extends PrivacyGroupsState {
  @override
  List<Object> get props => [];
}

class PrivacyGroupsLoading extends PrivacyGroupsState {
  @override
  List<Object> get props => [];
}

class PrivacyGroupsLoaded extends PrivacyGroupsState {
  final List<SettingsGroupModel> privacyGroups;

  PrivacyGroupsLoaded(this.privacyGroups);

  @override
  List<Object> get props => [privacyGroups];
}

class PrivacyGroupsUpdated extends PrivacyGroupsState {
  final List<SettingsGroupModel> privacyGroups;

  PrivacyGroupsUpdated(this.privacyGroups);

  @override
  List<Object> get props => [privacyGroups];
}

class PrivacyGroupsError extends PrivacyGroupsState {
  final String message;

  PrivacyGroupsError(this.message);

  @override
  List<Object> get props => [message];
}

class ChangePrivacyGroupState extends Equatable {
  final SettingsGroupModel privacyGroup;

  const ChangePrivacyGroupState(this.privacyGroup);
  @override
  List<Object> get props => [privacyGroup];
}
