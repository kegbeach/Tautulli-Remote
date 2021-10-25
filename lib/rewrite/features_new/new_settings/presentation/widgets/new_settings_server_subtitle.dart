import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../../../../../translations/locale_keys.g.dart';
import '../../../../core_new/database/data/models/new_server_model.dart';

class NewSettingsServerSubtitle extends StatelessWidget {
  final NewServerModel server;
  final bool maskSensitiveInfo;

  const NewSettingsServerSubtitle({
    Key? key,
    required this.server,
    this.maskSensitiveInfo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEmpty(server.primaryConnectionAddress)) {
      return const Text(
        LocaleKeys.settings_primary_connection_missing,
      ).tr();
    }
    if (isNotEmpty(server.primaryConnectionAddress) &&
        server.primaryActive &&
        !maskSensitiveInfo) {
      return Text(server.primaryConnectionAddress);
    }
    if (isNotEmpty(server.primaryConnectionAddress) &&
        !server.primaryActive &&
        !maskSensitiveInfo) {
      return Text(server.secondaryConnectionAddress!);
    }
    return Text(
      '*${LocaleKeys.masked_info_connection_address.tr()}*',
    );
  }
}
