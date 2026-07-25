import 'package:equatable/equatable.dart';

abstract class MainChannelState extends Equatable {}

class MainChannelInitial implements MainChannelState {
  @override
  List<Object> get props => [];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class MainChannelUpdateState implements MainChannelState {
  final int data;

  MainChannelUpdateState(this.data);
  @override
  List<Object> get props => [data];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
