import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart'
    as re;

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_base_helper.dart';
import '../../../../core/utils/constant/constants.dart';
import '../../../../data_source/data_source.dart';

import 'package:quran_widget_flutter/quran_widget_flutter.dart';

part 'corrected_recitations_state.dart';

class CorrectedRecitationsCubit extends Cubit<CorrectedRecitationsState> {
  CorrectedRecitationsCubit() : super(CorrectedRecitationsInitial());
  static CorrectedRecitationsCubit get(BuildContext context) =>
      BlocProvider.of(context);
  List<re.Recitation>? data;

  bool isTeacherData = false;

  getCorrectedRecitations() async {
    emit(RecitationsLoadingState());
    AppDataSource().getCorrectedRecitations()?.then(
      (value) async {
        data = value;
        emit(RecitationsSuccessState());

        if (data!.isEmpty) {
          emit(RecitationsErrorState(EmptyListException()));
        }
      },
    );
  }

  PagingController? _con;
  int indexPlay = -1;

  void setIndexPlay(int i) {
    indexPlay = i;
    emit(RecitationsSuccessState());
  }

  void reset() {
    emit(CorrectedRecitationsInitial());
  }

  fetchNextPage(int next) async {
    Response? response = await ApiBaseHelper().getHTTP(
      '/api/v1/recitations/?my_evaluated_recitations=true',
      queryParameters: {'page': next},
      dioTypes: DioTypes.authRequired,
    );

    if (response != null &&
        response.statusCode == 200 &&
        response.data['results'] != null &&
        (response.data['results'] as List).isNotEmpty) {
      for (var element in (response.data['results'] as List)) {
        try {
          element['chapterName'] = (await DataSource.instance.fetchChapterById(
                  int.parse(element['chapter_id'] ?? '0'),
                  element['narration_id']))
              ?.name;

          element['narrationName'] = (await DataSource.instance
                  .fetchNarrationById(
                      int.parse(element['narration_id'] ?? '0')))
              ?.name;
        } catch (e) {
          print('Error in Map Statement $e');
        }
      }
    }
    return response;
  }

  void deleteMessage(int index) {
    _con?.itemList!.removeAt(index);
    emit(RemoveUserRecitationState());
  }

  void getPagingController(PagingController con) {
    _con = con;
  }

  void setIsTeacher(bool isTeacherData) {
    this.isTeacherData = isTeacherData;
  }
}
