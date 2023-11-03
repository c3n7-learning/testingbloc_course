import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:testingbloc_course/bloc/bloc_actions.dart';
import 'package:testingbloc_course/bloc/person.dart';
import 'package:testingbloc_course/bloc/persons_bloc.dart';

const mockedPersons1 = [
  Person(
    name: 'John Doe',
    age: 20,
  ),
  Person(
    name: 'Jane Doe',
    age: 31,
  ),
  Person(
    name: 'Jean Doe',
    age: 25,
  ),
];

const mockedPersons2 = [
  Person(
    name: 'Juma Musa',
    age: 20,
  ),
  Person(
    name: 'Hamisi Khadija',
    age: 31,
  ),
  Person(
    name: 'Mutua Kimani',
    age: 25,
  )
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
    Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) =>
    Future.value(mockedPersons2);

void main() {
  group('Testing Bloc', () {
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test initial state',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    blocTest<PersonsBloc, FetchResult?>(
      'Mock retreiving persons from first iterable',
      build: () => bloc,
      act: (bloc) {
        // Without cached
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_1',
            loader: mockGetPersons1,
          ),
        );

        // Now with cached
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_1',
            loader: mockGetPersons1,
          ),
        );
      },
      expect: () => [
        // Expect 2 results const we sent two actions
        const FetchResult(
          persons: mockedPersons1,
          isRetreivedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPersons1,
          isRetreivedFromCache: true,
        ),
      ],
    );

    blocTest<PersonsBloc, FetchResult?>(
      'Mock retreiving persons from second iterable',
      build: () => bloc,
      act: (bloc) {
        // Without cached
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_2',
            loader: mockGetPersons2,
          ),
        );

        // Now with cached
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_2',
            loader: mockGetPersons2,
          ),
        );
      },
      expect: () => [
        // Expect 2 results const we sent two actions
        const FetchResult(
          persons: mockedPersons2,
          isRetreivedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPersons2,
          isRetreivedFromCache: true,
        ),
      ],
    );
  });
}
