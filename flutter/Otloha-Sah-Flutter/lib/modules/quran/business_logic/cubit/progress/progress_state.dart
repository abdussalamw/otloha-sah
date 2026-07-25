import 'package:equatable/equatable.dart';
import '../../../../../data_source/models/progress/progress_model.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final ProgressModel progress;

  const ProgressLoaded({
    required this.progress,
  });

  @override
  List<Object> get props => [progress];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

