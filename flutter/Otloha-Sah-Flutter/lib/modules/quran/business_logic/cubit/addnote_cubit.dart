import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/local/database/database/database.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../data_source/local/database/database_repository.dart';
import '../../../../data_source/models/notes/verse_note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'addnote_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitial());

  static AddNoteCubit get(context) => BlocProvider.of<AddNoteCubit>(context);

  TextDirection textDirection = TextDirection.rtl;

  final TextEditingController con = TextEditingController();

  get borderSide => const BorderSide(width: 1, color: AppColor.lightBlue);

  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide.none,
  );

  bool isEnable = true;
  bool isEditor = false;

  void setText(String val) {
    RegExp expEn = RegExp('[a-zA-Z]');

    if (expEn.hasMatch(val.substring(val.length - 1)) &&
        val.substring(val.length - 1) != ' ') {
      textDirection = TextDirection.ltr;
    } else if (val.substring(val.length - 1) != ' ' &&
        !expEn.hasMatch(val.substring(val.length - 1))) {
      textDirection = TextDirection.rtl;
    }
    emit(TextChange());
  }

  saveNote({required VerseNote verseNote}) async {
    var note = con.text;
    verseNote.copyWith(noteText: note);
    if (note.isNotEmpty) {
      if (isEditor) {
        await DatabaseRepository.instance.updateVerseNote(verseNote);
      } else {
        await DatabaseRepository.instance.insertVerseNote(verseNote);
      }

      emit(AddNoteSuccess());
    } else {}

    con.text = '';
  }

  void setEnable(bool isEdit) {
    isEnable = isEdit;
    emit(EnableChange());
  }

  void setIsEdit(bool isEdit, {VerseNote? verseNote}) {
    isEditor = isEdit;
    isEnable = !isEdit;
    if (isEditor) {
      con.text = verseNote?.noteText ?? '';
    }
    emit(EnableChange());
  }
}
