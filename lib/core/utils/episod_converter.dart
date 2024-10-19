import 'package:movie_chi/features/feature_detail_page/data/model/video_model.dart';
import 'package:movie_chi/features/feature_play_list/data/model/session_playlist.dart';

Video episoidToVideo(EpisoidsData episoid, Video vieo) {
  Video video = Video(
    title: episoid.title,
    tag: episoid.qualityId,
    desc: vieo.desc,
    thumbnail1x: vieo.thumbnail1x,
    thumbnail2x: vieo.thumbnail2x,
    qualitiesId: episoid.qualityId,
    galleryId: vieo.galleryId,
    quality1080: episoid.quality1080,
    quality1440: episoid.quality1440,
    quality2160: episoid.quality2160,
    quality240: episoid.quality240,
    quality360: episoid.quality360,
    quality4320: episoid.quality4320,
    quality480: episoid.quality480,
    quality720: episoid.quality720,
    view: vieo.view,
    userLiked: vieo.userLiked,
    userBookmarked: vieo.userBookmarked,
    tagData: vieo.tagData,
    artistData: vieo.artistData,
    lastSessionTime: vieo.lastSessionTime,
    type: vieo.type,
    commonTag: vieo.commonTag,
    subtitle: vieo.subtitle,
    dubble: vieo.dubble,
  );
  return video;
}
