import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/text_theme.dart';
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
  
  bool get isSaving => _isSaving;

  @override
  void initState() {
    super.initState();
  }

  // Get verse data based on date
  Map<String, String> _getVerseData() {
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
    
    return VerseDatabase.getVerseByDate(targetDate);
  }

  // Public method for external access
  Future<void> saveCard() async {
    if (_isSaving) return;
    
    setState(() {
      _isSaving = true;
    });

    try {
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
        throw Exception('Unable to capture download widget');
      }
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      overlayEntry.remove();

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
    
    final verseData = _getVerseData();

    // ✨ [핵심 수정 1] Material 위젯으로 감싸서 노란 밑줄 문제 해결
    return Material(
      type: MaterialType.transparency, // 배경을 투명하게 설정
      child: Container(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            FutureBuilder<Map<String, String>>(
              // ✨ [핵심 수정 2] 다운로드용 카드에도 ID를 넘겨줘야 화면과 똑같은 이미지가 저장됨!
              future: UnsplashService.fetchDailyImage(
                query: 'sky',
                uniqueId: verseData['reference'], 
              ),
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
                  final author = imageData['author']!;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      OptimizedImage(
                        imagePath: imageUrl,
                        width: cardWidth,
                        height: cardHeight,
                        fit: BoxFit.cover,
                        placeholder: Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
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
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        height: 1.5,
                        decoration: TextDecoration.none, // 안전장치
                      ),
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 16),
                    // Verse Reference
                    Text(
                      verseData['reference']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none, // 안전장치
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
    
    final verseData = _getVerseData();

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
                    // ✨ [핵심 수정 3] 화면 표시용 카드에도 ID 적용 (잘하셨음!)
                    future: UnsplashService.fetchDailyImage(
                      query: 'sky',
                      uniqueId: verseData['reference'], 
                    ),
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
                        final author = imageData['author']!;

                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            OptimizedImage(
                              imagePath: imageUrl,
                              width: cardWidth,
                              height: cardHeight,
                              fit: BoxFit.cover,
                              placeholder: Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Pretendard',
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
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontFamily: 'Pretendard',
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
  }
}