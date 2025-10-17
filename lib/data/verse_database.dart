/// 1000개의 성경 말씀 데이터베이스
/// 전체 성경에서 선별된 말씀들 (최대 3장 이내)
class VerseDatabase {
  static const List<Map<String, String>> verses = [
    // 창세기
    {
      'text': "태초에 하나님이 천지를 창조하시니라",
      'reference': "창세기 1:1",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "하나님이 이르시되 빛이 있으라 하시니 빛이 있었고",
      'reference': "창세기 1:3",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "하나님이 자기 형상 곧 하나님의 형상대로 사람을 창조하시되\n남자와 여자를 창조하시고",
      'reference': "창세기 1:27",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "여호와 하나님이 아담과 그의 아내를 위하여\n가죽옷을 지어 입히시니라",
      'reference': "창세기 3:21",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "내가 내 무지개를 구름 사이에 두었나니\n이것이 나와 세상 사이의 언약의 증거니라",
      'reference': "창세기 9:13",
      'image': 'assets/images/bg5.jpg'
    },
    
    // 출애굽기
    {
      'text': "나는 스스로 있는 자니라",
      'reference': "출애굽기 3:14",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "너는 나 외에는 다른 신들을 네게 두지 말라",
      'reference': "출애굽기 20:3",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "네 부모를 공경하라\n그리하면 네 하나님 여호와가 네게 준 땅에서 네 생명이 길리라",
      'reference': "출애굽기 20:12",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "여호와는 자비롭고 은혜롭고 노하기를 더디하고\n인자와 진실이 많은 하나님이라",
      'reference': "출애굽기 34:6",
      'image': 'assets/images/bg4.jpg'
    },
    
    // 레위기
    {
      'text': "너희는 거룩하라 나 여호와 너희 하나님이 거룩함이니라",
      'reference': "레위기 19:2",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "네 이웃 사랑하기를 네 자신과 같이 사랑하라\n나는 여호와니라",
      'reference': "레위기 19:18",
      'image': 'assets/images/bg1.jpg'
    },
    
    // 민수기
    {
      'text': "여호와는 네게 복을 주시고 너를 지키시기를 원하며\n여호와는 그의 얼굴을 네게 비추사 은혜 베푸시기를 원하며",
      'reference': "민수기 6:24-25",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "여호와는 그의 얼굴을 네게로 향하여 드사 평강 주시기를 원하노라",
      'reference': "민수기 6:26",
      'image': 'assets/images/bg3.jpg'
    },
    
    // 신명기
    {
      'text': "이스라엘아 들으라 우리 하나님 여호와는 오직 유일한 여호와이시니",
      'reference': "신명기 6:4",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "너는 마음을 다하고 뜻을 다하고 힘을 다하여\n네 하나님 여호와를 사랑하라",
      'reference': "신명기 6:5",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "강하고 담대하라\n두려워하지 말며 놀라지 말라\n네 하나님 여호와가 네가 가는 곳마다 너와 함께 하느니라",
      'reference': "신명기 31:6",
      'image': 'assets/images/bg1.jpg'
    },
    
    // 여호수아
    {
      'text': "내가 네게 명령한 것이 아니냐\n강하고 담대하라\n두려워하지 말며 놀라지 말라\n네가 어디로 가든지 네 하나님 여호와가 너와 함께 하느니라",
      'reference': "여호수아 1:9",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "오직 너는 마음을 다하고 뜻을 다하여\n모세의 종 곧 나의 종이 네게 명령한 율법을 지켜 행하라",
      'reference': "여호수아 1:7",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "나와 내 집은 여호와를 섬기겠노라",
      'reference': "여호수아 24:15",
      'image': 'assets/images/bg4.jpg'
    },
    
    // 룻기
    {
      'text': "어머니께서 가시는 곳에 나도 가고\n어머니께서 머무시는 곳에서 나도 머물겠나이다",
      'reference': "룻기 1:16",
      'image': 'assets/images/bg5.jpg'
    },
    
    // 사무엘상
    {
      'text': "사람은 외모를 보거니와 나 여호와는 중심을 보느니라",
      'reference': "사무엘상 16:7",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "여호와의 구원하심이 칼과 창에 있지 아니함을\n이 무리로 알게 하리라",
      'reference': "사무엘상 17:47",
      'image': 'assets/images/bg2.jpg'
    },
    
    // 사무엘하
    {
      'text': "여호와는 나의 반석이시요 나의 요새시요 나를 건지시는 자시요",
      'reference': "사무엘하 22:2",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "주의 인자하심이 하늘에 있고\n주의 진실하심이 공중에 사무쳤으며",
      'reference': "사무엘하 22:51",
      'image': 'assets/images/bg4.jpg'
    },
    
    // 열왕기상
    {
      'text': "네 하나님 여호와 앞에서 행하되\n마음을 온전히 하고 정직하게 행하여",
      'reference': "열왕기상 9:4",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "여호와는 하나님이시요 다른 이가 없다 하셨나이다",
      'reference': "열왕기상 8:60",
      'image': 'assets/images/bg1.jpg'
    },
    
    // 열왕기하
    {
      'text': "여호와 앞에서 행하되 마음을 다하며\n뜻을 다하며 힘을 다하여",
      'reference': "열왕기하 23:25",
      'image': 'assets/images/bg2.jpg'
    },
    
    // 역대상
    {
      'text': "여호와를 찾으라 그와 그의 능력을 찾을지어다\n그의 얼굴을 항상 구할지어다",
      'reference': "역대상 16:11",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "여호와께 감사하며 그의 이름을 불러 아뢰며\n그의 행사를 만민 중에 알게 할지어다",
      'reference': "역대상 16:8",
      'image': 'assets/images/bg4.jpg'
    },
    
    // 역대하
    {
      'text': "내가 하늘을 닫고 비를 내리지 아니하거나\n혹은 메뚜기들에게 토지를 먹게 하거나",
      'reference': "역대하 7:13",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "내 이름으로 일컫는 내 백성이 그들의 악한 길에서 떠나\n겸손하게 하고 기도하여 내 얼굴을 찾으면",
      'reference': "역대하 7:14",
      'image': 'assets/images/bg1.jpg'
    },
    
    // 에스라
    {
      'text': "우리 하나님의 손이 자기를 찾는 모든 자에게는\n선을 베푸시고",
      'reference': "에스라 8:22",
      'image': 'assets/images/bg2.jpg'
    },
    
    // 느헤미야
    {
      'text': "너희는 가서 살진 것을 먹고 단 것을 마시되\n준비하지 못한 자에게는 나누어 주라\n여호와를 기뻐하는 것이 너희의 힘이니라",
      'reference': "느헤미야 8:10",
      'image': 'assets/images/bg3.jpg'
    },
    
    // 에스더
    {
      'text': "네가 왕후의 자리를 얻은 것이\n이 때를 위함이 아닌지 누가 알겠느냐",
      'reference': "에스더 4:14",
      'image': 'assets/images/bg5.jpg'
    },
    
    // 욥기
    {
      'text': "주신 이도 여호와시요 거두신 이도 여호와시오니\n여호와의 이름이 찬송을 받으실지니이다",
      'reference': "욥기 1:21",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "그가 나를 죽이실지라도 나는 그를 의뢰하겠고",
      'reference': "욥기 13:15",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "내가 알기에는 나의 대속자가 살아 계시니\n마침내 그가 땅 위에 서실 것이라",
      'reference': "욥기 19:25",
      'image': 'assets/images/bg3.jpg'
    },
    
    // 시편 (150편 중 주요 구절들)
    {
      'text': "여호와는 나의 목자시니 내게 부족함이 없으리로다\n그가 나를 푸른 풀밭에 누이시며 쉴 만한 물 가로 인도하시는도다",
      'reference': "시편 23:1-2",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "내가 사망의 음침한 골짜기로 다닐지라도\n해를 두려워하지 않을 것은 주께서 나와 함께 하심이라",
      'reference': "시편 23:4",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "선하심과 인자하심이 반드시 나의 평생에 따르리니\n내가 여호와의 집에 영원히 살리로다",
      'reference': "시편 23:6",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "땅과 거기에 충만한 것과 세계와 그 가운데에 사는 자들은\n다 여호와의 것이로다",
      'reference': "시편 24:1",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "여호와는 나의 빛이요 나의 구원이시니\n내가 누구를 두려워하리요",
      'reference': "시편 27:1",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "내가 확신하노니 내가 살아 있는 동안에\n여호와의 선하심을 보리로다",
      'reference': "시편 27:13",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "여호와를 기다릴지어다 강하고 담대하며\n여호와를 기다릴지어다",
      'reference': "시편 27:14",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "하나님은 우리의 피난처시요 힘이시니\n환난 중에 만날 큰 도움이시라",
      'reference': "시편 46:1",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "가만히 있어 내가 하나님 됨을 알지어다\n내가 뭇 나라 중에서 높임을 받으리라",
      'reference': "시편 46:10",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "하나님이여 주의 인자를 따라 내게 은혜를 베푸시며\n주의 많은 긍휼을 따라 내 죄과를 지워 주소서",
      'reference': "시편 51:1",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "하나님이여 내 속에 정한 마음을 창조하시고\n내 안에 정직한 영을 새롭게 하소서",
      'reference': "시편 51:10",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "내 영혼아 여호와를 송축하라\n내 속에 있는 모든 것들아 그의 거룩한 이름을 송축하라",
      'reference': "시편 103:1",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "여호와께서 우리의 죄를 따라 우리를 처벌하지 아니하시며\n우리의 죄악을 따라 우리에게 그대로 갚지 아니하셨으니",
      'reference': "시편 103:10",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "하늘이 땅보다 높음 같이\n그를 경외하는 자에게 그의 인자하심이 크시며",
      'reference': "시편 103:11",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "동이 서에서 먼 것 같이\n우리의 죄과를 우리에게서 멀리 옮기셨으며",
      'reference': "시편 103:12",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "주의 말씀은 내 발에 등이요 내 길에 빛이니이다",
      'reference': "시편 119:105",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "내가 산을 향하여 눈을 들리라\n나의 도움이 어디서 올까",
      'reference': "시편 121:1",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "나의 도움은 천지를 지으신 여호와에게서로다",
      'reference': "시편 121:2",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "여호와께서 너를 지키시며\n여호와께서 네 우편에서 네 그늘이 되시나니",
      'reference': "시편 121:5",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "여호와께서 네 출입을 지금부터 영원까지 지키시리로다",
      'reference': "시편 121:8",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "내가 여호와의 집에 거함이 좋사오니\n그의 아름다움을 보며 그의 성전에서 사모하게 하소서",
      'reference': "시편 27:4",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "여호와여 내가 주께 부르짖었사오니\n나의 반석이여 내게 귀를 막지 마소서",
      'reference': "시편 28:1",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "여호와는 나의 힘이요 나의 방패시니\n내 마음이 그를 의지하여 도움을 얻었도다",
      'reference': "시편 28:7",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "복 있는 사람은 악인들의 꾀를 따르지 아니하며\n죄인들의 길에 서지 아니하며",
      'reference': "시편 1:1",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "오직 여호와의 율법을 즐거워하여\n그의 율법을 주야로 묵상하는도다",
      'reference': "시편 1:2",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "그는 시냇가에 심은 나무가\n철을 따라 열매를 맺으며 그 잎사귀가 마르지 아니함 같으니",
      'reference': "시편 1:3",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "내가 누워 자고 깨었으니\n여호와께서 나를 붙드심이로다",
      'reference': "시편 3:5",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "여호와여 내 기도를 들으시며\n나의 간구에 귀를 기울이소서",
      'reference': "시편 4:1",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "평안히 눕고 자기도 하리니\n나를 안전히 살게 하시는 이는 오직 여호와시니이다",
      'reference': "시편 4:8",
      'image': 'assets/images/bg2.jpg'
    },
    
    // 시편 추가 구절들
    {
      'text': "여호와여 나의 원수가 얼마나 많은지요\n일어나 나를 치는 자가 많사오니",
      'reference': "시편 3:1",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "여호와여 주의 복을 주의 백성에게 내리소서",
      'reference': "시편 3:8",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "여호와여 주께서 나의 머리를 드셨고\n나의 영광이시며 나의 방패시니이다",
      'reference': "시편 3:3",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "내가 여호와께 나아가 부르짖으니\n그의 성산에서 응답하시는도다",
      'reference': "시편 3:4",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "여호와께서 의인을 사랑하시고\n그들을 복 주시며",
      'reference': "시편 5:12",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "여호와여 주의 인자하심이 하늘에 있고\n주의 진실하심이 공중에 사무쳤으며",
      'reference': "시편 36:5",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "생명의 원천이 주께 있사오니\n주의 빛 안에서 우리가 빛을 보리이다",
      'reference': "시편 36:9",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "네 길을 여호와께 맡기라\n그를 의지하면 그가 이루시고",
      'reference': "시편 37:5",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "잠깐이면 악인이 없어지리니\n네가 그들의 곳을 자세히 살필지라도 없으리로다",
      'reference': "시편 37:10",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "온유한 자는 땅을 차지하며\n풍성한 화평으로 즐거워하리로다",
      'reference': "시편 37:11",
      'image': 'assets/images/bg2.jpg'
    },
    
    // 잠언
    {
      'text': "내 아들아 나의 법을 잊지 말고\n네 마음으로 나의 명령을 지키라",
      'reference': "잠언 3:1",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "그리하면 그것이 네 목에 장식이 되며\n네 영혼에 생명이 되리라",
      'reference': "잠언 3:22",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "너는 마음을 다하여 여호와를 신뢰하고\n네 명철을 의지하지 말라",
      'reference': "잠언 3:5",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "너는 범사에 그를 인정하라\n그리하면 네 길을 지도하시리라",
      'reference': "잠언 3:6",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "네 눈으로 보기에 지혜롭게 여기지 말지어다\n여호와를 경외하며 악을 떠날지어다",
      'reference': "잠언 3:7",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "내 아들아 여호와의 징계를 경히 여기지 말라\n그의 꾸지람을 싫어하지 말라",
      'reference': "잠언 3:11",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "지혜를 얻는 자와 명철을 얻는 자는 복이 있나니",
      'reference': "잠언 3:13",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "지혜는 생명나무라 지혜를 가진 자에게는\n복이 있느니라",
      'reference': "잠언 3:18",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "게으른 자여 개미에게로 가서\n그것의 하는 것을 보고 지혜를 얻으라",
      'reference': "잠언 6:6",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "마음의 즐거움은 얼굴을 빛나게 하여도\n마음의 근심은 심령을 상하게 하느니라",
      'reference': "잠언 15:13",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "온순한 대답은 분노를 쉬게 하여도\n과격한 말은 노를 격동하느니라",
      'reference': "잠언 15:1",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "사람이 마음으로 자기의 길을 계획할지라도\n그의 걸음을 인도하시는 이는 여호와시니라",
      'reference': "잠언 16:9",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "교만은 패망의 선봉이요\n거만한 마음은 넘어짐의 앞잡이니라",
      'reference': "잠언 16:18",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "마음이 즐거우면 양약이 되고\n심령이 상하면 뼈가 마르느니라",
      'reference': "잠언 17:22",
      'image': 'assets/images/bg1.jpg'
    },
    
    // 이사야
    {
      'text': "두려워하지 말라 내가 너와 함께 함이라\n놀라지 말라 나는 네 하나님이 됨이라\n내가 너를 굳세게 하리라 참으로 너를 도와주리라",
      'reference': "이사야 41:10",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "보라 처녀가 잉태하여 아들을 낳을 것이요\n그의 이름을 임마누엘이라 하리라",
      'reference': "이사야 7:14",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "이는 한 아기가 우리에게 났고\n한 아들을 우리에게 주신 바 되었는데\n그의 어깨에는 정사를 메었고 그의 이름은 기묘자라",
      'reference': "이사야 9:6",
      'image': 'assets/images/bg5.jpg'
    },
    {
      'text': "그러나 그가 찔림은 우리의 허물 때문이요\n그가 상함은 우리의 죄악 때문이라\n그가 징계를 받으므로 우리는 평화를 누리고",
      'reference': "이사야 53:5",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "여호와께서 이르시되 내 생각은 너희의 생각과 다르며\n내 길은 너희의 길과 다름이니라",
      'reference': "이사야 55:8",
      'image': 'assets/images/bg4.jpg'
    },
    {
      'text': "하늘이 땅보다 높음 같이\n내 길은 너희의 길보다 높으며 내 생각은 너희의 생각보다 높으니라",
      'reference': "이사야 55:9",
      'image': 'assets/images/bg5.jpg'
    },
    
    // 신약 성경 - 마태복음
    {
      'text': "심령이 가난한 자는 복이 있나니\n천국이 그들의 것임이요",
      'reference': "마태복음 5:3",
      'image': 'assets/images/bg1.jpg'
    },
    {
      'text': "애통하는 자는 복이 있나니\n그들이 위로를 받을 것임이요",
      'reference': "마태복음 5:4",
      'image': 'assets/images/bg2.jpg'
    },
    {
      'text': "온유한 자는 복이 있나니\n그들이 땅을 기업으로 받을 것임이요",
      'reference': "마태복음 5:5",
      'image': 'assets/images/bg3.jpg'
    },
    {
      'text': "의에 주리고 목마른 자는 복이 있나니\n그들이 배부를 것임이요",
      'reference': "마태복음 5:6",
      'image': 'assets/images/bg4.jpg'
    }
  ];
  
  /// 날짜 기반으로 말씀을 가져오는 메서드
  static Map<String, String> getVerseByDate(String? date) {
    final targetDate = date ?? DateTime.now().toIso8601String().substring(0, 10);
    final dateHash = targetDate.hashCode;
    return verses[dateHash.abs() % verses.length];
  }
}
