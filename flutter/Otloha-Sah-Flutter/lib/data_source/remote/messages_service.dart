import 'package:dio/dio.dart';
import 'package:file/file.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/api_base_helper.dart';
import '../../core/utils/constant/constants.dart';
import '../../core/widgets/toasts.dart';
import '../models/message_model/reply_request.dart';

class GetMessages {
  Future<Response?> getMessageListing({int? nextLink}) async {
    return await ApiBaseHelper().getHTTP(
      '/api/v1/recitations/messages/',
      queryParameters: {'page': nextLink ?? 1},
      dioTypes: DioTypes.authRequired,
    );
  }

  Future<Response?> messagesSent({int? nextLink}) async {
    return await ApiBaseHelper().getHTTP('/api/v1/recitations/messages/sent/',
        dioTypes: DioTypes.authRequired,
        queryParameters: {'page': nextLink ?? 1});
  }

  Future<Response?>? messgasRecieve({int? nextLink}) async {
    return await ApiBaseHelper().getHTTP(
        '/api/v1/recitations/messages/received/',
        dioTypes: DioTypes.authRequired,
        queryParameters: {'page': nextLink ?? 1});
  }

  Future<Response?> messageDetails(
      {required int messageId, required int recitationId}) async {
    return await ApiBaseHelper().getHTTP(
      '/api/v1/recitations/$recitationId/messages/$messageId/',
      dioTypes: DioTypes.authRequired,
    );
  }

  Future<Response?> recitationsDetails({required int recitationId}) async {
    return await ApiBaseHelper().getHTTP(
      '/api/v1/recitations/$recitationId',
      dioTypes: DioTypes.authRequired,
    );
  }

  Future<Response?> sendMessage({required int messageId}) async {
    return await ApiBaseHelper().postHTTP(
      '/api/v1/recitations/messages/$messageId/',
      {},
      DioTypes.authRequired,
    );
  }

  Future<Response?> sendRateRecitations(
      {required int id, required double rate}) async {
    FormData formData = FormData.fromMap({'rate': rate});
    return await ApiBaseHelper().postHTTP(
      '/api/v1/recitations/$id/rate/',
      formData,
      DioTypes.authRequired,
    );
  }

  Future<Response> createMessageReply({
    required int messageId,
    required List<int> versesIds,
    required File record,
    required String comment,
    required int verseId,
    required int positionFrom,
    required int posititionTo,
    required String errorType,
  }) async {
    FormData formData = FormData.fromMap({
      'record':
          await MultipartFile.fromFile(record.path, filename: record.basename),
      'verses_ids': versesIds,
      'comment': comment,
      'verseId': verseId,
      'position_from': positionFrom,
      'positition_to': posititionTo,
      'error_type': errorType,
    });
    return ApiBaseHelper().postHTTP(
      '/api/v1/recitations/messages/$messageId/replies/',
      formData,
      DioTypes.authRequired,
    );
  }

  Future<Response?> addToGeneral(int id) async {
    return _setStatusOfRecitation(
        id: id, status: Constants.toggleShowInGeneral);
  }

  Future<Response> deleteRecitations(int id) async {
    Response response = await ApiBaseHelper().deleteHTTP(
      '/api/v1/recitations/$id/',
      DioTypes.authRequired,
    );

    return response;
  }

  Future<Response?> markAsFinished(int id) async {
    return _setStatusOfRecitation(id: id, status: Constants.finish);
  }

  Future<Response?> markAsAccepted(
      {required int id, required int messageId}) async {
    return _setStatusOfRecitation(id: id, status: Constants.accept);
  }

  Future<Response?> markAsReject(
      {required int id, required int messageId}) async {
    return _setStatusOfRecitation(id: id, status: Constants.reject);
  }

  Future<Response?> markAsReport(
      {required int id, required int messageId}) async {
    return _setStatusOfRecitation(id: id, status: Constants.report);
  }

  Future<Response?> _setStatusOfRecitation({
    required int id,
    required String status,
  }) async {
    FormData formData = FormData.fromMap({'status': status});
    return ExceptionHandling.hanleToastException(() async {
      return await ApiBaseHelper().patchHTTP(
        '/api/v1/recitations/$id/',
        formData,
        DioTypes.authRequired,
      );
    }, 'doneMessage', false);
  }

  Future<Response> markAsRead({required int id, required int messageId}) async {
    Response response = await ApiBaseHelper().postHTTP(
      '/api/v1/recitations/$id/messages/$messageId/mark-as-read/',
      {},
      DioTypes.authRequired,
    );
    SuccessToast.toast(response.data['message']);
    return response;
  }

  Future<Response?> markAsRemarkable({required int id}) async {
    return _setStatusOfRecitation(
        id: id, status: Constants.markAsRemarkableAction);
  }

  Future<Response>? replyMessages(ReplyRequest replyRequest) async {
    return ApiBaseHelper().postPhotoHTTP(
      '/api/v1/recitations/${replyRequest.recitationId}/messages/${replyRequest.messageId}/replies/',
      await replyRequest.toMap(),
      DioTypes.authRequired,
    );
  }

  Future<Response>? sendMessageAsTeacher(int recitationId, int msgId) async {
    Response? response = await ApiBaseHelper().postHTTP(
      '/api/v1/recitations/$recitationId/messages/$msgId/send/',
      {},
      DioTypes.authRequired,
    );
    SuccessToast.toast(response.data['message']);
    return response;
  }
}
