part of 'book_cubit.dart';

abstract class BookState {
  const BookState();
}

class BookInitial extends BookState {}

class BookFetched extends BookState {
  final List<Book>? books;
  final int selected;
  const BookFetched(this.books, this.selected);
}

class BookError extends BookState {
  final String error;
  const BookError(this.error);
}
