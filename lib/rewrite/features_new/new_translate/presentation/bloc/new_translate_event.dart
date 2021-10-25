part of 'new_translate_bloc.dart';

abstract class NewTranslateEvent extends Equatable {
  const NewTranslateEvent();

  @override
  List<Object> get props => [];
}

class NewTranslateUpdate extends NewTranslateEvent {
  final Locale locale;

  NewTranslateUpdate(this.locale);
}
