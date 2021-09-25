import 'package:equatable/equatable.dart';

class ApiResponseData extends Equatable {
  final dynamic data;
  final bool primaryActive;

  ApiResponseData({
    required this.data,
    required this.primaryActive,
  });

  @override
  List<Object?> get props => [
        data,
        primaryActive,
      ];
}
