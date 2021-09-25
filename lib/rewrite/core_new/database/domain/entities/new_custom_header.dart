import 'package:equatable/equatable.dart';

class NewCustomHeader extends Equatable {
  final String key;
  final String value;

  const NewCustomHeader({
    required this.key,
    required this.value,
  });

  @override
  List<Object> get props => [key, value];
}
