import 'package:otloha_sah_flutter/data_source/models/translation/translatable.dart';
import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_profile.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import 'package:quran_widget_flutter/data_source/repository/narration_repository.dart';
import 'package:quran_widget_flutter/model/narration.dart';
import '../core/error/exceptions.dart';
import 'cache_helper.dart';
import 'models/message_model/recitation.dart';
import 'models/progress/progress_model.dart';
import 'models/progress/statistics_model.dart';
import 'remote/progress_service.dart';
import 'remote/room_services.dart';
import 'local/database/database_repository.dart';

import 'models/message_model/reply_request.dart';
import 'remote/recitation_services.dart';
import 'remote/messages_service.dart';
import 'remote/user_services.dart';

import 'remote/auth_services.dart';

class AppDataSource {
  final AuthApi _authApi = AuthApi();
  final UserServices _userServices = UserServices();
  final GetMessages _getMessages = GetMessages();
  final RoomServices _roomServices = RoomServices();
  final DatabaseRepository _databaseRepository = DatabaseRepository();
  final UserRecitationApi _userRecitationApi = UserRecitationApi();
  final ProgressService _progressService = ProgressService();
  final NarrationRepository _narrationRepository = NarrationRepository();

  saveUserReciataion({required userRecitation}) =>
      _userRecitationApi.saveUserReciataion(userRecitation: userRecitation);

  Future<Map<String, dynamic>>? getUserReciataions(int page, int userId) =>
      _userRecitationApi.getUserReciataions(page, userId);

  Future<Response?> roomListing() => _roomServices.roomListing();

  Future<List<Recitation>?>? getGeneraBoXMessage() =>
      _userRecitationApi.getRecitation('show_in_general');
  Future<List<Recitation>?>? showInRemarkable() =>
      _userRecitationApi.getRecitation('show_in_remarkable');
  Future<List<Recitation>?>? teacherRecitations() =>
      _userRecitationApi.getRecitation('is_teacher_recitation');
  Future<List<Recitation>?>? getCorrectedRecitations() =>
      _userRecitationApi.getRecitation('my_evaluated_recitations');

  Future<List<User>?>? getTeacher(int page) => _userServices.getTeacher(page);

  Future<List<User>?> getStudents(int nextLink) =>
      _userServices.getStudents(nextLink);

  Future<Response?>? sendMessage(int id, List<int> users) =>
      _userServices.sendMessage(id, users);

  Future<Recitation?> recitationDetails(int recitationId) =>
      _userRecitationApi.recitationDetails(recitationId);

  // Verse Liked

  findAllVerseLikeds(int userId) =>
      _databaseRepository.findAllVerseLikeds(userId);

  findVerseLikedById(int id, int userId) =>
      _databaseRepository.findVerseLikedById(id, userId);

  insertVerseLiked(verseLiked) =>
      _databaseRepository.insertVerseLiked(verseLiked);

  updateVerseLiked(verseLiked) =>
      _databaseRepository.updateVerseLiked(verseLiked);

  deleteVerseLiked(int id) => _databaseRepository.deleteVerseLiked(id);

  // Verse Note
  findAllVerseNotes(int userId) =>
      _databaseRepository.findAllVerseNotes(userId);

  findVerseNoteById(int id) => _databaseRepository.findVerseNoteById(id);

  insertVerseNote(verseNote) => _databaseRepository.insertVerseNote(verseNote);

  updateVerseNote(verseNote) => _databaseRepository.updateVerseNote(verseNote);

  deleteVerseNote(int id) => _databaseRepository.deleteVerseNote(id);

  // Page Marked
  findAllPageMarkeds(int userId) =>
      _databaseRepository.findAllPageMarkeds(userId);

  // findPageMarkedById(int id, int userId) =>
  //     _databaseRepository.fetchUserRecitations(id, userId);

  insertPageMarked(pageMarked) =>
      _databaseRepository.insertPageMarked(pageMarked);

  updatePageMarked(pageMarked) =>
      _databaseRepository.updatePageMarked(pageMarked);

  deletePageMarked(
    int id,
  ) =>
      _databaseRepository.deletePageMarked(id);

  Future<Response> markAsFavTeacher({required int? id}) async {
    return _userServices.markAsFavTeacher(id: id);
  }

  changePassword(
      {required oldPassword, required newPassword, required confirmPassword}) {
    return _userServices.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword);
  }

  updateEmail({required email, required password}) {
    return _userServices.updateEmail(email: email, password: password);
  }

  updatePhone({required phone, required password}) {
    return _userServices.updatePhone(phone: phone, password: password);
  }

  updateProfile({required email, required password}) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  registerAsATeacher(data) {
    return _userServices.registerAsATeacher(data);
  }

  getMessageListing() {
    return _getMessages.getMessageListing();
  }

  messagesSent() {
    return _getMessages.messagesSent();
  }

  messagesRecieve() {
    return _getMessages.messgasRecieve();
  }

  Future<Response<dynamic>?> messageDetails(
      {required int messageId, required int recitationId}) {
    return _getMessages.messageDetails(
        messageId: messageId, recitationId: recitationId);
  }

  sendRecitationsMessage({required int messageId}) async {
    return _getMessages.sendMessage(messageId: messageId);
  }

  createMessageReply({
    required int messageId,
    required List<int> versesIds,
    required File record,
    required String comment,
    required int verseId,
    required int positionFrom,
    required int positionTo,
    required String errorType,
  }) async {
    return _getMessages.createMessageReply(
        messageId: messageId,
        versesIds: versesIds,
        record: record,
        comment: comment,
        verseId: verseId,
        positionFrom: positionFrom,
        posititionTo: positionTo,
        errorType: errorType);
  }

  addToGeneral(int id) async {
    return _getMessages.addToGeneral(id);
  }

  deleteRecitations(int id) {
    return _getMessages.deleteRecitations(id);
  }

  markAsFinished(int id) async {
    return _getMessages.markAsFinished(id);
  }

  markAsAccepted({required int id, required int messageId}) {
    return _getMessages.markAsAccepted(id: id, messageId: messageId);
  }

  markAsRead({required int id, required int messageId}) {
    return _getMessages.markAsRead(id: id, messageId: messageId);
  }

  markAsRemarkable({required int id, required int messageId}) async {
    return _getMessages.markAsRemarkable(id: id);
  }

  replyMessages(ReplyRequest replyRequest) async {
    return _getMessages.replyMessages(replyRequest);
  }

  createRoom(int id, int userId) async {
    return _roomServices.createRoom(id, userId);
  }

  Future<Response> finishEvaluation(
          {required Map<String, dynamic> data, required int id}) =>
      _roomServices.finishEvaluation(data: data, id: id);

  sendMessageAsTeacher(int recitationId, int msgId) {
    return _getMessages.sendMessageAsTeacher(recitationId, msgId);
  }

  Future<User> myProfile() async => await _userServices.myProfile();

  Future<BaseProfile> myProfileV2() async => await _userServices.myProfileV2();

  Future<User> userProfile(int id) => _userServices.userProfile(id);

  userLogIn({email, password}) =>
      _authApi.userLogIn(email: email, password: password);

  logOut({String? auth}) => _authApi.logOut(auth: auth);

  passwordReset({required String email}) =>
      _authApi.passwordReset(email: email);

  passwordResetConfirm({uid, token, newPassword1, newPassword2}) =>
      _authApi.passwordResetConfirm(
          uid: uid,
          newPassword1: newPassword1,
          newPassword2: newPassword2,
          token: token);

  passwordChange({oldPassword, newPassword1, newPassword2}) =>
      _authApi.passwordChange(
          old_password: oldPassword,
          new_password2: newPassword2,
          new_password1: newPassword1);

  refreshToken() => _authApi.refreshToken();

  resendOTP() => _authApi.resendOTP();

  verifyOTP(String code) => _authApi.verifyOTP(code);

  userRegister(
          {email, username, password1, password2, birthdate, phone, gender}) =>
      _authApi.userRegister(
          email: email,
          birthdate: birthdate,
          gender: gender,
          password1: password1,
          password2: password2,
          phone: phone,
          username: username);

  Future<User?> getProfile() => _userServices.myProfile();

  Future<StatisticsModel> getStatistics(int narrationId) async {
    StatisticsModel statisticsModel;
    try {
      statisticsModel = await _progressService.getStatistics(narrationId);
      await CacheHelper.saveData(
          key: 'statistics', value: statisticsModel.toJson());
    } on NetworkConnectionException catch (_) {
      statisticsModel = StatisticsModel.fromJson(
          await CacheHelper.getData(key: 'statistics'));
    }
    return statisticsModel;
  }

  Future<ProgressModel> getProgress(int narrationId, int chapterId) async {
    ProgressModel progressModel;
    try {
      progressModel =
          await _progressService.getProgress(narrationId, chapterId);
      await CacheHelper.saveData(
          key: 'progress_chapter_$chapterId/narration_$narrationId',
          value: progressModel.toJson());
    } on NetworkConnectionException catch (_) {
      progressModel = ProgressModel.fromJson(await CacheHelper.getData(
          key: 'progress_chapter_$chapterId/narration_$narrationId'));
    }
    return progressModel;
  }

  Future<String> getNarrationNameById(String id) async {
    String? name = CacheHelper.getData(key: 'narration_$id');
    if (name == null) {
      Narration? narration =
          await _narrationRepository.fetchNarrationById(int.parse(id));
      if (narration != null) {
        name = narration.name.translate();
        await CacheHelper.saveData(key: 'narration_$id', value: name);
      }
    }
    return name ?? '';
  }
}
