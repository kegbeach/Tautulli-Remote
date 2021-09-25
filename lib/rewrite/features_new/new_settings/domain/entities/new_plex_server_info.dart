import 'package:equatable/equatable.dart';

abstract class NewPlexServerInfo extends Equatable {
  final String pmsIdentifier;
  final String pmsIp;
  final int pmsIsRemote;
  final String pmsName;
  final String pmsPlatform;
  final int pmsPlexpass;
  final int pmsPort;
  final int pmsSsl;
  final String pmsUrl;
  final int pmsUrlManual;
  final String pmsVersion;

  const NewPlexServerInfo({
    required this.pmsIdentifier,
    required this.pmsIp,
    required this.pmsIsRemote,
    required this.pmsName,
    required this.pmsPlatform,
    required this.pmsPlexpass,
    required this.pmsPort,
    required this.pmsSsl,
    required this.pmsUrl,
    required this.pmsUrlManual,
    required this.pmsVersion,
  });

  @override
  List<Object> get props => [
        pmsIdentifier,
        pmsIp,
        pmsIsRemote,
        pmsName,
        pmsPlatform,
        pmsPlexpass,
        pmsPort,
        pmsSsl,
        pmsUrl,
        pmsUrlManual,
        pmsVersion,
      ];
}
