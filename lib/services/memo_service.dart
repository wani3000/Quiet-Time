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
  
  /// 테스트 환경에서만 사용: 1월 1일부터 오늘까지 샘플 묵상 데이터 생성
  static Future<void> generateTestMemos() async {
    if (!kDebugMode) {
      // 릴리즈 모드에서는 실행하지 않음
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      const testDataKey = 'test_memos_generated';
      
      // 이미 생성되었는지 확인
      if (prefs.getBool(testDataKey) == true) {
        debugPrint('테스트 묵상 데이터가 이미 생성되어 있습니다.');
        return;
      }
      
      debugPrint('테스트 묵상 데이터 생성 시작...');
      
      final today = DateTime.now();
      final startDate = DateTime(today.year, 1, 1); // 올해 1월 1일
      final daysDifference = today.difference(startDate).inDays;
      
      int successCount = 0;
      final sampleMemos = [
        '오늘의 말씀을 묵상하며 하루를 시작합니다. 하나님의 은혜가 함께하시기를 기도합니다.',
        '말씀을 읽으며 마음이 평안해집니다. 주님의 인도하심을 신뢰합니다.',
        '오늘도 하나님의 사랑을 느끼며 하루를 보내게 해주셔서 감사합니다.',
        '말씀을 통해 새로운 깨달음을 얻었습니다. 이를 삶에 적용하겠습니다.',
        '하나님의 약속을 믿고 오늘 하루를 담대하게 살아가겠습니다.',
        '말씀을 묵상하며 내 마음을 돌아봅니다. 주님 앞에 겸손히 나아갑니다.',
        '오늘의 말씀이 내 상황에 정확히 맞는 것 같습니다. 하나님의 인도하심을 느낍니다.',
        '말씀을 통해 위로와 힘을 얻었습니다. 감사한 마음으로 하루를 시작합니다.',
        '하나님의 사랑이 얼마나 크신지 다시 한번 깨닫게 됩니다.',
        '말씀을 읽으며 내 삶의 방향을 점검합니다. 주님의 뜻을 따르겠습니다.',
      ];
      
      for (int i = 0; i <= daysDifference; i++) {
        final date = startDate.add(Duration(days: i));
        final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        
        // 이미 메모가 있으면 건너뛰기
        if (await hasMemo(dateString)) {
          continue;
        }
        
        // 샘플 메모 선택 (날짜 기반으로 순환)
        final memoIndex = i % sampleMemos.length;
        final memo = sampleMemos[memoIndex];
        
        final saved = await saveMemo(dateString, memo);
        if (saved) {
          successCount++;
        }
      }
      
      // 생성 완료 플래그 저장
      await prefs.setBool(testDataKey, true);
      
      debugPrint('테스트 묵상 데이터 생성 완료: $successCount개 생성됨');
    } catch (e) {
      debugPrint('테스트 묵상 데이터 생성 실패: $e');
    }
  }
}
