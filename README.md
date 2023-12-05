
# 2023-Team-Project

<div align="center">
  
![header](https://capsule-render.vercel.app/api?color=gradient&customColorList=0,2,4,5,30&text=2023_2_Team_Project&textColor=000000)

*팀프로젝트 MJU_2023_2_BMT*

*Fast는 사용자가 지하철을 효율적으로 이용하기 위한 프로젝트입니다. ‘최고의 이동’이라는 키워드에 초점을 맞추어 사용자에게 어플 UI/UX 커스터마이징을 통해 사용자 마다 편한 구성의 앱 사용과 다양한 경로들을 최단 시간, 최단 거리, 최소비용, 앱 추천 경로를 안내하여 복잡한 지하철 이용에 편리함을 제공해주는것과 역 내 혼잡도 정보제공 및 리워드 제공이 주기능입니다.*

 *본 프로젝트의 기간은 설계 포함 10주이며 이 기간 안에는 설계, 개발, 그리고 테스트 및 디버깅 과정이 모두 포함되어 있습니다.*

![Fast2](https://github.com/choi-hyk/Team_Project_BMT/assets/73456884/57128559-623a-4d1b-a0c0-3e56e7be2313)

😺*사용 언어*🐶


*dart with flutter*


😺*Notion*🐶

*https://www.notion.so/Team_Project_1-9af4cee7f0124195835356ef3313e67a*

![Gmail](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white)

*blindlchoil@gmail.com*

</div> 

# 1. 프로젝트 세팅 방법

`**VScode가 설치되어있다고 가정하였을 때의 프로젝트 세팅 방법**`

1. **VScode에서 확장 프로그램 Flutter, Dart 설치**
- Chocolatey를 이용한 Flutter SDK 환경 변수 및 자동 설치:
Powershell을 관리자 권한으로 실행 및 Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('[https://community.chocolatey.org/install.ps1](https://community.chocolatey.org/install.ps1)')) 입력
- 설치 확인 후 choco install flutter

1. **안드로이드 스튜디오 설치**
AVD Manager를 통해 에뮬레이터 생성
본 프로젝트는 다음과 같은 에뮬레이터에서 진행하였습니다

1. **Powershell에서 Flutter, Dart, Android studio 등패키지 설치 확인: flutter docor** 

![Untitled](https://github.com/choi-hyk/Team_Project_BMT/assets/144649271/c622600c-8199-4b58-b7b8-fa81eb80ddab)

Issue가 있으면 해당 이슈를 커맨드에 설치

1. **에뮬레이터 생성**
- AVD Manager → Create Virtual Device → 하드웨어: Galaxy S21 → System Image: API34 → Finish (No skin)
    
![Untitled](https://github.com/choi-hyk/Team_Project_BMT/assets/144649271/c344b90f-1ff1-4380-a08b-4f9f78090ed2)
    
1. **프로젝트 실행**

![Untitled](https://github.com/choi-hyk/Team_Project_BMT/assets/144649271/1f101fd4-0a15-4bc9-a395-3a8520247a51)

vscode에 터미널에서 flutter pub get을 입력하여 필요한 패키지를 설치

![Untitled](https://github.com/choi-hyk/Team_Project_BMT/assets/144649271/443d84a7-ea29-4ccb-93a3-09cc880a9dc1)


Select Device를 선택

![Untitled](https://github.com/choi-hyk/Team_Project_BMT/assets/144649271/42bad135-ec20-42b7-b29a-2cc89fb7eb46)


프로젝트를 실행할 수 있는 Device 목록

현재 설치된 에뮬레이터: Pixel 2 XL API 34를 선택

![Untitled](https://github.com/choi-hyk/Team_Project_BMT/assets/144649271/372a766b-110c-49fb-96c4-ad6394b961a6)


Dart & Flutter를 선택

![Untitled](https://github.com/choi-hyk/Team_Project_BMT/assets/144649271/087e42ae-2469-4b73-a089-d7070974a80b)


두 번째 에뮬레이터로 디버깅 실행

![Untitled](https://github.com/choi-hyk/Team_Project_BMT/assets/144649271/0173fa32-2429-4e9b-aaff-95d3b254bed7)


첫 실행 화면

---

# 2. FLutter 기본 구성

flutter는 위젯형식으로 이루어진 프레임 워크입니다.

```dart
class ProvReward extends StatefulWidget {
  const ProvReward({super.key});

  @override
  State<ProvReward> createState() => _ProvRewardState();
}
```

먼저 페이지의 클래스를 설정하면 해당 클래스의 매개변수를 설정가능합니다 위의 ProvReward는 따로 매개변수가 존재하지 않습니다.

```dart
class _ProvRewardState extends State<ProvReward> {
  @override
  void initState() {
    super.initState();
    currentUI = 'home';
    _updateUserPointAfterDelay();
  }

  void _updateUserPointAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      // 유저 아이디에 100 포인트 추가
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.addPointsToUser();
      // 유저 아이디에 혼잡도 제보 1 추가
      userProvider.addCountToUser();
      // 3초 후에 화면 전환
      _navigateToBack();
    });
  }

  void _navigateToBack() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // UserProvider에서 정보를 가져옵니다.
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserInfo();
    // ignore: deprecated_member_use
    return WillPopScope(

     .....

     ....
      
     );
  }
}
```

위의 State클래스는 실직적으로 위젯에 필요한 메소드와 위젯의 구성요소를 설정하는 프레임 파트입니다.  따라서  @override
  Widget build(BuildContext context) {

이부분 밑에있는 코드들은 화면상의 요소를 설정한 프레임 코드입니다. 

```dart
                       Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: currentUI == 'home'
                                    ? Theme.of(context).primaryColorDark
                                    : Theme.of(context).primaryColor,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    current_trans = 0;
                                    currentUI = 'home';
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Menu()),
                                    );
                                  });
                                },
                                icon: const Icon(Icons.home),
                              ),
                            ),
```

플러터는 위젯 클래스로 요소를 추가합니다. 위의 Container는 화면에 박스를 추가하는 위젯 클래스이고 위젯 클래스는 하나의 child요소를 가질 수 있습니다. 

---


## UI테마 색 구성

[호선]

-1  : Color.fromARGB(255, 225, 213, 213)

1 : Colors.green;

2 : Color.fromARGB(255, 14, 67, 111)

3 : Colors.brown

4 : Colors.red

5 : Color.fromARGB(255, 24, 99, 134)

6 : Color.fromARGB(255, 218, 206, 95)

7 : Color.fromARGB(255, 115, 216, 118)

8 : Color.fromARGB(255, 54, 181, 240)

9 : Colors.purple;

기본값 : Colors.white;


[테마]

primaryColorLight: Color.fromARGB(255, 117, 154, 167)

primaryColor: Color.fromARGB(255, 108, 159, 164)

primaryColorDark: Color.fromARGB(255, 22, 73, 79)

cardColor: Color.fromARGB(255, 233, 255, 243)


---

# 3. 데이터 및 데이터 메소드

## 1. Lines컬렉션 : 역 정보

Lines컬렉션 → 총 9개의 다큐먼트가 존재합니다.  

다큐먼트 : Line1 ~ Line2 각 호선을 나타냅니다.

각 다큐먼트에는 필드값이 존재합니다.

station : 역 이름

time, cost, optinum : 가중치

cStore, nRoom : 편의시설

transfer : 환승 여부

각 필드는 List형식으로 값이 들어가 있습니다.

station은 각 호선의 가장 작은 수의 역부터 호선 끝역까지 배열에 저장되어있습니다.

예) 1호선 Line1 다큐먼트 → station = [101, 102, 103, 104, … , 123]

sation[n] → station[n + 1] 일때 두 역의 사이의 시간 가중치값은 time[n]이 됩니다.

순환호선인 1호선과 6호선인 경우 첫 역과 끝 역이 이어지므로 가중치 필드와 station필드의 배열 수가 같습니다

비순환 호선들은 가중치의 개수가 station필드의 배열 수보다 1 적습니다.

 nRoom과 cStore는 bool형식으로 배열에 저장되어 있습니다.

station[n] 에 해당하는 역이 수유실을 가지고 있을 경우 nRoom[n] = true가 됩니다.

마지막으로 trasnfer는 해당 역의 환승가능 호선입니다.

Lines1의 101역은 2호선으로 환승 가능합니다. 이때 sation[0] = 101이고  trasfer[0] = 2가됩니다. 이때 2는 2호선으로 환승 가능하다는 의미입니다. 마찬가지로 Lines2에도 101역이 존재하고 101역의 배열 위치에 해당하는  trasfer는 1호선으로 환승 가능하다는 것을 나타내기 위해 1이 됩니다.

# Graph클래스의 makeGraph메소드

```dart
void makeGraph(List<Map<String, dynamic>> documentDataList, String weight) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < documentDataList[i]['station'].length - 1; j++) {
        addEdge(
            documentDataList[i]['station'][j],
            documentDataList[i]['station'][j + 1],
            documentDataList[i][weight][j]);
      }
    }
    addEdge(
        documentDataList[0]['station']
            [documentDataList[0]['station'].length - 1],
        documentDataList[0]['station'][0],
        documentDataList[0][weight][documentDataList[0]['station'].length - 1]);
    addEdge(
        documentDataList[5]['station']
            [documentDataList[5]['station'].length - 1],
        documentDataList[5]['station'][0],
        documentDataList[5][weight][documentDataList[5]['station'].length - 1]);
  }
```

위 함수에서 그래프를 그리게 됩니다. 양방향 그래프로 그리는 로직이고 순환호선인 1호선과 6호선의 첫번째 역과 두번째역만 예외처리하여 연결을 하였습니다. addEdge에 매개변수로 이어지는 두개의 역과 사이의 가중치 값을 설정합니다. 따라서 앱에서는 총 3개의 가중치만 다른 그래프를 그립니다.

# DataProvider클래스의 searchData메소드

```dart
Future<void> searchData(int searchStation) async {
    await fetchDocumentList();
    found = false;
    name = "";
    nRoom = false;
    cStore = false;
    isBkmk = false;
    line.clear();
    nName.clear();
    pName.clear();
    for (int i = 0; i < 9; i++) {
      int leng = documentDataList[i]['station'].length;
      for (int j = 0; j < leng; j++) {
        if (documentDataList[i]['station'][j] == searchStation) {
          name = documentDataList[i]['station'][j].toString();
          nRoom = documentDataList[i]['nRoom'][j];
          cStore = documentDataList[i]['cStore'][j];
          line.add(i + 1);
          //순환하는 호선인 1호선과 6호선 처리 과정
          //순환하는 호선이면 맨처음 역과 마지막역을 이어줘야함
          if (i == 0 || i == 5) {
            if (j == 0) {
              nName.add(documentDataList[i]['station'][j + 1].toString());
              pName.add(documentDataList[i]['station'][leng - 1].toString());
            } else if (j == leng - 1) {
              nName.add(documentDataList[i]['station'][0].toString());
              pName.add(documentDataList[i]['station'][j - 1].toString());
            } else {
              nName.add(documentDataList[i]['station'][j + 1].toString());
              pName.add(documentDataList[i]['station'][j - 1].toString());
            }
            //순환하지 않는 호선인 경우
          } else {
            if (j == 0) {
              nName.add(documentDataList[i]['station'][j + 1].toString());
              pName.add("종점역");
            } else if (j == leng - 1) {
              nName.add("종점역");
              pName.add(documentDataList[i]['station'][j - 1].toString());
            } else {
              nName.add(documentDataList[i]['station'][j + 1].toString());
              pName.add(documentDataList[i]['station'][j - 1].toString());
            }
          }
          found = true;
          isBkmk = await userProvider.isStationBookmarked(name);
          current_trans = 0;
          break;
        }
      }
    }
  }
}
```

해당 로직은 역의 정보를 검색하는 로직 입니다.searchStation에 검색할 역 이름이 들어가고 각 역 숫자가 증가하는 방향에 있는 다음역을 nName  감소하는 방향에 있는 역을 pName으로 설정하였습니다. 

예) 123 → 101 → 102 

101검색    nName[0] = 102, pName[0] = 123

line은 환승가능 호선입니다. 101역의 경우 1호선과 2호선에 존재하므로 작은 수의 호선부터 line에 저장됩니다. 

101검색시 → line[0] = 1, line[1] = 2

이때 nName[1] 은 2호선에서 다음 역을 나타냅니다 즉 101의 nName[1] = 201이 됩니다. 이때 101역은  2호선에서 종점역이므로 pName[1] =  null이됩니다.

## 2. Congestion컬렉션 : 혼잡도 정보

사용자가 제공하는 혼잡도 정보를 저장하는 컬렉션입니다.

## Congestion클래스의  addCongestionData메소드

```dart
Future<void> addCongestionData(int congestionLevel) async {
    try {
      int station = int.parse(widget.currentStaion);
      int line = widget.line;
      int next = int.parse(widget.linkStaion);
      int hour = currentHour;
      int minute = getMinuteRange(currentMinute);

      // Firestore에 데이터 추가
      await _firestore.collection('Congestion').add({
        'station': station,
        'line': line,
        'next': next,
        'hour': hour,
        'minute': minute,
        'cong': congestionLevel,
      });

      print('Congestion data added successfully');
    } catch (e) {
      print('Error adding congestion data: $e');
    }
  }
```

위의 congestionLevel을 선택해서 혼잡도 정보를 제공합니다. 혼잡도는 0~4가 존재하며 혼잡도와 같이 해당 역의 호선 다음 역 현재 시간(hour), 분(miute)을 제공합니다. 이때 분은 0분 ~ 19분일때 1을

20분 ~ 39분일때 2를 40분 ~ 59분일때 3을 할당하여 20분 단위로 혼잡도 정보를 나눠서 제공합니다.

사용자가 18시 23분에 101역에서 102역으로 가는 방향에서 4의 혼잡도를 제공하면 

 line = 1
next = 102
hour = 18
minute = 2

station = 101

cong = 4 

위 6개의 데이터를 Congestion컬렉션에 전달합니다.
채

## Congestion클래스의 getCongestionData

```dart
Future<int> getCongestionData(int link) async {
    int station = int.parse(widget.name);
    int next = link;
    int line = widget.line[current_trans];
    int hour = currentHour;
    int minute = getMinuteRange(currentMinute);

    CollectionReference congestionCollection =
        FirebaseFirestore.instance.collection('Congestion');

    QuerySnapshot snapshot = await congestionCollection
        .where('station', isEqualTo: station)
        .where('next', isEqualTo: next)
        .where('line', isEqualTo: line)
        .where('hour', isEqualTo: hour)
        .where('minute', isEqualTo: minute)
        .get();

    int totalCongestion = 0;
    int numberOfMatchingDocuments = snapshot.docs.length;

    if (numberOfMatchingDocuments > 0) {
      // 매칭되는 문서들의 cong 값 합산
      for (var doc in snapshot.docs) {
        totalCongestion += doc['cong'] as int;
      }

      print('일치하는 문서 수: $numberOfMatchingDocuments');
      print('총 혼잡도 값: $totalCongestion');

      return totalCongestion ~/ numberOfMatchingDocuments;
    } else {
      return -1;
    }
  }
```

위의 cong를 제외한 Congestion컬렉션의 필드값들을 기준으로 혼잡도를 가져옵니다. 총 혼잡도를 문서의 개수로 나누어서 혼잡도의 평균을 구합니다.
