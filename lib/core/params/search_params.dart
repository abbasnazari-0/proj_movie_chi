class SearchParamsQuery {
  final String? query;
  final int? count;
  final String? type;
  final String? zhanner;
  final String? imdb;
  final String? year;
  final bool? advancedQuery;
  final bool? isDebouncer;

  SearchParamsQuery({
    required this.query,
    required this.count,
    this.type,
    this.zhanner,
    this.imdb,
    this.year,
    this.advancedQuery,
    this.isDebouncer,
  });
}
