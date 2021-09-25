import 'package:dartz/dartz.dart';

import '../../../../core_new/error/new_failure.dart';
import '../../../../core_new/helpers/new_failure_helper.dart';
import '../../../../core_new/network_info/new_network_info.dart';
import '../../domain/repositories/new_image_url_repository.dart';
import '../datasources/new_image_url_data_source.dart';

class NewImageUrlRepositoryImpl implements NewImageUrlRepository {
  final NewImageUrlDataSource dataSource;
  final NewNetworkInfo networkInfo;

  NewImageUrlRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final String url = await dataSource.getImage(
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
        return Right(url);
      } catch (exception) {
        final NewFailure failure =
            NewFailureHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
