import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/image_saver.dart';
import '../../../core/utils/image_cache_manager.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../data/verse_database.dart';
import '../../../services/unsplash_service.dart';

class VerseCard extends StatefulWidget {
  final String? date;
  final bool showActions;
  final bool isThumbnail;
  final bool isSquare;
  final bool showButtons;

  const VerseCard({
    super.key,
    this.date,
    this.showActions = true,
    this.isThumbnail = false,
    this.isSquare = false,
    this.showButtons = true,
  });

  @override
  State<VerseCard> createState() => VerseCardState();
}

class VerseCardState extends State<VerseCard> {

  final GlobalKey _cardKey = GlobalKey();
  bool _isSaving = false;

  // 이미지 Future를 캐싱하여 rebuild 시 깜빡임 방지
  late Future<Map<String, String>> _imageFuture;
  late Future<Map<String, String>> _verseDataFuture;
  Map<String, String>? _cachedVerseData;

  bool get isSaving => _isSaving;

  @override
  void initState() {
    super.initState();
    _verseDataFuture = _getVerseData();
    // _verseDataFuture를 통해 이미지 Future 생성
    _imageFuture = _verseDataFuture.then((verseData) async {
      _cachedVerseData = verseData;
      return await UnsplashService.fetchDailyImage(
        query: 'sky',
        uniqueId: verseData['reference']!,
      );
    });
  }

  @override
  void didUpdateWidget(VerseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // date가 변경된 경우에만 Future를 다시 생성
    if (oldWidget.date != widget.date) {
      _verseDataFuture = _getVerseData();
      _imageFuture = _verseDataFuture.then((verseData) async {
        _cachedVerseData = verseData;
        return await UnsplashService.fetchDailyImage(
          query: 'sky',
          uniqueId: verseData['reference']!,
        );
      });
    }
  }

  // Get verse data based on date
  Future<Map<String, String>> _getVerseData() async {
    String targetDate;

    if (widget.date != null) {
      targetDate = widget.date!;
    } else {
      final now = DateTime.now();
      if (now.hour < 6) {
        final yesterday = now.subtract(const Duration(days: 1));
        targetDate = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      } else {
        targetDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      }
    }

    return await VerseDatabase.getVerseByDate(targetDate);
  }

  // 카드 이미지를 PNG 바이트로 캡처 (border radius 없는 깨끗한 이미지)
  Future<Uint8List> captureCardImage() async {
    final downloadWidget = _buildDownloadCard();

    final downloadKey = GlobalKey();
    final downloadBoundary = RepaintBoundary(
      key: downloadKey,
      child: downloadWidget,
    );

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: -10000,
        top: -10000,
        child: downloadBoundary,
      ),
    );

    overlay.insert(overlayEntry);

    // 렌더링 대기 시간 확보
    await Future.delayed(const Duration(milliseconds: 200));

    final boundary = downloadKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      overlayEntry.remove();
      throw Exception('Unable to capture download widget');
    }

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    overlayEntry.remove();

    return pngBytes;
  }

  // Public method for external access
  Future<void> saveCard() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final pngBytes = await captureCardImage();

      final success = await ImageSaver.saveToGallery(pngBytes);

      if (mounted) {
        ToastUtils.show(context, success ? '말씀카드를 갤러리에 다운로드 했어요!' : '저장에 실패했어요');
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(context, '저장에 실패했어요');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // 다운로드용 카드 위젯
  Widget _buildDownloadCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = math.min(screenWidth - 32, 400.0);
    final cardHeight = cardWidth * 5 / 4;

    // 캐시된 데이터가 없으면 빈 컨테이너 반환
    if (_cachedVerseData == null) {
      return Container();
    }

    // 캐싱된 Future 사용 - 다운로드 시에도 동일한 이미지 사용
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            FutureBuilder<Map<String, String>>(
              future: _imageFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return OptimizedImage(
                    imagePath: _cachedVerseData!['image']!,
                    width: cardWidth,
                    height: cardHeight,
                    fit: BoxFit.cover,
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return OptimizedImage(
                    imagePath: _cachedVerseData!['image']!,
                    width: cardWidth,
                    height: cardHeight,
                    fit: BoxFit.cover,
                  );
                } else {
                  final imageData = snapshot.data!;
                  final imageUrl = imageData['url']!;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      OptimizedImage(
                        imagePath: imageUrl,
                        width: cardWidth,
                        height: cardHeight,
                        fit: BoxFit.cover,
                        placeholder: OptimizedImage(
                          imagePath: _cachedVerseData!['image']!,
                          width: cardWidth,
                          height: cardHeight,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: OptimizedImage(
                          imagePath: _cachedVerseData!['image']!,
                          width: cardWidth,
                          height: cardHeight,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            // Dimmed Overlay
            Container(
              color: Colors.black.withValues(alpha: 0.25),
            ),
            // Text Content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Verse Text
                    Text(
                      _cachedVerseData!['text']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nanumMyeongjo(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        height: 1.5,
                        decoration: TextDecoration.none,
                      ),
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 16),
                    // Verse Reference
                    Text(
                      _cachedVerseData!['reference']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nanumMyeongjo(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = widget.isThumbnail
        ? double.infinity
        : widget.isSquare
            ? screenWidth - 40
            : math.min(screenWidth - 32, 400.0);
    final cardHeight = widget.isThumbnail
        ? 200.0
        : widget.isSquare
            ? screenWidth - 40
            : cardWidth * 5 / 4;

    return FutureBuilder<Map<String, String>>(
      future: _verseDataFuture,
      builder: (context, verseSnapshot) {
        // 로딩 중이거나 데이터가 없으면 로딩 표시
        if (!verseSnapshot.hasData) {
          return Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200],
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final verseData = verseSnapshot.data!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: _cardKey,
              child: Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FutureBuilder<Map<String, String>>(
                        // 캐싱된 Future 사용 - rebuild 시 깜빡임 방지
                        future: _imageFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return OptimizedImage(
                              imagePath: verseData['image']!,
                              width: cardWidth,
                              height: cardHeight,
                              fit: BoxFit.cover,
                            );
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return OptimizedImage(
                              imagePath: verseData['image']!,
                              width: cardWidth,
                              height: cardHeight,
                              fit: BoxFit.cover,
                            );
                          } else {
                            final imageData = snapshot.data!;
                            final imageUrl = imageData['url']!;

                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                OptimizedImage(
                                  imagePath: imageUrl,
                                  width: cardWidth,
                                  height: cardHeight,
                                  fit: BoxFit.cover,
                                  placeholder: OptimizedImage(
                                    imagePath: verseData['image']!,
                                    width: cardWidth,
                                    height: cardHeight,
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: OptimizedImage(
                                    imagePath: verseData['image']!,
                                width: cardWidth,
                                height: cardHeight,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  // Dimmed Overlay
                  Container(
                    color: Colors.black.withValues(alpha: 0.25),
                  ),
                  // Text Content
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Verse Text
                          Text(
                            verseData['text']!,
                            style: GoogleFonts.nanumMyeongjo(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: null,
                            overflow: TextOverflow.visible,
                          ),

                          const SizedBox(height: 24),

                          // Verse Reference
                          Text(
                            verseData['reference']!,
                            style: GoogleFonts.nanumMyeongjo(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
      },
    );
  }
}
