import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../search_households/household_global_search.dart';
import '../search_households/search_households.dart';
import '../search_individual.dart/individual_global_search.dart';
import '../search_tag/search_by_tag.dart';

class SearchBlocWrapper implements StateStreamableSource<Object?> {
  final SearchHouseholdsBloc searchHouseholdsBloc;
  final TagSearchBloc tagSearchBloc;
  final IndividualGlobalSearchBloc individualGlobalSearchBloc;
  final HouseHoldGlobalSearchBloc houseHoldGlobalSearchBloc;

  SearchBlocWrapper(
      {required this.searchHouseholdsBloc,
      required this.tagSearchBloc,
      required this.individualGlobalSearchBloc,
      required this.houseHoldGlobalSearchBloc});

  Stream<SearchHouseholdsState> get stateChanges =>
      StreamGroup.merge<SearchHouseholdsState>([
        searchHouseholdsBloc.stream,
        individualGlobalSearchBloc.stream,
        tagSearchBloc.stream,
        houseHoldGlobalSearchBloc.stream,
      ]);

  void dispatch(SearchHouseholdsEvent event) {
    if (event is IndividualGlobalSearchEvent) {
      individualGlobalSearchBloc.add(event);
    } else if (event is HouseHoldGlobalSearchEvent) {
      houseHoldGlobalSearchBloc.add(event);
    } else if (event is SearchHouseholdsByTagEvent) {
      tagSearchBloc.add(event);
    } else {
      searchHouseholdsBloc.add(event);
    }
  }

  void clearEvent() {
    individualGlobalSearchBloc.add(const SearchHouseholdsEvent.clear());
    tagSearchBloc.add(const SearchHouseholdsEvent.clear());
    searchHouseholdsBloc.add(const SearchHouseholdsEvent.clear());
    houseHoldGlobalSearchBloc.add(const SearchHouseholdsEvent.clear());
  }

  @override
  SearchHouseholdsState get state => searchHouseholdsBloc.state;

  @override
  Stream<SearchHouseholdsState> get stream => stateChanges;

  @override
  FutureOr<void> close() {
    searchHouseholdsBloc.close();
    individualGlobalSearchBloc.close();
    houseHoldGlobalSearchBloc.close();
    tagSearchBloc.close();
  }

  @override
  bool get isClosed =>
      searchHouseholdsBloc.isClosed &&
      individualGlobalSearchBloc.isClosed &&
      houseHoldGlobalSearchBloc.isClosed &&
      tagSearchBloc.isClosed;
}
