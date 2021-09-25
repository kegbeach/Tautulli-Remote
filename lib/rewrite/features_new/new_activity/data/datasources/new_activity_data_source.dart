import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/api/tautulli_api/new_tautulli_api.dart'
    as tautulli_api;
import '../models/new_activity_model.dart';

abstract class NewActivityDataSource {
  Future<ApiResponseData> getActivity({
    required String tautulliId,
  });
}

class NewActivityDataSourceImpl implements NewActivityDataSource {
  final tautulli_api.NewGetActivity apiGetActivity;

  NewActivityDataSourceImpl(this.apiGetActivity);

  @override
  Future<ApiResponseData> getActivity({
    required String tautulliId,
  }) async {
    final response = await apiGetActivity(
      tautulliId: tautulliId,
    );

    final List<NewActivityModel> activityList = [];
    response['responseData']['response']['data']['sessions'].forEach(
      (session) {
        activityList.add(
          NewActivityModel.fromJson(session),
        );
      },
    );

    return ApiResponseData(
      data: activityList,
      primaryActive: response['primaryActive'],
    );
  }
}
