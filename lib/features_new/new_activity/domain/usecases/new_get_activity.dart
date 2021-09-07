import 'package:dartz/dartz.dart';

import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/error/new_failure.dart';
import '../repositories/new_activity_repository.dart';

class NewGetActivity {
  final NewActivityRepository repository;

  NewGetActivity(this.repository);

  Future<Either<NewFailure, ApiResponseData>> call({
    required String tautulliId,
  }) async {
    return await repository.getActivity(tautulliId: tautulliId);
  }
}
