import '../../../../core_new/api/tautulli_api/new_tautulli_api.dart'
    as tautulli_api;

abstract class NewImageUrlDataSource {
  Future<String> getImage({
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

class NewImageUrlDataSourceImpl implements NewImageUrlDataSource {
  final tautulli_api.NewPmsImageProxy apiPmsImageProxy;

  NewImageUrlDataSourceImpl(this.apiPmsImageProxy);

  Future<String> getImage({
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
    final String url = await apiPmsImageProxy(
      tautulliId: tautulliId,
      img: img,
      ratingKey: ratingKey,
      width: width ?? 300,
      height: height ?? 450,
      opacity: opacity,
      background: background,
      blur: blur,
      fallback: fallback,
    );

    return url;
  }
}
