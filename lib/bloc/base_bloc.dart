import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_basic_app/bloc/bloc.dart';
import 'package:news_basic_app/models/models.dart';
import 'package:news_basic_app/repositories/base_api_client.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  final BaseApiClient baseClient;

  BaseBloc({@required this.baseClient}) : assert(baseClient != null);

  @override
  BaseState get initialState => OnEmpty();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is OnLoading) {
      yield OnLoading();
      try {
        final List<Article> quote = await baseClient.fetchArticle(1,1);
        yield OnLoaded(obj: quote);
      } catch (_) {
        yield OnError();
      }
    }
  }
}