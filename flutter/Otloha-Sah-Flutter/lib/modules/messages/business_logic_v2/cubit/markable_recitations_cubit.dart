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

part 'markable_recitations_state.dart';

class MarkableRecitationsCubit extends Cubit<MarkableRecitationsState> {
  MarkableRecitationsCubit() : super(MarkableRecitationsInitial());
  static MarkableRecitationsCubit get(BuildContext context) =>
      BlocProvider.of(context);
  List<re.Recitation>? data;

  bool isTeacherData = false;

  getMarkableRecitations() async {
    emit(RecitationsLoadingState());
    if (isTeacherData) {
      AppDataSource().teacherRecitations()?.then(
        (value) async {
          data = value;
          emit(RecitationsSuccessState());
          if (data!.isEmpty) {
            emit(RecitationsErrorState(EmptyListException()));
          }
        },
      ).catchError((error) {
        emit(RecitationsErrorState(error));
      });
    } else {
      AppDataSource().showInRemarkable()?.then(
        (value) async {
          data = value;
          emit(RecitationsSuccessState());
          if (data!.isEmpty) {
            emit(RecitationsErrorState(EmptyListException()));
          }
        },
      ).catchError((error) {
        emit(RecitationsErrorState(error));
      });
    }
  }

  PagingController? _con;
  int indexPlay = -1;

  void setIndexPlay(int i) {
    indexPlay = i;
    emit(RecitationsSuccessState());
  }

  void reset() {
    emit(MarkableRecitationsInitial());
  }

  fetchNextPage(int next) async {
    String type =
        isTeacherData ? 'is_teacher_recitation' : 'show_in_remarkable';
    Response? response = await ApiBaseHelper().getHTTP(
      '/api/v1/recitations/?$type=true',
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
