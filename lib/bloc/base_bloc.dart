import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_basic_app/bloc/bloc.dart';
import 'package:news_basic_app/models/models.dart';
import 'package:news_basic_app/repositories/base_api_client.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  final BaseApiClient baseClient;

  BaseBloc({@required this.baseClient}) : super(OnEmpty()); //new bloc version ^6xx require super include initial state

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is FetchHeadline || event is FetchLatestArticle) {
      yield OnLoading();
      try {
        List<Article> article = List();
        if(event is FetchHeadline) {
          article = await baseClient.fetchArticle(1,1);
        } else {
          article = await baseClient.fetchArticle(2,1);
        }
        yield OnLoaded(obj: article);
      } catch (e) {
        print("Error: " + e.toString());
        yield OnError();
      }
    }
  }
}