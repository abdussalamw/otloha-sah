import 'package:dio/dio.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/block.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/invitation.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/invitation_response.dart';

enum InvitationType {
  friendRequest,
  supervisionRequest,
  joinEntityRequest,
  joinKhatmaRequest,
  entityMergeRequest;

  @override
  String toString() {
    switch (this) {
      case InvitationType.friendRequest:
        return 'friend_request';
      case InvitationType.supervisionRequest:
        return 'supervision_request';
      case InvitationType.joinEntityRequest:
        return 'join_entity_request';
      case InvitationType.joinKhatmaRequest:
        return 'join_khatma_request';
      case InvitationType.entityMergeRequest:
        return 'entity_merge_request';
    }
  }
}

enum InvitationResponseType {
  accepted,
  pending,
  rejected,
  deleted;

  @override
  String toString() {
    switch (this) {
      case InvitationResponseType.accepted:
        return 'accepted';
      case InvitationResponseType.pending:
        return 'pending';
      case InvitationResponseType.rejected:
        return 'rejected';
      case InvitationResponseType.deleted:
        return 'deleted';
    }
  }
}

class InvitationsService {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<Invitation> createInvitation({
    required InvitationType invitationType,
    required String requesteeType,
    required int requesteeId,
  }) async {
    print({
      'invitation_type': invitationType.toString(),
      'requestee_type': requesteeType,
      'requestee': requesteeId,
    });
    Response response = await _apiBaseHelper.postHTTP(
      '/api/v1/invitations/request/create/',
      {
        'invitation_type': invitationType.toString(),
        'requestee_type': requesteeType,
        'requestee': requesteeId.toString(),
      },
      DioTypes.authRequired,
    );

    return Invitation.fromMap(response.data);
  }

  Future<InvitationResponse> createInvitationResponse({
    required InvitationResponseType invitationResponseType,
    required int invitationId,
  }) async {
    Response response = await _apiBaseHelper.postHTTP(
      '/api/v1/invitations/response/$invitationId/',
      {
        'status': invitationResponseType.toString(),
      },
      DioTypes.authRequired,
    );

    return InvitationResponse.fromMap(response.data);
  }

  Future<Block> createBlock({
    required int userId,
    required String blockedType,
  }) async {
    Response response = await _apiBaseHelper.postHTTP(
      '/api/v1/invitations/block/create/',
      {
        'blocked': userId,
        'blocked_type': blockedType,
      },
      DioTypes.authRequired,
    );
    return Block.fromMap(response.data);
  }

  Future<Response> respond({
    required int requesterId,
    required InvitationType invitationType,
    required String status,
  }) async {
    return await _apiBaseHelper.postHTTP(
      '/api/v1/invitations/response/',
      {
        'requester': requesterId,
        'invitation_type': invitationType.toString(),
        'status': status,
      },
      DioTypes.authRequired,
    );
  }

  Future<Response> respondById({
    required int invitationId,
    required String status,
  }) async {
    return await _apiBaseHelper.postHTTP(
      '/api/v1/invitations/response/$invitationId/',
      {
        'status': status,
      },
      DioTypes.authRequired,
    );
  }

  Future<void> deleteBlock({
    required int blockId,
  }) async {
    await _apiBaseHelper.deleteHTTP(
      '/api/v1/invitations/block/$blockId/delete/',
      DioTypes.authRequired,
    );
  }
}
