import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/strings.dart';

import '../../../../core_new/api/tautulli_api/api_response_data.dart';
import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/enums/loading_state.dart';
import '../../../../core_new/enums/location.dart';
import '../../../../core_new/enums/media_type.dart';
import '../../../../core_new/error/new_failure.dart';
import '../../../new_image_url/domain/usecases/new_get_image_url.dart';
import '../../data/models/new_activity_model.dart';
import '../../domain/usecases/new_get_activity.dart';

part 'new_activity_event.dart';
part 'new_activity_state.dart';

Map<String, Map<String, dynamic>> _activityMapCache = {};

class NewActivityBloc extends Bloc<NewActivityEvent, NewActivityState> {
  final NewGetActivity getActivity;
  final NewGetImageUrl getImageUrl;

  NewActivityBloc({
    required this.getActivity,
    required this.getImageUrl,
  }) : super(NewActivityInitial());

  @override
  Stream<NewActivityState> mapEventToState(
    NewActivityEvent event,
  ) async* {
    final currentState = state;

    if (event is NewActivityLoad) {
      final serverList = event.serverList;

      if (serverList.isEmpty) {
        //TODO: Yield that there are no servers
        yield NewActivityFailure(MissingServerFailure());
      } else {
        // Add servers in serverList that are not in _activityMapCache.
        _addNewServers(serverList);

        // Remove servers from _activityMapCache that are not in serverList.
        _removeOldServers(serverList);

        // Sort _activityMapCache using the sortIndex of each server.
        _sortServers(serverList);

        // Remove servers from server list with LoadingState.inProgress.
        serverList.removeWhere(
          (server) =>
              _activityMapCache[server.tautulliId]!['loadingState'] ==
              LoadingState.inProgress,
        );

        // Set remaining servers to LoadingState.inProgress.
        for (String key in _activityMapCache.keys.toList()) {
          _activityMapCache[key]!['loadingState'] = LoadingState.inProgress;
        }

        // Load each server with a unique event of NewActivityLoadServer.
        _loadServers(serverList);
      }
    }
    if (event is NewActivityLoadServer) {
      yield* event.failureOrActivityResponse.fold(
        (failure) async* {
          //TODO: Log failure using event.plexName

          _activityMapCache[event.tautulliId] = {
            'plex_name': event.plexName,
            'loadingState': LoadingState.failure,
            'activityList': <NewActivityModel>[],
            'failure': failure,
            'bandwidth': {
              'lan': 0,
              'wan': 0,
            }
          };
          yield NewActivityLoaded(
            activityMap: _activityMapCache,
            loadedAt: DateTime.now(),
          );
        },
        (response) async* {
          int totalLanBandwidth = 0;
          int totalWanBandwidth = 0;

          List<NewActivityModel> activityListWithPosters =
              await _fetchPosterUrls(
            activityList: response.data,
            tautulliId: event.tautulliId,
          );

          for (NewActivityModel activity in response.data) {
            // Add bandwidth values to total bandwidths.
            if (isNotBlank(activity.bandwidth)) {
              switch (activity.location) {
                case (Location.WAN):
                case (Location.cellular):
                  totalWanBandwidth =
                      totalWanBandwidth + int.parse(activity.bandwidth!);
                  break;
                case (Location.LAN):
                  totalLanBandwidth =
                      totalLanBandwidth + int.parse(activity.bandwidth!);
                  break;
                case (Location.UNKNOWN):
              }
            }
          }

          _activityMapCache[event.tautulliId] = {
            'plex_name': event.plexName,
            'loadingState': LoadingState.success,
            'activityList': activityListWithPosters,
            'failure': null,
            'bandwidth': {
              'lan': totalLanBandwidth,
              'wan': totalWanBandwidth,
            },
          };

          yield NewActivityLoaded(
            activityMap: _activityMapCache,
            loadedAt: DateTime.now(),
          );
        },
      );
    }
  }

  /// Add servers from serverList to _serverMapCache if they are missing.
  void _addNewServers(List<NewServerModel> serverList) {
    for (NewServerModel server in serverList) {
      if (!_activityMapCache.containsKey(server.tautulliId)) {
        _activityMapCache[server.tautulliId] = {
          'activityList': <NewActivityModel>[],
          'plex_name': server.plexName,
          'loadingState': LoadingState.initial,
          'failure': null,
          'bandwidth': {
            'lan': 0,
            'wan': 0,
          },
        };
      }
    }
  }

  /// Remove servers from _activityMapCache that are not in serverList.
  void _removeOldServers(List<NewServerModel> serverList) {
    List toRemove = [];
    for (String tautulliId in _activityMapCache.keys) {
      int item = serverList.indexWhere(
        (server) => server.tautulliId == tautulliId,
      );
      if (item == -1) {
        toRemove.add(tautulliId);
      }
    }
    _activityMapCache.removeWhere((key, value) => toRemove.contains(key));
  }

  /// Sort servers in _activityMapCache by the server sort index.
  ///
  /// Sort serverList by each server's sortIndex. Then add each item from the
  /// _activityMapCache into sortedMap following the sort of serverList.
  void _sortServers(List<NewServerModel> serverList) {
    serverList.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
    Map<String, Map<String, dynamic>> sortedMap = {};

    for (NewServerModel server in serverList) {
      sortedMap[server.tautulliId] = _activityMapCache[server.tautulliId]!;
    }

    _activityMapCache = sortedMap;
  }

  /// Trigger unique NewActivityLoadServer events for each server in serverList.
  void _loadServers(List<NewServerModel> serverList) {
    for (NewServerModel server in serverList) {
      getActivity(
        tautulliId: server.tautulliId,
      ).then(
        (failureOrActivityResponse) => add(
          NewActivityLoadServer(
            tautulliId: server.tautulliId,
            plexName: server.plexName,
            failureOrActivityResponse: failureOrActivityResponse,
          ),
        ),
      );
    }
  }

  Future<List<NewActivityModel>> _fetchPosterUrls({
    required List<NewActivityModel> activityList,
    required String tautulliId,
  }) async {
    List<NewActivityModel> updatedList = [];

    for (NewActivityModel activity in activityList) {
      //* Fetch and assign image URLs
      String? posterImg;
      int? posterRatingKey;
      String? posterFallback;

      // Assign values for poster URL
      switch (activity.mediaType) {
        case (MediaType.movie):
          posterImg = activity.thumb;
          posterRatingKey = activity.ratingKey;
          if (activity.live) {
            posterFallback = 'poster';
          } else {
            posterFallback = 'poster-live';
          }
          break;
        case (MediaType.episode):
          posterImg = activity.grandparentThumb;
          posterRatingKey = activity.grandparentRatingKey;
          if (activity.live) {
            posterFallback = 'poster';
          } else {
            posterFallback = 'poster-live';
          }
          break;
        case (MediaType.track):
          posterImg = activity.thumb;
          posterRatingKey = activity.parentRatingKey;
          posterFallback = 'cover';
          break;
        case (MediaType.clip):
          posterImg = activity.thumb;
          posterRatingKey = activity.ratingKey;
          posterFallback = 'poster';
          break;
        default:
          posterRatingKey = activity.ratingKey;
      }

      // Attempt to get poster URL
      final failureOrPosterUrl = await getImageUrl(
        tautulliId: tautulliId,
        img: posterImg,
        ratingKey: posterRatingKey,
        fallback: posterFallback,
      );

      failureOrPosterUrl.fold(
        (failure) {
          //TODO: Log poster URL failure
        },
        (url) {
          updatedList.add(activity.copyWith(posterUrl: url));
        },
      );
    }

    return updatedList;
  }
}
