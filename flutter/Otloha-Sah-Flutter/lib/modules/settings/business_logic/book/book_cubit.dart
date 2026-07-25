import 'dart:convert';

import 'package:bloc/bloc.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/alert_dialog_full_screen.dart';
import 'package:get/get.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  List<Book>? books;
  int? selected;

  BookCubit() : super(BookInitial());

  changeIndex(int index) {
    selected = index;
    Get.dialog(
      const AlertDialogFullScreen(),
      barrierColor: AppColor.backdone,
    );
    QuranCacheRepository.setBookSelectedId(books![index].id!);

    // downLoadSettings[0].subTitle = books![index].name;
    QuranCacheRepository.setBookSelectedName(
        json.encode(books![index].name!.toJson()));

    emit(BookFetched(books, index));
  }

  fetchBooksList({String? qurey}) {
    try {
      int narrationId = QuranCacheRepository.narrationSelectedId;
      DataSource.instance
          .fetchBooksList(qurey: qurey, narrationId: narrationId)
          .then((value) async {
        if (value!.isNotEmpty) {
          int val = QuranCacheRepository.bookSelectedId;
          for (var element in value) {
            if (element.id == val) {
              val = value.indexOf(element);
              // downLoadSettings[0].subTitle = element.name;
              break;
            }
          }

          books = value;
          selected = val;

          emit(BookFetched(value, val));
        } else {
          emit(const BookError('Not Found Data'));
        }
      });
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
}
