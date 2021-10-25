import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/features_new/new_onesignal/data/datasources/new_onesignal_data_source.dart';
import 'package:tautulli_remote/rewrite/features_new/new_onesignal/presentation/bloc/new_onesignal_subscription_bloc.dart';

class MockOnesignalDataSource extends Mock implements NewOnesignalDataSource {}

void main() {
  final mockOnesignalDataSource = MockOnesignalDataSource();

  test(
    'initial state should be NewOnesignalPrivacyInitial',
    () async {
      // assert
      expect(
        NewOnesignalSubscriptionBloc(mockOnesignalDataSource).state,
        NewOnesignalSubscriptionInitial(),
      );
    },
  );

  blocTest<NewOnesignalSubscriptionBloc, NewOnesignalSubscriptionState>(
    'emits [NewOnesignalSubscriptionSuccess] when NewOnesignalSubscriptionCheck is added, hasConsented is true, isSubscribed is true, and userId is not blank.',
    setUp: () {
      when(() => mockOnesignalDataSource.hasConsented).thenAnswer(
        (_) async => true,
      );
      when(() => mockOnesignalDataSource.isSubscribed).thenAnswer(
        (_) async => true,
      );
      when(() => mockOnesignalDataSource.userId).thenAnswer((_) async => '1');
    },
    build: () => NewOnesignalSubscriptionBloc(mockOnesignalDataSource),
    act: (bloc) => bloc.add(NewOnesignalSubscriptionCheck()),
    expect: () =>
        <NewOnesignalSubscriptionState>[NewOnesignalSubscriptionSuccess()],
  );

  blocTest<NewOnesignalSubscriptionBloc, NewOnesignalSubscriptionState>(
    'emits [NewOnesignalSubscriptionFailure] when NewOnesignalSubscriptionCheck is added and hasConsented is false.',
    setUp: () {
      when(() => mockOnesignalDataSource.hasConsented).thenAnswer(
        (_) async => false,
      );
      when(() => mockOnesignalDataSource.isSubscribed).thenAnswer(
        (_) async => false,
      );
      when(() => mockOnesignalDataSource.userId).thenAnswer((_) async => '1');
    },
    build: () => NewOnesignalSubscriptionBloc(mockOnesignalDataSource),
    act: (bloc) => bloc.add(NewOnesignalSubscriptionCheck()),
    expect: () => <NewOnesignalSubscriptionState>[
      NewOnesignalSubscriptionFailure(
        title: consentErrorTitle,
        message: consentErrorMessage,
      ),
    ],
  );

  blocTest<NewOnesignalSubscriptionBloc, NewOnesignalSubscriptionState>(
    'emits [NewOnesignalSubscriptionFailure] when NewOnesignalSubscriptionCheck is added, hasConsented is true, and isSubscribed is false.',
    setUp: () {
      when(() => mockOnesignalDataSource.hasConsented).thenAnswer(
        (_) async => true,
      );
      when(() => mockOnesignalDataSource.isSubscribed).thenAnswer(
        (_) async => false,
      );
      when(() => mockOnesignalDataSource.userId).thenAnswer((_) async => '1');
    },
    build: () => NewOnesignalSubscriptionBloc(mockOnesignalDataSource),
    act: (bloc) => bloc.add(NewOnesignalSubscriptionCheck()),
    expect: () => <NewOnesignalSubscriptionState>[
      NewOnesignalSubscriptionFailure(
        title: registerErrorTitle,
        message: registerErrorMessage,
      ),
    ],
  );
}
