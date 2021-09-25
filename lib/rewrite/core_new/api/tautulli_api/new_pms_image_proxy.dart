import 'new_connection_handler.dart';

abstract class NewPmsImageProxy {
  Future<String> call({
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

class NewPmsImageProxyImpl implements NewPmsImageProxy {
  final NewConnectionHandler connectionHandler;

  NewPmsImageProxyImpl(this.connectionHandler);

  @override
  Future<String> call({
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
    Map<String, String> params = {};

    if (img != null) {
      params['img'] = img;
    }
    if (ratingKey != null) {
      params['rating_key'] = ratingKey.toString();
    }
    if (width != null) {
      params['width'] = width.toString();
    }
    if (height != null) {
      params['height'] = height.toString();
    }
    if (opacity != null) {
      params['opacity'] = opacity.toString();
    }
    if (background != null) {
      params['background'] = background.toString();
    }
    if (blur != null) {
      params['blur'] = blur.toString();
    }
    if (fallback != null) {
      params['fallback'] = fallback;
    }

    final response = await connectionHandler(
      tautulliId: tautulliId,
      cmd: 'pms_image_proxy',
      params: params,
    );

    final Uri uri = response['responseData'];

    return uri.toString();
  }
}
