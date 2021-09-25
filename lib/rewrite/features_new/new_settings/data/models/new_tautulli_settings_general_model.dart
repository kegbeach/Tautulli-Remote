import '../../../../core_new/helpers/new_value_helper.dart';
import '../../domain/entities/new_tautulli_settings_general.dart';

class NewTautulliSettingsGeneralModel extends NewTautulliSettingsGeneral {
  const NewTautulliSettingsGeneralModel({
    required String dateFormat,
    required String timeFormat,
  }) : super(
          dateFormat: dateFormat,
          timeFormat: timeFormat,
        );

  factory NewTautulliSettingsGeneralModel.fromJson(Map<String, dynamic> json) {
    return NewTautulliSettingsGeneralModel(
      dateFormat: NewValueHelper.cast(
        json['date_format'],
        CastType.string,
      ),
      timeFormat: NewValueHelper.cast(
        json['time_format'],
        CastType.string,
      ),
    );
  }
}
