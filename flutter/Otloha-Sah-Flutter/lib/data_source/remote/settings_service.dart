import '../../core/network/api_base_helper.dart';
import '../models/settings/settings_group_model.dart';

class SettingsApi {
  final api = ApiBaseHelper();
  Future<List<SettingsGroupModel>> getSettingList(String group) async {
    final response = await api.getHTTP(
      '/api/v1/settings/$group',
      dioTypes: DioTypes.authRequired,
    );
    return (response!.data as List)
        .map<SettingsGroupModel>((e) => SettingsGroupModel.fromMap(e))
        .toList();
  }

  Future<void> updateSettings({
    required String group,
    required String key,
    required int value,
  }) async {
    await api.putHTTP(
      '/api/v1/settings/$group/$key/',
      {'value': value},
      DioTypes.authRequired,
    );
  }

  Future<void> resetSettings(String group) async {
    await api.postHTTP(
      '/api/v1/settings/$group/reset/',
      {},
      DioTypes.authRequired,
    );
  }
}
