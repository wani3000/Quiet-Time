import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/image_saver.dart';
import '../../../core/utils/toast_utils.dart';
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
        
        ToastUtils.showError(context, '메모를 불러오는 중 오류가 발생했어요');
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
      ToastUtils.show(context, '말씀이 복사되었어요');
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
        ToastUtils.show(context, success ? '말씀카드를 갤러리에 다운로드 했어요!' : '다운로드에 실패했어요');
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(context, '다운로드에 실패했어요');
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
          ToastUtils.showSuccess(context, '메모가 저장되었어요');
        } else {
          debugPrint('실패 메시지 표시');
          ToastUtils.showError(context, '메모 저장에 실패했어요');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSavingNote = false;
        });
        
        ToastUtils.showError(context, '메모 저장에 실패했어요');
      }
    }
  }

  void _showEditMemoModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 키보드에 맞춰 크기 조정
      backgroundColor: const Color(0xFFD1D3D9), // iOS 키보드 배경색과 유사
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

  void _shareMeditation() {
    // 공유 옵션 선택 모달 표시
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 핸들바
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '공유하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(height: 20),
                // 말씀만 공유하기
                _buildShareOption(
                  icon: Icons.format_quote,
                  title: '말씀만 공유하기',
                  subtitle: '오늘의 말씀과 이미지를 공유해요',
                  onTap: () {
                    Navigator.pop(context);
                    _executeShare(includeMemo: false);
                  },
                ),
                const SizedBox(height: 12),
                // 말씀과 묵상메모 공유하기
                _buildShareOption(
                  icon: Icons.edit_note,
                  title: '말씀과 내 묵상메모 공유하기',
                  subtitle: _savedNote.isEmpty 
                      ? '아직 작성된 묵상메모가 없어요' 
                      : '말씀과 나의 묵상을 함께 공유해요',
                  enabled: _savedNote.isNotEmpty,
                  onTap: _savedNote.isNotEmpty ? () {
                    Navigator.pop(context);
                    _executeShare(includeMemo: true);
                  } : null,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enabled ? Colors.grey[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled ? Colors.grey[200]! : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: enabled ? Colors.black : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                      color: enabled ? Colors.black : Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Pretendard',
                      color: enabled ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: enabled ? Colors.grey[400] : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _executeShare({required bool includeMemo}) async {
    final verseText = _getVerseText();
    final verseRef = _getVerseReference();
    
    String shareText;
    if (includeMemo && _savedNote.isNotEmpty) {
      shareText = '$verseText\n\n- $verseRef\n\n📝 나의 묵상\n$_savedNote\n\n#말씀묵상 #오늘의말씀';
    } else {
      shareText = '$verseText\n\n- $verseRef\n\n#말씀묵상 #오늘의말씀';
    }
    
    // 공유 시트 위치 (iPad/시뮬레이터용)
    final box = context.findRenderObject() as RenderBox?;
    final sharePositionOrigin = box != null 
        ? Rect.fromLTWH(0, 0, box.size.width, box.size.height / 2)
        : null;
    
    if (kIsWeb) {
      // 웹에서는 텍스트만 공유
      _fallbackWebShare(shareText, ConfigService.getShareUrl(widget.date));
    } else {
      // iOS/Android 앱에서는 이미지와 함께 공유
      try {
        // 말씀 카드 이미지 생성
        final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary == null) {
          // 이미지 생성 실패 시 텍스트만 공유
          await Share.share(shareText, subject: '오늘의 말씀', sharePositionOrigin: sharePositionOrigin);
          return;
        }
        
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData?.buffer.asUint8List();
        
        if (pngBytes == null) {
          await Share.share(shareText, subject: '오늘의 말씀', sharePositionOrigin: sharePositionOrigin);
          return;
        }
        
        // 임시 파일로 저장
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/verse_card_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(pngBytes);
        
        // 이미지와 텍스트 함께 공유
        await Share.shareXFiles(
          [XFile(file.path)],
          text: shareText,
          subject: '오늘의 말씀',
          sharePositionOrigin: sharePositionOrigin,
        );
        
        // 임시 파일 삭제
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('공유 실패: $e');
        if (mounted) {
          // 실패 시 텍스트만 공유 시도
          try {
            await Share.share(shareText, subject: '오늘의 말씀', sharePositionOrigin: sharePositionOrigin);
          } catch (e2) {
            ToastUtils.showError(context, '공유에 실패했어요');
          }
        }
      }
    }
  }

  void _fallbackWebShare(String shareText, String shareUrl) {
    if (mounted) {
      // 클립보드에 복사
      Clipboard.setData(ClipboardData(text: '$shareText\n\n$shareUrl'));
      ToastUtils.show(context, '링크가 클립보드에 복사되었어요');
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

    return GestureDetector(
      // 좌→우 스와이프로 뒤로가기
      onHorizontalDragEnd: (details) {
        // 스와이프 속도가 충분히 빠르고, 오른쪽 방향일 때
        if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
          _navigateBack();
        }
      },
      child: Scaffold(
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
            RepaintBoundary(
              key: _cardKey,
              child: VerseCard(
                isThumbnail: false,
                showActions: false,
                date: widget.date,
                isSquare: false, // 홈과 동일한 5:4 비율 사용
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
                            color: Colors.black,
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
                  Text(
                    _getVerseReference(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.slate600,
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
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    '묵상 시작하기',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(300),
                              ),
                              elevation: 0,
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
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    '묵상 수정하기',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(300),
                              ),
                              elevation: 0,
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
      ),
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
      ToastUtils.show(context, '메모 내용을 입력해주세요');
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
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
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
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // 텍스트 입력 영역 (고정 높이)
              Container(
                height: 200, // 고정 높이로 키보드가 올라와도 적절히 보임
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  textAlignVertical: TextAlignVertical.top,
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
              // 버튼 영역
              Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(300),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '저장하기',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
