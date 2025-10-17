import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/utils/image_saver.dart';
import '../../../core/utils/image_cache_manager.dart';
import '../../../data/verse_database.dart';

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
  State<VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends State<VerseCard> {
  final GlobalKey _cardKey = GlobalKey();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
  }

  // Get verse data based on date
  Map<String, String> _getVerseData() {
    String targetDate;
    
    if (widget.date != null) {
      // 특정 날짜가 지정된 경우 그 날짜 사용
      targetDate = widget.date!;
    } else {
      // 홈 화면에서 호출된 경우 (date가 null)
      final now = DateTime.now();
      
      // 오전 6시 이전이면 전날 말씀 표시
      if (now.hour < 6) {
        final yesterday = now.subtract(const Duration(days: 1));
        targetDate = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      } else {
        // 오전 6시 이후면 오늘 말씀 표시
        targetDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      }
    }
    
    return VerseDatabase.getVerseByDate(targetDate);
  }

  Future<void> _saveCard() async {
    if (_isSaving) return;
    
    setState(() {
      _isSaving = true;
    });

    try {
      // Capture the widget as image
      final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Unable to capture widget');
      }

      // Wait a bit for the widget to be fully rendered
      await Future.delayed(const Duration(milliseconds: 100));
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Save using ImageSaver
      final success = await ImageSaver.saveToGallery(pngBytes);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '말씀 카드가 저장되었습니다!' : '저장에 실패했습니다.'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('저장에 실패했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = widget.isThumbnail 
        ? double.infinity 
        : widget.isSquare
            ? screenWidth - 40 // Screen width minus padding (20px on each side)
            : math.min(screenWidth - 32, 400.0); // 16px padding on each side, max 400px width
    final cardHeight = widget.isThumbnail 
        ? 200.0 // Fixed height for thumbnail
        : widget.isSquare
            ? screenWidth - 40 // Square aspect ratio matching width
            : cardWidth * 5 / 4; // 4:5 aspect ratio for Instagram-style card (width * 5/4)
    
    final verseData = _getVerseData();

    return Column(
      mainAxisSize: MainAxisSize.min, // Important: set to minimum size
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
                  // Background Image - 최적화된 이미지 로딩
                  OptimizedImage(
                    imagePath: verseData['image']!,
                    width: cardWidth,
                    height: cardHeight,
                    fit: BoxFit.cover,
                    placeholder: Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  // Dimmed Overlay
                  Container(
                    color: Colors.black.withValues(alpha: 0.4), // 40% dimmed
                  ),
                  // Download Button (positioned on top of card)
                  if (widget.showActions && widget.showButtons)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: _isSaving ? null : _saveCard,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.3),
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: _isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/images/ic_download.svg',
                                    width: 24,
                                    height: 24,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                    placeholderBuilder: (context) => const Icon(
                                      Icons.download,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  // Text Content
                  Positioned.fill( // Use Positioned.fill to make text fill the stack
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, // Center text horizontally
                        children: [
                          // Verse Text
                          Text(
                            verseData['text']!,
                            style: AppTextTheme.verseText,
                            textAlign: TextAlign.center,
                            maxLines: null, // Allow unlimited lines
                            overflow: TextOverflow.visible, // Allow text to overflow if needed
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Verse Reference
                          Text(
                            verseData['reference']!,
                            style: AppTextTheme.verseReference,
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