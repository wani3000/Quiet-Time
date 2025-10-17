/// 앱 환경 설정 관리 서비스
class ConfigService {
  /// 환경 설정 초기화
  static Future<void> initialize() async {
    // 웹 환경에서는 하드코딩된 설정 사용
  }
  
  /// 현재 환경 (dev, staging, prod)
  static String get environment => 'prod';
  
  /// 기본 URL 가져오기
  static String get baseUrl {
    switch (environment) {
      case 'prod':
        return 'https://versecard.app'; // TODO: 실제 도메인으로 변경 필요
      case 'staging':
        return 'https://staging.versecard.app';
      default:
        return 'http://localhost:8081';
    }
  }
  
  /// 공유 URL 생성
  static String getShareUrl(String date) {
    return '$baseUrl/shared/$date';
  }
  
  /// 앱 이름
  static String get appName => '말씀묵상';
  
  /// 앱 버전
  static String get appVersion => '1.0.0';
  
  /// 페이월 기능 활성화 여부
  static bool get isPaywallEnabled => false;
  
  /// 분석 기능 활성화 여부
  static bool get isAnalyticsEnabled => false;
  
  /// 개발 모드 여부
  static bool get isDevelopment => environment == 'dev';
  
  /// 프로덕션 모드 여부
  static bool get isProduction => environment == 'prod';
}

