import '../../domain/entities/new_custom_header.dart';

class NewCustomHeaderModel extends NewCustomHeader {
  const NewCustomHeaderModel({
    required String key,
    required String value,
  }) : super(
          key: key,
          value: value,
        );
}
