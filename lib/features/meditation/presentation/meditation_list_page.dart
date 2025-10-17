import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../data/verse_database.dart';
import '../../../services/memo_service.dart';

class MeditationListPage extends ConsumerWidget {
  const MeditationListPage({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Generate dummy dates for the past 30 days
    final dates = List.generate(30, (index) {
      final date = DateTime.now().subtract(Duration(days: index));
      return date;
    });

    final groupedDates = _groupDatesByMonth(dates);

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
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
                                  context.go('/meditation/detail/$dateString');
                                },
                                child: Container(
                                  height: 56,
                                  child: Row(
                                    children: [
                                      // 56x56 thumbnail
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD9D9D9), // #D9D9D9
                                          borderRadius: BorderRadius.circular(8),
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
