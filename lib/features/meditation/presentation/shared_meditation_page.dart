import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/colors.dart';
// import '../../../data/verse_database.dart';
import '../../home/widgets/verse_card.dart';

class SharedMeditationPage extends ConsumerStatefulWidget {
  final String date;

  const SharedMeditationPage({
    super.key,
    required this.date,
  });

  @override
  ConsumerState<SharedMeditationPage> createState() => _SharedMeditationPageState();
}

class _SharedMeditationPageState extends ConsumerState<SharedMeditationPage> {
  // Map<String, String> _getVerseData() {
  //   return VerseDatabase.getVerseByDate(widget.date);
  // }

  void _launchAppDownload() async {
    // 앱 다운로드 링크 (임시 - 실제로는 App Store/Play Store 링크)
    const appStoreUrl = 'https://apps.apple.com/app/meditation';
    // const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.versecard.verseCardApp';
    
    try {
      // iOS인 경우 App Store, Android인 경우 Play Store로 이동
      // 웹에서는 일단 App Store로 이동
      if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
        await launchUrl(Uri.parse(appStoreUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('앱 다운로드 링크를 열 수 없습니다'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.tryParse(widget.date);
    final displayDate = parsedDate != null 
      ? '${parsedDate.year}년 ${parsedDate.month}월 ${parsedDate.day}일'
      : widget.date;

    // final verseData = _getVerseData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('말씀묵상'),
        elevation: 0,
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.slate50,
              AppColors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 공유 안내 메시지
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary100),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      color: AppColors.primary500,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '친구가 공유한 말씀묵상입니다',
                        style: TextStyle(
                          color: AppColors.primary700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 날짜
              Text(
                displayDate,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate700,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 말씀 카드
              VerseCard(
                date: widget.date,
                showButtons: false, // 공유 페이지에서는 버튼 숨김
              ),
              
              const SizedBox(height: 32),
              
              // 앱 다운로드 안내
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.slate900.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.phone_android,
                      size: 48,
                      color: AppColors.primary500,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      '말씀묵상 앱으로\n더 많은 묵상을 경험해보세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate700,
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      '매일 새로운 말씀과 함께\n깊이 있는 묵상의 시간을 가져보세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.slate500,
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 앱 다운로드 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _launchAppDownload,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primary500,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '앱 다운로드',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 하단 안내
              Text(
                '이 페이지는 말씀묵상 앱에서 공유된 콘텐츠입니다',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.slate400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
