import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/image_saver.dart';
import '../../../data/verse_database.dart';
import '../../../services/memo_service.dart';
import '../../../services/config_service.dart';
import '../../home/widgets/verse_card.dart';

class MeditationDetailPage extends ConsumerStatefulWidget {
  final String date;
  
  const MeditationDetailPage({
    super.key,
    required this.date,
  });

  @override
  ConsumerState<MeditationDetailPage> createState() => _MeditationDetailPageState();
}

class _MeditationDetailPageState extends ConsumerState<MeditationDetailPage> {
  String _savedNote = '';
  bool _isDownloading = false;
  bool _isLoadingNote = true;
  bool _isSavingNote = false;
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    try {
      setState(() {
        _isLoadingNote = true;
      });
      
      final note = await MemoService.getMemo(widget.date);
      
      if (mounted) {
        setState(() {
          _savedNote = note;
          _isLoadingNote = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _savedNote = '';
          _isLoadingNote = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('메모를 불러오는 중 오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Map<String, String> _getVerseData() {
    // VerseCard와 동일한 데이터 소스 사용
    return VerseDatabase.getVerseByDate(widget.date);
  }

  String _getVerseText() {
    return _getVerseData()['text']!;
  }

  String _getVerseReference() {
    return _getVerseData()['reference']!;
  }

  Future<void> _copyVerseToClipboard() async {
    final verseText = _getVerseText();
    final reference = _getVerseReference();
    final textToCopy = '$verseText\n\n$reference';
    
    await Clipboard.setData(ClipboardData(text: textToCopy));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('말씀이 복사되었습니다'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  Future<void> _downloadCard() async {
    if (_isDownloading) return;
    
    setState(() {
      _isDownloading = true;
    });

    try {
      // Wait a bit to ensure RepaintBoundary is ready
      await Future.delayed(const Duration(milliseconds: 100));
      
      final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('RepaintBoundary not found');
      }
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      
      if (pngBytes == null) {
        throw Exception('Failed to generate image bytes');
      }
      
      final success = await ImageSaver.saveToGallery(pngBytes);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '말씀카드가 다운로드되었습니다' : '다운로드에 실패했습니다'),
            backgroundColor: success ? AppColors.primary500 : AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('다운로드 중 오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  Future<void> _saveNote(String noteText) async {
    if (!mounted) return;
    
    try {
      setState(() {
        _isSavingNote = true;
      });
      
      debugPrint('_saveNote 호출: date=${widget.date}, noteText=${noteText.length}자');
      final success = await MemoService.saveMemo(widget.date, noteText);
      debugPrint('MemoService.saveMemo 결과: $success');
      
      if (mounted) {
        setState(() {
          _savedNote = noteText;
          _isSavingNote = false;
        });
        
        // 성공했을 때만 성공 메시지 표시
        if (success) {
          debugPrint('성공 메시지 표시');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('메모가 저장되었습니다'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          debugPrint('실패 메시지 표시');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('메모 저장에 실패했습니다'),
              backgroundColor: AppColors.error,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSavingNote = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('메모 저장 중 오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showEditMemoModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 키보드에 맞춰 크기 조정
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 패딩
          ),
          child: _MemoEditModal(
            initialText: _savedNote,
            isNewMemo: _savedNote.isEmpty,
            onSave: (String text) {
              _saveNote(text);
            },
          ),
        );
      },
    );
  }

  // Web Share API 지원 여부 확인 (iOS에서는 항상 false)
  bool _isWebShareSupported() {
    return false;
  }

  // Web Share API 호출 (iOS에서는 항상 false 반환)
  Future<bool> _webShare(String title, String text, String url) async {
    return false;
  }

  void _shareMeditation() async {
    final verseRef = _getVerseReference();
    final shareUrl = ConfigService.getShareUrl(widget.date);
    final shareText = '$verseRef\n\n오늘의 묵상을 함께 나누어요!';
    
    if (kIsWeb) {
      // 웹에서는 Web Share API 직접 호출 (Safari 네이티브 공유 시트)
      debugPrint('Web Share API 지원 여부: ${_isWebShareSupported()}');
      
      if (_isWebShareSupported()) {
        try {
          debugPrint('Web Share API 직접 호출 시도');
          final success = await _webShare(
            '말씀묵상 공유', 
            shareText, 
            shareUrl
          );
          
          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('공유가 완료되었습니다'),
                backgroundColor: AppColors.primary500,
                duration: Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          debugPrint('Web Share API 호출 실패: $e');
          _fallbackWebShare(shareText, shareUrl);
        }
      } else {
        debugPrint('Web Share API 미지원, 폴백 사용');
        _fallbackWebShare(shareText, shareUrl);
      }
    } else {
      // iOS/Android 앱에서는 OS 기본 공유 기능 사용
      try {
        await Share.share(shareText, subject: '말씀묵상 공유');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('공유에 실패했습니다'),
              backgroundColor: AppColors.error,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  void _fallbackWebShare(String shareText, String shareUrl) {
    if (mounted) {
      // 클립보드에 복사
      Clipboard.setData(ClipboardData(text: '$shareText\n\n$shareUrl'));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('링크가 클립보드에 복사되었습니다'),
          backgroundColor: AppColors.primary500,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateBack() {
    // iOS 스타일의 간단한 뒤로가기
    context.go('/meditation');
  }







  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.tryParse(widget.date);
    final displayDate = parsedDate != null 
      ? '${parsedDate.year}년 ${parsedDate.month}월 ${parsedDate.day}일'
      : widget.date;

    return Scaffold(
      backgroundColor: Colors.white, // 강제로 화이트 배경 설정
      extendBody: true, // body가 bottomNavigationBar 뒤로 확장되도록
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경도 화이트로
        title: Text(
          displayDate,
          style: const TextStyle(fontSize: 14),
        ),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateBack,
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24), // px-5 py-6
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verse Card Thumbnail
            GestureDetector(
              onTap: () {
                context.go('/meditation/detail/${widget.date}/fullscreen');
              },
              child: RepaintBoundary(
                key: _cardKey,
                child: VerseCard(
                  isThumbnail: false,
                  showActions: false,
                  date: widget.date,
                  isSquare: true, // Use square size for detail page
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Sample Verse Text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.slate50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.slate200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '오늘의 말씀',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate800,
                        ),
                      ),
                      GestureDetector(
                        onTap: _copyVerseToClipboard,
                        child: const Text(
                          '복사',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getVerseText(),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: AppColors.slate700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _getVerseReference(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.slate600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Note Section
            const Text(
              '묵상 메모',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.slate800,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 120),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.slate50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.slate200),
              ),
              child: _isLoadingNote
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(strokeWidth: 2),
                          SizedBox(height: 12),
                          Text(
                            '메모를 불러오는 중...',
                            style: TextStyle(
                              color: AppColors.slate500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _savedNote.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '아직 작성된 메모가 없습니다.\n"묵상 시작하기" 버튼을 눌러 메모를 작성해보세요.',
                          style: TextStyle(
                            color: AppColors.slate500,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 160,
                          child: ElevatedButton(
                            onPressed: _isSavingNote ? null : _showEditMemoModal,
                            child: _isSavingNote 
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                  )
                                : Text(
                                    '묵상 시작하기',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black, // 텍스트 컬러를 블랙으로
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // 배경 컬러 제거 (화이트)
                              foregroundColor: Colors.black, // 전경 컬러를 블랙으로
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(200), // radius를 200으로
                                side: const BorderSide(
                                  color: Colors.black, // stroke 컬러를 블랙으로
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _savedNote,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: AppColors.slate700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 160,
                          child: ElevatedButton(
                            onPressed: _isSavingNote ? null : _showEditMemoModal,
                            child: _isSavingNote 
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                  )
                                : Text(
                                    '묵상 수정하기',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black, // 텍스트 컬러를 블랙으로
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // 배경 컬러 제거 (화이트)
                              foregroundColor: Colors.black, // 전경 컬러를 블랙으로
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(200), // radius를 200으로
                                side: const BorderSide(
                                  color: Colors.black, // stroke 컬러를 블랙으로
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            
            // 하단 여백 (플로팅 버튼을 위한 공간)
            const SizedBox(height: 120),
          ],
          ),
        ),
      ),
      bottomNavigationBar: _buildFloatingActionButtons(),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), // 좌우 24px, 하단 24px 마진
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFF1F3F5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(200), // 전체 모서리를 둥글게
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
        padding: const EdgeInsets.symmetric(
          horizontal: 56,  // 좌우 패딩
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionButton(
              icon: _isDownloading 
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.slate600),
                    )
                  : const Icon(Icons.download, size: 24),
              label: _isDownloading ? '처리중...' : '다운로드',
              onTap: _isDownloading ? null : _downloadCard,
              isLoading: _isDownloading,
            ),
            _buildActionButton(
              icon: const Icon(Icons.share, size: 24),
              label: '공유하기',
              onTap: _shareMeditation,
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required Widget icon,
    required String label,
    required VoidCallback? onTap,
    required bool isLoading,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                color: isLoading ? AppColors.slate400 : AppColors.slate800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoEditModal extends StatefulWidget {
  final String initialText;
  final Function(String) onSave;
  final bool isNewMemo;

  const _MemoEditModal({
    required this.initialText,
    required this.onSave,
    required this.isNewMemo,
  });

  @override
  State<_MemoEditModal> createState() => _MemoEditModalState();
}

class _MemoEditModalState extends State<_MemoEditModal> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    final text = _controller.text.trim();
    
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('메모 내용을 입력해주세요'),
          backgroundColor: AppColors.warning,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    Navigator.of(context).pop();
    widget.onSave(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isNewMemo ? '묵상 시작하기' : '묵상 수정하기',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      minLines: 6,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: widget.isNewMemo 
                            ? '오늘 말씀을 통해 받은 은혜나 깨달음을 기록해보세요...'
                            : '묵상 메모를 수정해보세요...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black,
                      ),
                      autofocus: true,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          side: BorderSide(color: Colors.grey[300]!),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '저장하기',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
