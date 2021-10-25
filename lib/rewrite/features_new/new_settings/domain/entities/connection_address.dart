import 'package:equatable/equatable.dart';

import '../../../../core_new/enums/enums.dart';

abstract class ConnectionAddress extends Equatable {
  final bool primary;
  final String? address;
  final Protocol? protocol;
  final String? domain;
  final String? path;

  const ConnectionAddress({
    required this.primary,
    this.address,
    this.protocol,
    this.domain,
    this.path,
  });

  @override
  List<Object> get props => [];
}
