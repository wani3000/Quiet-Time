import 'package:flutter/material.dart';

/// 이미지 캐시 및 최적화 관리자
class ImageCacheManager {
  static final ImageCacheManager _instance = ImageCacheManager._internal();
  factory ImageCacheManager() => _instance;
  ImageCacheManager._internal();

  /// 이미지 캐시 설정 초기화
  static void initialize() {
    // 이미지 캐시 크기 설정 (100MB)
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 * 1024 * 1024;
    
    // 캐시에 보관할 최대 이미지 수 설정
    PaintingBinding.instance.imageCache.maximumSize = 100;
  }

  /// 이미지 프리로드 (백그라운드에서 미리 로드)
  static Future<void> preloadImages(BuildContext context, List<String> imagePaths) async {
    for (final imagePath in imagePaths) {
      try {
        await precacheImage(AssetImage(imagePath), context);
      } catch (e) {
        // 이미지 프리로드 실패는 무시 (사용자 경험에 치명적이지 않음)
        debugPrint('이미지 프리로드 실패: $imagePath - $e');
      }
    }
  }

  /// 메모리 정리
  static void clearCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// 메모리 사용량 정보
  static Map<String, dynamic> getCacheInfo() {
    final cache = PaintingBinding.instance.imageCache;
    return {
      'currentSize': cache.currentSize,
      'maximumSize': cache.maximumSize,
      'currentSizeBytes': cache.currentSizeBytes,
      'maximumSizeBytes': cache.maximumSizeBytes,
      'liveImageCount': cache.liveImageCount,
    };
  }

  /// 메모리 압박 시 자동 정리
  static void handleMemoryPressure() {
    final cache = PaintingBinding.instance.imageCache;
    
    // 현재 사용량이 80% 이상이면 절반 정리
    if (cache.currentSizeBytes > cache.maximumSizeBytes * 0.8) {
      cache.clear();
      debugPrint('메모리 압박으로 이미지 캐시 정리 실행');
    }
  }
}

/// 최적화된 이미지 위젯 (Asset 및 Network 이미지 지원)
class OptimizedImage extends StatefulWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<OptimizedImage> createState() => _OptimizedImageState();
}

class _OptimizedImageState extends State<OptimizedImage> {
  bool _isLoaded = false;
  bool _hasError = false;
  
  /// 이미지가 네트워크 URL인지 확인
  bool get _isNetworkImage {
    return widget.imagePath.startsWith('http://') || 
           widget.imagePath.startsWith('https://');
  }

  @override
  void initState() {
    super.initState();
    _preloadImage();
  }

  Future<void> _preloadImage() async {
    try {
      if (_isNetworkImage) {
        // 네트워크 이미지 프리로드
        await precacheImage(NetworkImage(widget.imagePath), context);
      } else {
        // 에셋 이미지 프리로드
        await precacheImage(AssetImage(widget.imagePath), context);
      }
      
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('이미지 로드 실패: ${widget.imagePath} - $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.errorWidget ?? 
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: const Icon(Icons.error, color: Colors.grey),
        );
    }

    if (!_isLoaded) {
      return widget.placeholder ??
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
    }

    // 네트워크 이미지 또는 에셋 이미지 렌더링
    if (_isNetworkImage) {
      return Image.network(
        widget.imagePath,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        cacheWidth: widget.width?.round(),
        cacheHeight: widget.height?.round(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return widget.placeholder ??
            Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
        },
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget ??
            Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey[300],
              child: const Icon(Icons.error, color: Colors.grey),
            );
        },
      );
    } else {
      return Image.asset(
        widget.imagePath,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        cacheWidth: widget.width?.round(),
        cacheHeight: widget.height?.round(),
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget ??
            Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey[300],
              child: const Icon(Icons.error, color: Colors.grey),
            );
        },
      );
    }
  }
}

/// 메모리 모니터링 위젯 (개발 모드에서만 사용)
class MemoryMonitor extends StatefulWidget {
  final Widget child;

  const MemoryMonitor({super.key, required this.child});

  @override
  State<MemoryMonitor> createState() => _MemoryMonitorState();
}

class _MemoryMonitorState extends State<MemoryMonitor> {
  @override
  void initState() {
    super.initState();
    
    // 앱 라이프사이클 모니터링
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver());
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    ImageCacheManager.handleMemoryPressure();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // 앱이 백그라운드로 갈 때 메모리 정리
        ImageCacheManager.clearCache();
        break;
      default:
        break;
    }
  }
}
