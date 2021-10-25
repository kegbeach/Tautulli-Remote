import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tautulli_remote/rewrite/features_new/new_onesignal/data/datasources/new_onesignal_data_source.dart';
import 'package:tautulli_remote/rewrite/features_new/new_onesignal/presentation/bloc/new_onesignal_privacy_bloc.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/domain/usecases/new_settings.dart';

class MockOnesignalDataSource extends Mock implements NewOnesignalDataSource {}

class MockSettings extends Mock implements NewSettings {}

void main() {
  final mockOnesignalDataSource = MockOnesignalDataSource();
  final mockSettings = MockSettings();

  void _setUpSuccess() {
    when(() => mockOnesignalDataSource.grantConsent(any())).thenAnswer(
      (_) => Future.value(),
    );
    when(() => mockOnesignalDataSource.disablePush(any())).thenAnswer(
      (_) => Future.value(),
    );
    when(() => mockSettings.setOneSignalConsented(any())).thenAnswer(
      (_) async => true,
    );
  }

  test(
    'initial state should be NewOnesignalPrivacyInitial',
    () async {
      // assert
      expect(
        NewOnesignalPrivacyBloc(
          onesignal: mockOnesignalDataSource,
          settings: mockSettings,
        ).state,
        NewOnesignalPrivacyInitial(),
      );
    },
  );

  group('Onesignal Privacy Check', () {
    blocTest<NewOnesignalPrivacyBloc, NewOnesignalPrivacyState>(
      'emits [NewOnesignalPrivacySuccess] when NewOnesignalPrivacyCheck is added and hasConseted returns true.',
      setUp: () {
        when(() => mockOnesignalDataSource.hasConsented).thenAnswer(
          (_) async => true,
        );
      },
      build: () => NewOnesignalPrivacyBloc(
        onesignal: mockOnesignalDataSource,
        settings: mockSettings,
      ),
      act: (bloc) => bloc.add(NewOnesignalPrivacyCheck()),
      expect: () => <NewOnesignalPrivacyState>[NewOnesignalPrivacySuccess()],
    );

    blocTest<NewOnesignalPrivacyBloc, NewOnesignalPrivacyState>(
      'emits [NewOnesignalPrivacyFailure] when NewOnesignalPrivacyCheck is added and hasConseted returns false.',
      setUp: () {
        when(() => mockOnesignalDataSource.hasConsented).thenAnswer(
          (_) async => false,
        );
      },
      build: () => NewOnesignalPrivacyBloc(
        onesignal: mockOnesignalDataSource,
        settings: mockSettings,
      ),
      act: (bloc) => bloc.add(NewOnesignalPrivacyCheck()),
      expect: () => <NewOnesignalPrivacyState>[NewOnesignalPrivacyFailure()],
    );
  });

  group('Onesignal Privacy Grant', () {
    blocTest<NewOnesignalPrivacyBloc, NewOnesignalPrivacyState>(
      'should set grantConsent to true.',
      build: () => NewOnesignalPrivacyBloc(
        onesignal: mockOnesignalDataSource,
        settings: mockSettings,
      ),
      act: (bloc) => bloc.add(NewOnesignalPrivacyGrant()),
      verify: (_) {
        verify(() => mockOnesignalDataSource.grantConsent(true));
      },
    );
    blocTest<NewOnesignalPrivacyBloc, NewOnesignalPrivacyState>(
      'should set disablePush to false.',
      setUp: () => _setUpSuccess(),
      build: () => NewOnesignalPrivacyBloc(
        onesignal: mockOnesignalDataSource,
        settings: mockSettings,
      ),
      act: (bloc) => bloc.add(NewOnesignalPrivacyGrant()),
      verify: (_) {
        verify(() => mockOnesignalDataSource.disablePush(false));
      },
    );
    blocTest<NewOnesignalPrivacyBloc, NewOnesignalPrivacyState>(
      'should set setOneSignalConsented to true.',
      setUp: () => _setUpSuccess(),
      build: () => NewOnesignalPrivacyBloc(
        onesignal: mockOnesignalDataSource,
        settings: mockSettings,
      ),
      act: (bloc) => bloc.add(NewOnesignalPrivacyGrant()),
      verify: (_) {
        verify(() => mockSettings.setOneSignalConsented(true));
      },
    );

    blocTest<NewOnesignalPrivacyBloc, NewOnesignalPrivacyState>(
      'emits [NewOnesignalPrivacySuccess] when NewOnesignalPrivacyGrant is added.',
      setUp: () => _setUpSuccess(),
      build: () => NewOnesignalPrivacyBloc(
        onesignal: mockOnesignalDataSource,
        settings: mockSettings,
      ),
      act: (bloc) => bloc.add(NewOnesignalPrivacyGrant()),
      expect: () => <NewOnesignalPrivacyState>[NewOnesignalPrivacySuccess()],
    );
  });

  group('Onesignal Privacy Revoke', () {
    blocTest<NewOnesignalPrivacyBloc, NewOnesignalPrivacyState>(
      'should set disablePush to true.',
      setUp: () => _setUpSuccess(),
      build: () => NewOnesignalPrivacyBloc(
        onesignal: mockOnesignalDataSource,
        settings: mockSettings,
      ),
      act: (bloc) => bloc.add(NewOnesignalPrivacyRevoke()),
      verify: (_) {
        verify(() => mockOnesignalDataSource.disablePush(true));
      },
    );
    blocTest<NewOnesignalPrivacyBloc, NewOnesignalPrivacyState>(
      'should set grantConsent to false.',
      build: () => NewOnesignalPrivacyBloc(
        onesignal: mockOnesignalDataSource,
        settings: mockSettings,
      ),
      act: (bloc) => bloc.add(NewOnesignalPrivacyRevoke()),
      verify: (_) {
        verify(() => mockOnesignalDataSource.grantConsent(false));
      },
    );
    blocTest<NewOnesignalPrivacyBloc, NewOnesignalPrivacyState>(
      'should set setOneSignalConsented to false.',
      setUp: () => _setUpSuccess(),
      build: () => NewOnesignalPrivacyBloc(
        onesignal: mockOnesignalDataSource,
        settings: mockSettings,
      ),
      act: (bloc) => bloc.add(NewOnesignalPrivacyRevoke()),
      verify: (_) {
        verify(() => mockSettings.setOneSignalConsented(false));
      },
    );

    blocTest<NewOnesignalPrivacyBloc, NewOnesignalPrivacyState>(
      'emits [NewOnesignalPrivacyFailure] when NewOnesignalPrivacyRevoke is added.',
      setUp: () => _setUpSuccess(),
      build: () => NewOnesignalPrivacyBloc(
        onesignal: mockOnesignalDataSource,
        settings: mockSettings,
      ),
      act: (bloc) => bloc.add(NewOnesignalPrivacyRevoke()),
      expect: () => <NewOnesignalPrivacyState>[NewOnesignalPrivacyFailure()],
    );
  });
}
