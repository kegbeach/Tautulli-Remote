import 'package:dartz/dartz.dart';

import '../../../../core_new/error/new_failure.dart';
import '../repositories/new_image_url_repository.dart';

class NewGetImageUrl {
  final NewImageUrlRepository repository;

  NewGetImageUrl(this.repository);

  Future<Either<NewFailure, String>> call({
    required String tautulliId,
    String? img,
    int? ratingKey,
    int? width,
    int? height,
    int? opacity,
    int? background,
    int? blur,
    String? fallback,
  }) async {
    return await repository.getImage(
      tautulliId: tautulliId,
      img: img,
      ratingKey: ratingKey,
      width: width,
      height: height,
      opacity: opacity,
      background: background,
      blur: blur,
      fallback: fallback,
    );
  }
}
