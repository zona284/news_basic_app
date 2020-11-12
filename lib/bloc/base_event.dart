import 'package:equatable/equatable.dart';

abstract class BaseEvent extends Equatable {
  const BaseEvent();
}

class FetchHeadline extends BaseEvent {
  const FetchHeadline();

  @override
  List<Object> get props => [];
}

class FetchLatestArticle extends BaseEvent {
  const FetchLatestArticle();

  @override
  List<Object> get props => [];
}