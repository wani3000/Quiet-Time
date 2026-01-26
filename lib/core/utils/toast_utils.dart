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
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
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
        backgroundColor: const Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 0,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
