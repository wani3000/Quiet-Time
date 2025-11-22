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
          backgroundColor: AppColors.warning, // AppColors가 없다면 Colors.orange로 대체하세요
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
        child: Padding(
          // 키보드가 올라왔을 때 하단 패딩을 자동으로 조절해줍니다.
          // (이미 showModalBottomSheet에서 처리했다면 bottom: 0으로 해도 되지만, 안전하게 20 유지)
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            // ✨ 핵심: 내용물 크기만큼만 높이를 차지하게 설정
            mainAxisSize: MainAxisSize.min, 
            children: [
              // 1. 헤더 (제목 + 닫기 버튼)
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
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. 텍스트 입력 필드
              Container(
                // 높이 계산 삭제 -> 대신 최대 높이만 제한 (너무 길어지면 스크롤)
                constraints: const BoxConstraints(
                  maxHeight: 200, // 텍스트 필드가 너무 커지지 않게 제한
                  minHeight: 120, // 최소 높이 확보
                ),
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null, // 줄바꿈 무제한
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

              // 3. 하단 버튼 (취소 / 저장)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                          backgroundColor: Colors.blue, // 브랜드 컬러에 맞게 수정 가능
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