import 'package:flutter/material.dart';

class FloatingBottomBar extends StatelessWidget {
  final List<Widget> children;
  
  const FloatingBottomBar({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF1F3F5), width: 1),
        borderRadius: BorderRadius.circular(200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 8),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;
  final Color? labelColor;
  final bool isLoading;

  const BottomBarButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: icon,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                  color: labelColor ?? const Color(0xFF212529),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
