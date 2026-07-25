import '../../../../data_source/models/message_model/message_model.dart';

abstract class EvaluationFormState {}

class EvaluationFormInitial extends EvaluationFormState {}

class SelectErrorTextState extends EvaluationFormState {}

class SelectFaultTypeState extends EvaluationFormState {}

class SelectRecordPathState extends EvaluationFormState {}

class EvaluationFormLoadingSate extends EvaluationFormState {}

class EvaluationFormSubmitState extends EvaluationFormState {}

class EditEvaluationFormState extends EvaluationFormState {
  final MessageModel evaluationMessage;

  EditEvaluationFormState(this.evaluationMessage);
}
