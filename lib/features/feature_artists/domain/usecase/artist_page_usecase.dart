import 'package:movie_chi/features/feature_artists/domain/repositories/artist_repostitory.dart';

class ArtistPageUseCases {
  ArtistRepository artistRepository;
  ArtistPageUseCases({
    required this.artistRepository,
  });

  getArtistSuggestionData(
      int itemCount, int page, String? artistName, String? artistTag) async {
    return await artistRepository.getArtistSuggestionData(
        itemCount, page, artistName, artistTag);
  }

  getArtistData(
      int itemCount, int page, String? artistName, String? artistTag) async {
    return await artistRepository.getArtistData(
        itemCount, page, artistName, artistTag);
  }
}
