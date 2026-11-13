import 'dart:convert';
import 'package:filmer/models/movie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  
  MovieService();

  // Lazy evaluation to avoid multiple reads if possible, but ensures dotenv is loaded
  String get _apiKey => dotenv.env['TMDB_API_KEY'] ?? '';

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    if (_apiKey.isEmpty || _apiKey == 'your_api_key_here') {
      debugPrint("Warning: No Valid API Key found.");
      return []; 
    }

    try {
      final isBearer = _apiKey.startsWith('eyJ');
      final queryParams = <String, String>{
        'language': 'es-ES',
        'page': page.toString(),
      };
      if (!isBearer) {
        queryParams['api_key'] = _apiKey;
      }

      final uri = Uri.parse('$_baseUrl/movie/popular').replace(queryParameters: queryParams);
      final headers = <String, String>{
        if (isBearer) 'Authorization': 'Bearer $_apiKey',
        'accept': 'application/json',
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        
        return results.map((e) {
          final json = e as Map<String, dynamic>;
          final title = json['title'] ?? json['name'] ?? 'Untitled';
          final releaseDate = json['release_date'] ?? json['first_air_date'] ?? '';
          final year = releaseDate.toString().isNotEmpty ? releaseDate.toString().split('-').first : 'Unknown';
          
          final posterPath = json['poster_path'];
          final imageUrl = posterPath != null 
              ? 'https://image.tmdb.org/t/p/w500$posterPath' 
              : 'https://via.placeholder.com/500x750';

          return Movie(
            id: json['id'] as int? ?? 0,
            title: title,
            year: year,
            duration: "Unknown", 
            rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
            genres: const [], 
            imageUrl: imageUrl,
            platforms: const [], 
            type: json['title'] != null ? ContentType.movie : ContentType.series,
            synopsis: json['overview'] ?? 'No synopsis available',
          );
        }).toList();
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error fetching movies: $e");
      return []; // Could throw to let UI handle the error state
    }
  }

  /// Fetches the YouTube video key for a movie trailer
  Future<String?> getMovieTrailerKey(int movieId) async {
    if (_apiKey.isEmpty) return null;
    
    try {
      final isBearer = _apiKey.startsWith('eyJ');
      final queryParams = <String, String>{
        'language': 'es-ES',
      };
      if (!isBearer) {
        queryParams['api_key'] = _apiKey;
      }

      final uri = Uri.parse('$_baseUrl/movie/$movieId/videos').replace(queryParameters: queryParams);
      final headers = <String, String>{
        if (isBearer) 'Authorization': 'Bearer $_apiKey',
        'accept': 'application/json',
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        
        // Find first official trailer on YouTube
        final trailer = results.cast<Map<String, dynamic>>().firstWhere(
          (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
          orElse: () => <String, dynamic>{},
        );
        
        return trailer.isNotEmpty ? trailer['key'] as String? : null;
      }
    } catch (e) {
      debugPrint("Error fetching trailer: $e");
    }
    return null;
  }
}
