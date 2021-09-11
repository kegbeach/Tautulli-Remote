import 'package:dartz/dartz.dart';

import '../../../../core_new/error/new_failure.dart';

abstract class NewImageUrlRepository {
  Future<Either<NewFailure, String>> getImage({
    required String tautulliId,
    String? img,
    int? ratingKey,
    int? width,
    int? height,
    int? opacity,
    int? background,
    int? blur,
    String? fallback,
  });
}
