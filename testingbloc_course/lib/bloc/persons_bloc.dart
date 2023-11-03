import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/bloc/bloc_actions.dart';
import 'package:testingbloc_course/bloc/person.dart';

extension IsEqualIgnoreOrdering<T> on Iterable<T> {
  bool isEqualToIgnoreOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetreivedFromCache;

  const FetchResult(
      {required this.persons, required this.isRetreivedFromCache});

  @override
  String toString() =>
      'FetchResult (isRetreivedFromCache = $isRetreivedFromCache, persons = $persons)';

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoreOrdering(other.persons) &&
      isRetreivedFromCache == other.isRetreivedFromCache;

  @override
  int get hashCode => Object.hash(persons, isRetreivedFromCache);
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonsAction>(
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          final cachedPersons = _cache[url]!;
          final result = FetchResult(
            persons: cachedPersons,
            isRetreivedFromCache: true,
          );

          emit(result);
        } else {
          final persons = await event.loader(url);

          _cache[url] = persons;
          final result = FetchResult(
            persons: persons,
            isRetreivedFromCache: false,
          );

          emit(result);
        }
      },
    );
  }
}
