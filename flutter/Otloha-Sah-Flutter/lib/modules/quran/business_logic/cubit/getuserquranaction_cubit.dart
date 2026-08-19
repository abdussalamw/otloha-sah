import 'package:otloha_sah_flutter/data_source/local/database/database/database.dart';
import 'package:otloha_sah_flutter/data_source/models/favorite_pages/favorite_pages.dart';

import '../../../../data_source/user_services_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_source/local/database/database_repository.dart';

part 'getuserquranaction_state.dart';

class GetUserQuranActionCubit extends Cubit<GetUserQuranActionState> {
  DatabaseRepository databaseRepository;

  GetUserQuranActionCubit(
    this.databaseRepository,
  ) : super(GetUserQuranActionInitial());

  static GetUserQuranActionCubit get(context) =>
      BlocProvider.of<GetUserQuranActionCubit>(context);
  List<VerseNote> verseNote = [];
  List<VerseNote> searchedList = [];

  Future<void> search(value) async {
    emit(NoteSearchLoading());
    searchedList = verseNote
        .where((i) =>
            i.noteText.contains(value) || i.textFristVerse.contains(value))
        .toList();
    if (searchedList.isNotEmpty) {
      emit(NoteSearched());
    } else {
      emit(NoteSearchError());
    }
  }

  Future findAllVerseNotes() async {
    databaseRepository
        .findAllVerseNotes(
            (await UserDataServices.instance.getUserData())?.id ?? 0)!
        .then((value) {
      if (value != null && value.isNotEmpty) {
        verseNote = value;

        emit(GetUserQuranActionNotes(verses: value));
      } else {
        emit(const GetUserQuranActionError(error: 'Not Found Items'));
      }
    });
  }

  Future<void> updateVerseNotes(VerseNote verseNote, String textUpdated) async {
    // verseNote.noteText = textUpdated;

    /// emit(EditeUpdateUserQuranActionNotes());
    databaseRepository.updateVerseNote(verseNote)!.then((value) {
      if (value != null && value.isNotEmpty) {
        ///findAllVerseNotes();

        emit(UpdateUserQuranActionNotes());
      } else {
        emit(const GetUserQuranActionError(error: 'Not Found Items'));
      }
    });
  }

  Future deleteVerseNotes(int? id) async {
    try {
      if (id != null) {
        await databaseRepository.deleteVerseNote(id).then((value) {
          if (value > 0) {
            findAllVerseNotes();

            emit(DeleteUserQuranActionNotes());
          } else {
            emit(const GetUserQuranActionError(error: 'Not Found Items'));
          }
        });
      } else {}
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future deleteVerseLiked(int id) async {
    databaseRepository.deleteVerseLiked(id).then((value) {
      findAllVerseLikeds();
      if (value > 0) {
        emit(DeleteUserQuranActionLike());
      } else {
        emit(const GetUserQuranActionError(error: 'Not Found Items'));
      }
    });
  }

  bool isUpdateNote = false;

  findAllVerseLikeds() async {
    int user = (await UserDataServices.instance.getUserData())?.id ?? 0;
    databaseRepository.findAllVerseLikeds(user)!.then((value) {
      if (value != null && value!.isNotEmpty) {
        emit(GetUserQuranActionLikeds(verses: value));
      } else {
        emit(const GetUserQuranActionError(error: 'Not Found Items'));
      }
    });
  }

  findAllPageMarkeds() async {
    int user = (await UserDataServices.instance.getUserData())?.id ?? 0;
    databaseRepository.findAllPageMarkeds(user)!.then((value) {
      if (value != null && value!.isNotEmpty) {
        emit(GetUserQuranActionMarks(pages: value));
      } else {
        emit(const GetUserQuranActionError(error: 'Not Found Items'));
      }
    });
  }

  deleteVerseBookMark(int id) {
    databaseRepository.deletePageMarked(id)!.then((value) {
      findAllPageMarkeds();
      if (value != null && value > 0) {
        emit(DeleteUserQuranActionBookMark());
      } else {
        emit(DeleteUserQuranActionBookMarkError());
      }
    });
  }

  undoDeleteNote(VerseNote verseNote) async {
    await databaseRepository.insertVerseNote(verseNote);
  }

  void undoDeleteMark(FavoritePage pageMarked) async {
    await databaseRepository.insertPageMarked(pageMarked);
  }

  void undoDeleteVerseLiked(FavoriteVerse verseLiked) async {
    await databaseRepository.insertVerseLiked(verseLiked);
  }
}
