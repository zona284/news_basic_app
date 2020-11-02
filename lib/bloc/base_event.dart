import 'package:equatable/equatable.dart';

abstract class BaseEvent extends Equatable {
  const BaseEvent();
}

class FetchModel extends BaseEvent {
  const FetchModel();

  @override
  List<Object> get props => [];
}