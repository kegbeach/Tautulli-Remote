import 'package:equatable/equatable.dart';

class NewServer extends Equatable {
  final int? id;
  final int sortIndex;
  final String plexName;
  final String plexIdentifier;
  final String tautulliId;
  final String primaryConnectionAddress;
  final String primaryConnectionProtocol;
  final String primaryConnectionDomain;
  final String? primaryConnectionPath;
  final String? secondaryConnectionAddress;
  final String? secondaryConnectionProtocol;
  final String? secondaryConnectionDomain;
  final String? secondaryConnectionPath;
  final String deviceToken;
  final bool primaryActive;
  final bool onesignalRegistered;
  final bool plexPass;
  final String? dateFormat;
  final String? timeFormat;

  NewServer({
    this.id,
    required this.sortIndex,
    required this.plexName,
    required this.plexIdentifier,
    required this.tautulliId,
    required this.primaryConnectionAddress,
    required this.primaryConnectionProtocol,
    required this.primaryConnectionDomain,
    this.primaryConnectionPath,
    this.secondaryConnectionAddress,
    this.secondaryConnectionProtocol,
    this.secondaryConnectionDomain,
    this.secondaryConnectionPath,
    required this.deviceToken,
    required this.primaryActive,
    required this.onesignalRegistered,
    required this.plexPass,
    this.dateFormat,
    this.timeFormat,
  });

  @override
  List<Object?> get props => [
        id,
        sortIndex,
        plexName,
        plexIdentifier,
        tautulliId,
        primaryConnectionAddress,
        primaryConnectionProtocol,
        primaryConnectionDomain,
        primaryConnectionPath,
        secondaryConnectionAddress,
        secondaryConnectionProtocol,
        secondaryConnectionDomain,
        secondaryConnectionPath,
        deviceToken,
        primaryActive,
        onesignalRegistered,
        plexPass,
        dateFormat,
        timeFormat,
      ];
}
