import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Pexels API 서비스 (Unsplash 백업용)
class PexelsService {
  // Pexels API 키 (무료: 200회/시간)
  // https://www.pexels.com/api/ 에서 발급 가능
  static const _apiKey = 'FgxaGxnLV5hCdYp7qKiYGLEK9uYvAeZXOkLPGDy5NvLxB1oEpYT6AMHW';
  static const _baseUrl = 'https://api.pexels.com/v1';

  /// 랜덤 이미지 가져오기
  static Future<Map<String, String>> fetchRandomImage({
    String query = 'nature',
  }) async {
    try {
      debugPrint('Pexels API 요청: $query');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/search?query=$query&orientation=portrait&per_page=15&page=1'),
        headers: {
          'Authorization': _apiKey,
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final photos = data['photos'] as List;
        
        if (photos.isEmpty) {
          debugPrint('Pexels: 검색 결과 없음');
          return _getFallbackImageData();
        }
        
        // 랜덤하게 하나 선택
        final randomIndex = DateTime.now().millisecondsSinceEpoch % photos.length;
        final photo = photos[randomIndex];
        
        final url = photo['src']['large2x'] ?? photo['src']['large'];
        final photographer = photo['photographer'] ?? 'Unknown';

        return {'url': url, 'author': photographer, 'source': 'Pexels'};
      } else {
        debugPrint('Pexels API 오류: ${response.statusCode}');
        return _getFallbackImageData();
      }
    } catch (e) {
      debugPrint('Pexels API 요청 실패: $e');
      return _getFallbackImageData();
    }
  }

  /// 폴백 이미지 데이터 반환
  static Map<String, String> _getFallbackImageData() {
    return {
      'url': 'assets/images/bg1.jpg',
      'author': 'Default Image',
      'source': 'Local'
    };
  }
}
