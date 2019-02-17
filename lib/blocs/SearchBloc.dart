import 'package:github_search/models/SearchResult.dart';
import 'package:github_search/services/data/GithubService.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  GithubService _service = new GithubService();

  final _searchController = new BehaviorSubject<String>();
  Observable<String> get searchFlux => _searchController.stream;
  Sink<String> get searchEvent => _searchController.sink;

  Observable<SearchResult> apiResultFlux;

  SearchBloc() {
    apiResultFlux = searchFlux
        .distinct()
        .where((valor) => valor.length > 2)
        .debounce(Duration(milliseconds: 500))
        .asyncMap(_service.search)
        .switchMap((valor) => Observable.just(valor));
  }

  void dispose() {
    _searchController?.close();
  }
}
