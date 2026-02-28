import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeveloperStoryPage extends StatelessWidget {
  const DeveloperStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('개발자 이야기', style: TextStyle(fontSize: 14)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '누군가가 오늘 하루를 살아갈 힘을, 말씀으로 얻었으면 좋겠습니다.',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(height: 18),
            Text(
              '우리 교회 청년들은 "마음의 양식"이라는 이름으로, 매일 말씀 카드를 직접 만들어 카카오톡 채팅방에 올립니다.\n\n'
              '짧은 구절 하나가 누군가의 하루를 붙잡아주는 걸 보면서, 이 흐름을 앱으로 만들고 싶었습니다. 매일 아침, 스마트폰을 열면 말씀 한 장이 먼저 당신을 맞이하는 것처럼.\n'
              "이 앱은 '버티는 힘'이 필요한 사람을 위해 만들었습니다.\n\n"
              '어제와 다르게 살고 싶은 날, 마음이 흔들려 중심을 잃은 날, 아무 이유 없이 스스로가 낯설게 느껴지는 날. 그런 순간에 앱을 열면 말씀이 조용히 방향을 가리킵니다.\n\n'
              '저도 그런 경험이 있습니다. 부모님께 상처를 드리고 나서 마음이 무거웠던 날, 무심코 들어간 말씀묵상 앱에서 "네 부모를 공경하라 이것은 약속이 있는 첫 계명이니" (에베소서 6:2) 말씀 카드가 보였습니다.\n\n'
              '변명하려던 마음이 무너지고, 그 자리에 반성이 들어왔습니다. 또 하나님 없이 내 뜻대로만 밀어붙이다 길을 잃었을 때는, 말씀 앞에서 무릎을 꿇는 것 외에 다른 방법이 없었습니다.\n'
              '말씀은 정죄하지 않습니다. 다만, 돌아올 곳을 알려줍니다.\n\n'
              '이 앱을 통해 각자의 자리에서, 지하철 안에서도, 출근길 엘리베이터 안에서도, 잠들기 전 침대 위에서도 하나님을 마음에 담고 하루를 더 단단하게 살아가실 수 있기를 바랍니다.',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 15,
                height: 1.8,
                fontWeight: FontWeight.w400,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
