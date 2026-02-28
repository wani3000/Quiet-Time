import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/notification_service.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _isLoading = true;
  bool _isSaving = false;
  NotificationScheduleSettings? _settings;

  static const List<String> _weekdayLabels = [
    '월요일',
    '화요일',
    '수요일',
    '목요일',
    '금요일',
    '토요일',
    '일요일',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await NotificationService.getScheduleSettings();
    if (!mounted) return;

    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  String _timeLabel(NotificationScheduleSettings settings) {
    final hour = settings.hour.toString().padLeft(2, '0');
    final minute = settings.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _frequencyGuideLabel(NotificationScheduleSettings settings) {
    if (settings.frequency == NotificationFrequency.daily) {
      return '매일 같은 시간에 알림을 보내요.';
    }
    if (settings.frequency == NotificationFrequency.weekly) {
      return '${_weekdayLabels[settings.weekday - 1]}마다 알림을 보내요.';
    }
    return '매달 ${settings.dayOfMonth}일에 알림을 보내요.';
  }

  String _frequencyLabel(NotificationScheduleSettings settings) {
    if (settings.frequency == NotificationFrequency.daily) {
      return '매일';
    }
    if (settings.frequency == NotificationFrequency.weekly) {
      return '매주 ${_weekdayLabels[settings.weekday - 1]}';
    }
    return '매달 ${settings.dayOfMonth}일';
  }

  Future<void> _saveSettings(NotificationScheduleSettings next) async {
    setState(() {
      _isSaving = true;
    });

    await NotificationService.updateScheduleSettings(next);

    if (!mounted) return;

    setState(() {
      _settings = next;
      _isSaving = false;
    });
  }

  Future<void> _toggleEnabled(bool enabled) async {
    final current = _settings;
    if (current == null) return;

    await _saveSettings(current.copyWith(enabled: enabled));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(enabled ? '알림을 켰습니다.' : '알림을 껐습니다.'),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  Future<void> _showTimePickerModal() async {
    final current = _settings;
    if (current == null) return;

    DateTime selectedDate = DateTime(2026, 1, 1, current.hour, current.minute);

    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildModalHandle(),
                const SizedBox(height: 20),
                const Text(
                  '알림 시간',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 210,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      initialDateTime: selectedDate,
                      onDateTimeChanged: (dateTime) {
                        selectedDate = dateTime;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _ModalActionButton(
                  text: '확인',
                  onTap: () => Navigator.pop(context, true),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true) return;

    final updated = current.copyWith(
      hour: selectedDate.hour,
      minute: selectedDate.minute,
    );
    await _saveSettings(updated);
  }

  Future<void> _showFrequencyPickerModal() async {
    final current = _settings;
    if (current == null) return;

    NotificationFrequency selectedFrequency = current.frequency;
    int selectedWeekday = current.weekday;
    int selectedDayOfMonth = current.dayOfMonth;

    final FixedExtentScrollController dayController =
        FixedExtentScrollController(initialItem: selectedDayOfMonth - 1);
    final FixedExtentScrollController weekdayController =
        FixedExtentScrollController(initialItem: selectedWeekday - 1);

    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget picker;
            if (selectedFrequency == NotificationFrequency.daily) {
              picker = const Center(
                child: Text(
                  '매일',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              );
            } else if (selectedFrequency == NotificationFrequency.weekly) {
              picker = CupertinoPicker(
                itemExtent: 44,
                scrollController: weekdayController,
                selectionOverlay: _pickerOverlay(),
                onSelectedItemChanged: (index) {
                  selectedWeekday = index + 1;
                },
                children: [
                  for (final label in _weekdayLabels)
                    Center(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              );
            } else {
              picker = CupertinoPicker(
                itemExtent: 44,
                scrollController: dayController,
                selectionOverlay: _pickerOverlay(),
                onSelectedItemChanged: (index) {
                  selectedDayOfMonth = index + 1;
                },
                children: [
                  for (int day = 1; day <= 31; day++)
                    Center(
                      child: Text(
                        '$day일',
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModalHandle(),
                    const SizedBox(height: 20),
                    const Text(
                      '받는 주기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FrequencyTabBar(
                      selectedFrequency: selectedFrequency,
                      onChanged: (next) {
                        setModalState(() {
                          selectedFrequency = next;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 210,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE9ECEF)),
                      ),
                      child: picker,
                    ),
                    const SizedBox(height: 16),
                    _ModalActionButton(
                      text: '확인',
                      onTap: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    dayController.dispose();
    weekdayController.dispose();

    if (confirmed != true) return;

    final updated = current.copyWith(
      frequency: selectedFrequency,
      weekday: selectedWeekday,
      dayOfMonth: selectedDayOfMonth,
    );
    await _saveSettings(updated);
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settings;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('알림설정', style: TextStyle(fontSize: 14)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading || settings == null
          ? const Center(child: CircularProgressIndicator())
          : AbsorbPointer(
              absorbing: _isSaving,
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '말씀 알림',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              settings.enabled
                                  ? '${_timeLabel(settings)} / ${_frequencyLabel(settings)}'
                                  : '현재 꺼짐',
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            if (settings.enabled) ...[
                              const SizedBox(height: 8),
                              Text(
                                _frequencyGuideLabel(settings),
                                style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SwitchListTile.adaptive(
                        value: settings.enabled,
                        onChanged: _toggleEnabled,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        title: const Text(
                          '알림 받기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        enabled: settings.enabled,
                        title: const Text(
                          '알림 시간',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          _timeLabel(settings),
                          style: const TextStyle(fontFamily: 'Pretendard'),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _showTimePickerModal,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        enabled: settings.enabled,
                        title: const Text(
                          '주기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          _frequencyLabel(settings),
                          style: const TextStyle(fontFamily: 'Pretendard'),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _showFrequencyPickerModal,
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '주기 안내: 매일은 매일 같은 시각, 매주는 선택한 요일 같은 시각, 매달은 선택한 날짜 같은 시각에 도착합니다.',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_isSaving)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Color(0x44FFFFFF),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

Widget _buildModalHandle() {
  return Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

Widget _pickerOverlay() {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFE9ECEF),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

class _ModalActionButton extends StatelessWidget {
  const _ModalActionButton({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(300),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _FrequencyTabBar extends StatelessWidget {
  const _FrequencyTabBar({
    required this.selectedFrequency,
    required this.onChanged,
  });

  final NotificationFrequency selectedFrequency;
  final ValueChanged<NotificationFrequency> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _tabItem('매일', NotificationFrequency.daily),
        _tabItem('매주', NotificationFrequency.weekly),
        _tabItem('매달', NotificationFrequency.monthly),
      ],
    );
  }

  Widget _tabItem(String label, NotificationFrequency frequency) {
    final bool selected = selectedFrequency == frequency;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(frequency),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? Colors.black : const Color(0xFFE5E7EB),
                width: selected ? 2 : 1,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.black : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
