import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'pexels_service.dart';

/// 이미지 API 서비스 (Unsplash 기본, Pexels 백업)
class UnsplashService {
  static const _accessKey = 'tfZUgmdsGLxqxAsDfAkObE2irmn6Gp1S6NA9DdxZQYY';
  static const _baseUrl = 'https://api.unsplash.com/photos/random';

  /// 이미지를 가져오는 메서드
  /// [uniqueId] : 말씀 구절(reference) 등을 넣으면 해당 구절 전용 이미지를 저장/로드합니다.
  /// [uniqueId]가 없으면 기존처럼 "오늘의 이미지"를 반환합니다.
  static Future<Map<String, String>> fetchDailyImage({
    String query = 'nature',
    String? uniqueId, 
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 캐시 키 생성 (ID가 있으면 그 ID를 쓰고, 없으면 오늘 날짜를 사용)
      final today = DateTime.now().toIso8601String().substring(0, 10); // yyyy-MM-dd
      final cacheKey = uniqueId != null ? 'image_$uniqueId' : 'image_daily_$today';
      
      // 1. 캐시 확인
      final cachedUrl = prefs.getString('${cacheKey}_url');
      final cachedAuthor = prefs.getString('${cacheKey}_author');
      final cachedSource = prefs.getString('${cacheKey}_source') ?? 'Unsplash';
      
      if (cachedUrl != null && cachedAuthor != null) {
        // debugPrint('캐시된 이미지 사용 ($cacheKey): $cachedUrl');
        return {'url': cachedUrl, 'author': cachedAuthor, 'source': cachedSource};
      }

      // 2. Unsplash에서 새 이미지 요청 (캐시가 없을 때만)
      debugPrint('Unsplash 이미지 요청 ($query): $cacheKey');
      final unsplashResult = await _fetchFromUnsplash(query);
      
      if (unsplashResult != null) {
        // 3. 로컬 저장
        await _saveToCache(prefs, cacheKey, unsplashResult);
        return unsplashResult;
      }

      // 4. Unsplash 실패 시 Pexels 백업 사용
      debugPrint('Unsplash 실패, Pexels 백업 시도...');
      final pexelsResult = await PexelsService.fetchRandomImage(query: query);
      
      if (pexelsResult['url'] != 'assets/images/bg1.jpg') {
        await _saveToCache(prefs, cacheKey, pexelsResult);
        return pexelsResult;
      }

      // 5. 모두 실패 시 폴백
      return _getFallbackImageData();
    } catch (e) {
      debugPrint('이미지 API 요청 실패: $e');
      return _getFallbackImageData();
    }
  }

  /// Unsplash에서 이미지 가져오기
  static Future<Map<String, String>?> _fetchFromUnsplash(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?query=$query&orientation=portrait&client_id=$_accessKey'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final url = data['urls']['regular'];
        final author = data['user']['name'];
        return {'url': url, 'author': author, 'source': 'Unsplash'};
      } else {
        debugPrint('Unsplash API 오류: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Unsplash API 요청 실패: $e');
      return null;
    }
  }

  /// 캐시에 저장
  static Future<void> _saveToCache(
    SharedPreferences prefs, 
    String cacheKey, 
    Map<String, String> data
  ) async {
    await prefs.setString('${cacheKey}_url', data['url']!);
    await prefs.setString('${cacheKey}_author', data['author']!);
    await prefs.setString('${cacheKey}_source', data['source'] ?? 'Unknown');
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