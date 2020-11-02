import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object> get props => [];
}

class OnEmpty extends BaseState {}

class OnLoading extends BaseState {}

class OnLoaded extends BaseState {
  final Object obj;

  const OnLoaded({@required this.obj}) : assert(obj != null);

  @override
  List<Object> get props => [obj];
}

class OnError extends BaseState {}