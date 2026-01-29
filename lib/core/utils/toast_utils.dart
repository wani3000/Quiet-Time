import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 토스트 유틸리티
class ToastUtils {
  /// 성공 토스트 표시
  static void showSuccess(BuildContext context, String message) {
    _showToast(context, message);
  }

  /// 에러 토스트 표시
  static void showError(BuildContext context, String message) {
    _showToast(context, message);
  }

  /// 일반 토스트 표시
  static void show(BuildContext context, String message) {
    _showToast(context, message);
  }

  /// 토스트 표시 (공통)
  static void _showToast(BuildContext context, String message) {
    // 최상위 ScaffoldMessenger 찾기
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context) ?? 
        ScaffoldMessenger.of(context);
    
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF1A1A1A).withValues(alpha: 0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        margin: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: 140, // 네비게이션 바 높이(80px) + margin(24px*2) + 여유공간(12px) = 140px
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 1000, // 최상위에 표시되도록 높은 elevation 설정
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
