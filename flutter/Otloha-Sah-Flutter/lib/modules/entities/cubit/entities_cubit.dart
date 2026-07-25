import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';

part 'entities_state.dart';

class EntitiesCubit extends Cubit<EntitiesState> {
  EntitiesCubit() : super(EntitiesInitial());

  getNextPage(int nextLink) async {
    Response? response;

    response = await ApiBaseHelper().getHTTP(
      '/api/v1/entities/',
      queryParameters: {'page': nextLink},
      dioTypes: DioTypes.authRequired,
    );
    return response;
  }
}
