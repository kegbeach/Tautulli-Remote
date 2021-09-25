import '../../../../core_new/helpers/new_value_helper.dart';
import '../../domain/entities/new_plex_server_info.dart';

class NewPlexServerInfoModel extends NewPlexServerInfo {
  const NewPlexServerInfoModel({
    required String pmsIdentifier,
    required String pmsIp,
    required int pmsIsRemote,
    required String pmsName,
    required String pmsPlatform,
    required int pmsPlexpass,
    required int pmsPort,
    required int pmsSsl,
    required String pmsUrl,
    required int pmsUrlManual,
    required String pmsVersion,
  }) : super(
          pmsIdentifier: pmsIdentifier,
          pmsIp: pmsIp,
          pmsIsRemote: pmsIsRemote,
          pmsName: pmsName,
          pmsPlatform: pmsPlatform,
          pmsPlexpass: pmsPlexpass,
          pmsPort: pmsPort,
          pmsSsl: pmsSsl,
          pmsUrl: pmsUrl,
          pmsUrlManual: pmsUrlManual,
          pmsVersion: pmsVersion,
        );

  factory NewPlexServerInfoModel.fromJson(Map<String, dynamic> json) {
    return NewPlexServerInfoModel(
      pmsIdentifier: NewValueHelper.cast(
        json['pms_identifier'],
        CastType.string,
      ),
      pmsIp: NewValueHelper.cast(
        json['pms_ip'],
        CastType.string,
      ),
      pmsIsRemote: NewValueHelper.cast(
        json['pms_is_remote'],
        CastType.int,
      ),
      pmsName: NewValueHelper.cast(
        json['pms_name'],
        CastType.string,
      ),
      pmsPlatform: NewValueHelper.cast(
        json['pms_platform'],
        CastType.string,
      ),
      pmsPlexpass: NewValueHelper.cast(
        json['pms_plexpass'],
        CastType.int,
      ),
      pmsPort: NewValueHelper.cast(
        json['pms_port'],
        CastType.int,
      ),
      pmsSsl: NewValueHelper.cast(
        json['pms_ssl'],
        CastType.int,
      ),
      pmsUrl: NewValueHelper.cast(
        json['pms_url'],
        CastType.string,
      ),
      pmsUrlManual: NewValueHelper.cast(
        json['pms_url_manual'],
        CastType.int,
      ),
      pmsVersion: NewValueHelper.cast(
        json['pms_version'],
        CastType.string,
      ),
    );
  }
}
