import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../data/verse_database.dart';
import '../../../services/memo_service.dart';
import '../../../services/config_service.dart';
import '../../../core/utils/image_cache_manager.dart';

// 스크롤 위치를 페이지 외부에서 유지 (페이지가 다시 생성되어도 유지됨)
double _savedScrollOffset = 0.0;

class MeditationListPage extends ConsumerStatefulWidget {
  const MeditationListPage({super.key});

  @override
  ConsumerState<MeditationListPage> createState() => _MeditationListPageState();
}

class _MeditationListPageState extends ConsumerState<MeditationListPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // 저장된 스크롤 위치로 초기화
    _scrollController = ScrollController(initialScrollOffset: _savedScrollOffset);
    // 스크롤 위치 변경 시 저장
    _scrollController.addListener(_saveScrollPosition);
  }

  void _saveScrollPosition() {
    _savedScrollOffset = _scrollController.offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_saveScrollPosition);
    _scrollController.dispose();
    super.dispose();
  }

  String _getVersePreview(String date) {
    // VerseDatabase와 동일한 데이터 소스 사용
    final verseData = VerseDatabase.getVerseByDate(date);
    final fullText = verseData['text']!;
    
    // 말씀이 길면 30자까지만 보여주고 "..." 추가
    if (fullText.length > 30) {
      return '${fullText.substring(0, 30)}...';
    }
    return fullText;
  }


  // Group dates by month for section headers
  Map<String, List<DateTime>> _groupDatesByMonth(List<DateTime> dates) {
    final Map<String, List<DateTime>> grouped = {};
    
    for (final date in dates) {
      final monthKey = '${date.month}월';
      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = [];
      }
      grouped[monthKey]!.add(date);
    }
    
    return grouped;
  }

  // 썸네일 이미지 빌드
  Widget _buildThumbnailImage(String dateString) {
    final verseData = VerseDatabase.getVerseByDate(dateString);
    
    return FutureBuilder<String>(
      future: VerseDatabase.getImageUrlForDate(dateString),
      builder: (context, snapshot) {
        String imageUrl;
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 중에는 폴백 이미지 사용
          imageUrl = verseData['image']!;
        } else if (snapshot.hasError || !snapshot.hasData) {
          // 오류 시 폴백 이미지 사용
          imageUrl = verseData['image']!;
        } else {
          // Unsplash 이미지 사용
          imageUrl = snapshot.data!;
        }
        
        return Stack(
          fit: StackFit.expand,
          children: [
            // 배경 이미지
            OptimizedImage(
              imagePath: imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              placeholder: Container(
                color: const Color(0xFFD9D9D9),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF868E96)),
                  ),
                ),
              ),
              errorWidget: OptimizedImage(
                imagePath: verseData['image']!, // 폴백 이미지
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            // 어둡게 오버레이
            Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
            // 중앙 아이콘 (선택사항)
            const Center(
              child: Icon(
                Icons.article_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DateTime>(
      future: ConfigService.getInstallDate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        final installDate = snapshot.data ?? DateTime.now();
        final today = DateTime.now();
        
        // 설치 날짜부터 오늘까지의 날짜 생성 (역순)
        final daysDifference = today.difference(installDate).inDays;
        final dates = List.generate(daysDifference + 1, (index) {
          final date = today.subtract(Duration(days: index));
          return date;
        });

        final groupedDates = _groupDatesByMonth(dates);

        return _buildMeditationList(context, groupedDates);
      },
    );
  }
  
  Widget _buildMeditationList(BuildContext context, Map<String, List<DateTime>> groupedDates) {
    return Scaffold(
      backgroundColor: Colors.white, // 강제로 화이트 배경 설정
      appBar: AppBar(
        title: const Text(
          '묵상 기록',
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: Colors.white, // AppBar 배경도 화이트로
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        color: Colors.white, // 그라디언트 대신 단색 배경
        child: ListView(
          controller: _scrollController, // 스크롤 위치 유지를 위한 컨트롤러
          // ✨ [핵심 수정] 하단(bottom)에 120px 여유를 줘서 가려지지 않게 함
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
          children: [
            ...groupedDates.entries.map((entry) {
              final monthName = entry.key;
              final monthDates = entry.value;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      monthName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard',
                        color: Color(0xFF212529), // #212529
                        height: 1.4, // 28px line height for 20px font
                      ),
                    ),
                  ),
                  
                  // White container with cards
                  Column(
                    children: [
                        ...monthDates.asMap().entries.map((dateEntry) {
                          final dateIndex = dateEntry.key;
                          final date = dateEntry.value;
                          final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                          final displayDate = '${date.month}월 ${date.day}일';
                          
                          return Column(
                            children: [
                              // Card item
                              InkWell(
                                onTap: () {
                                  context.push('/meditation/detail/$dateString');
                                },
                                child: Container(
                                  height: 56,
                                  child: Row(
                                    children: [
                                      // 56x56 thumbnail - 실제 말씀카드 이미지
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: _buildThumbnailImage(dateString),
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 16),
                                      
                                      // Text content
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  displayDate,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Pretendard',
                                                    color: Color(0xFF212529), // #212529
                                                    height: 1.43, // 20px line height for 14px font
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                // 메모 있음 표시
                                                FutureBuilder<bool>(
                                                  future: MemoService.hasMemo(dateString),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data == true) {
                                                      return Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: AppColors.primary100,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: const Icon(
                                                          Icons.edit_note,
                                                          size: 12,
                                                          color: AppColors.primary600,
                                                        ),
                                                      );
                                                    }
                                                    return const SizedBox.shrink();
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _getVersePreview(dateString),
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Pretendard',
                                                color: Color(0xFF868E96), // #868E96
                                                height: 1.38, // 18px line height for 13px font
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Spacing between items (except last item)
                              if (dateIndex < monthDates.length - 1)
                                const SizedBox(height: 12),
                            ],
                          );
                      }).toList(),
                    ],
                  ),
                  
                  // Spacing between month sections
                  const SizedBox(height: 24),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}