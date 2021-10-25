import 'package:equatable/equatable.dart';

abstract class NewTautulliSettingsGeneral extends Equatable {
  final String dateFormat;
  final String timeFormat;

  const NewTautulliSettingsGeneral({
    required this.dateFormat,
    required this.timeFormat,
  });

  @override
  List<Object> get props => [dateFormat, timeFormat];
}
