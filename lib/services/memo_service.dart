import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// 묵상 메모 저장/불러오기 서비스
class MemoService {
  static const String _keyPrefix = 'memo_';
  
  /// 특정 날짜의 메모를 저장합니다
  static Future<bool> saveMemo(String date, String memo) async {
    try {
      debugPrint('메모 저장 시작: date=$date, memo=${memo.length}자'); // 디버깅
      
      // iOS에서는 SharedPreferences만 사용
      
      // 모바일 또는 localStorage 실패 시 SharedPreferences 사용
      final prefs = await SharedPreferences.getInstance();
      debugPrint('SharedPreferences 인스턴스 획득 성공'); // 디버깅
      
      final key = '$_keyPrefix$date';
      debugPrint('저장할 키: $key'); // 디버깅
      
      final result = await prefs.setString(key, memo);
      debugPrint('메모 저장 결과: $result'); // 디버깅
      
      // 저장 후 바로 읽어서 확인
      final savedMemo = prefs.getString(key);
      debugPrint('저장 후 확인: ${savedMemo?.length ?? 0}자'); // 디버깅
      
      return result && savedMemo != null && savedMemo.isNotEmpty;
    } catch (e) {
      // 에러 로깅 (실제 앱에서는 로깅 서비스 사용)
      debugPrint('메모 저장 실패: $e');
      debugPrint('에러 스택: ${e.toString()}');
      return false;
    }
  }
  
  /// 특정 날짜의 메모를 불러옵니다
  static Future<String> getMemo(String date) async {
    try {
      // iOS에서는 SharedPreferences만 사용
      
      // 모바일 또는 localStorage 실패 시 SharedPreferences 사용
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$date';
      final result = prefs.getString(key) ?? '';
      debugPrint('SharedPreferences 메모 불러오기: date=$date, memo=${result.length}자'); // 디버깅
      return result;
    } catch (e) {
      debugPrint('메모 불러오기 실패: $e');
      return '';
    }
  }
  
  /// 특정 날짜의 메모를 삭제합니다
  static Future<bool> deleteMemo(String date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$date';
      return await prefs.remove(key);
    } catch (e) {
      debugPrint('메모 삭제 실패: $e');
      return false;
    }
  }
  
  /// 모든 메모를 가져옵니다 (날짜별 메모 목록)
  static Future<Map<String, String>> getAllMemos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith(_keyPrefix));
      final Map<String, String> memos = {};
      
      for (final key in keys) {
        final date = key.substring(_keyPrefix.length);
        final memo = prefs.getString(key) ?? '';
        if (memo.isNotEmpty) {
          memos[date] = memo;
        }
      }
      
      return memos;
    } catch (e) {
      debugPrint('전체 메모 불러오기 실패: $e');
      return {};
    }
  }
  
  /// 메모가 있는지 확인합니다
  static Future<bool> hasMemo(String date) async {
    final memo = await getMemo(date);
    return memo.isNotEmpty;
  }
}
