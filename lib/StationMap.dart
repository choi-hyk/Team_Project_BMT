import 'package:flutter/material.dart';

class StationMap extends StatefulWidget {
  final Function(String) onTapStation;
  const StationMap({
    Key? key,
    required this.onTapStation,
  }) : super(key: key);

  @override
  State<StationMap> createState() => _StationMapState();
}

class _StationMapState extends State<StationMap> {
  final TransformationController _controller = TransformationController();

  String _tappedStationKey = '';

  String get tappedStationKey => _tappedStationKey;

  final Map<String, Offset> stationCoordinates = {
    //1호선
    '101': const Offset(120, 264),
    '102': const Offset(120, 273),
    '103': const Offset(120, 284),
    '104': const Offset(120, 293),
    '105': const Offset(119, 304),
    '106': const Offset(125, 311),
    '107': const Offset(135, 311),
    '108': const Offset(143, 311),
    '109': const Offset(153, 311),
    '110': const Offset(164, 311),
    '111': const Offset(175, 311),
    '112': const Offset(186, 311),
    '113': const Offset(200, 311),
    '114': const Offset(205, 303),
    '115': const Offset(205, 293),
    '116': const Offset(205, 280),
    '117': const Offset(205, 273),
    '118': const Offset(203, 261),
    '119': const Offset(186, 258),
    '120': const Offset(175, 258),
    '121': const Offset(164, 258),
    '122': const Offset(153, 258),
    '123': const Offset(136, 258),
    //2호선
    '201': const Offset(119, 249),
    '202': const Offset(119, 240),
    '203': const Offset(119, 232),
    '204': const Offset(119, 224),
    '205': const Offset(119, 215),
    '206': const Offset(128, 215),
    '207': const Offset(135, 215),
    '208': const Offset(143, 215),
    '209': const Offset(152, 215),
    '210': const Offset(163, 215),
    '211': const Offset(187, 215),
    '212': const Offset(197, 215),
    '213': const Offset(210, 215),
    '214': const Offset(220, 215),
    '215': const Offset(231, 215),
    '216': const Offset(240, 215),
    '217': const Offset(257, 215),
    //3호선
    '301': const Offset(135, 224),
    '302': const Offset(135, 232),
    '303': const Offset(135, 241),
    '304': const Offset(135, 250),
    '305': const Offset(135, 273),
    '306': const Offset(135, 284),
    '307': const Offset(135, 293),
    '308': const Offset(135, 303),
    //4호선
    '401': const Offset(128, 293),
    '402': const Offset(144, 293),
    '403': const Offset(152, 293),
    '404': const Offset(163, 293),
    '405': const Offset(175, 293),
    '406': const Offset(186, 293),
    '407': const Offset(196, 293),
    '408': const Offset(212, 293),
    '409': const Offset(221, 293),
    '410': const Offset(231, 293),
    '411': const Offset(240, 293),
    '412': const Offset(240, 280),
    '413': const Offset(240, 273),
    '414': const Offset(240, 261),
    '415': const Offset(240, 249),
    '416': const Offset(240, 241),
    '417': const Offset(240, 226),
    //5호선
    '501': const Offset(152, 223),
    '502': const Offset(152, 233),
    '503': const Offset(152, 241),
    '504': const Offset(152, 250),
    '505': const Offset(152, 272),
    '506': const Offset(152, 283),
    '507': const Offset(152, 303),
    //6호선
    '601': const Offset(164, 242),
    '602': const Offset(164, 250),
    '603': const Offset(164, 273),
    '604': const Offset(176, 280),
    '605': const Offset(186, 280),
    '606': const Offset(195, 280),
    '607': const Offset(211, 280),
    '608': const Offset(220, 280),
    '609': const Offset(230, 280),
    '610': const Offset(251, 280),
    '611': const Offset(257, 272),
    '612': const Offset(257, 260),
    '613': const Offset(257, 248),
    '614': const Offset(257, 241),
    '615': const Offset(257, 233),
    '616': const Offset(248, 226),
    '617': const Offset(230, 226),
    '618': const Offset(220, 226),
    '619': const Offset(210, 226),
    '620': const Offset(198, 226),
    '621': const Offset(187, 226),
    '622': const Offset(175, 226),
    //7호선
    '701': const Offset(175, 241),
    '702': const Offset(186, 241),
    '703': const Offset(197, 241),
    '704': const Offset(210, 241),
    '705': const Offset(221, 241),
    '706': const Offset(231, 241),
    '707': const Offset(249, 241),
    //8호선
    '801': const Offset(210, 311),
    '802': const Offset(220, 311),
    '803': const Offset(220, 303),
    '804': const Offset(220, 272),
    '805': const Offset(220, 260),
    '806': const Offset(220, 248),
    //9호선
    '901': const Offset(186, 303),
    '902': const Offset(186, 272),
    '903': const Offset(186, 249),
    '904': const Offset(186, 233),
  };

  void _onTapUp(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(details.localPosition);

    // 화면 좌표를 이미지 좌표로 변환
    final Offset imagePosition = _controller.toScene(localPosition);

    // 이미지가 확대/축소될 때의 정보를 가져옴
    final double scale = _controller.value.getMaxScaleOnAxis();

    // 이미지 중심을 계산
    final Size imageSize = context.size ?? Size.zero;
    final Offset imageCenter =
        Offset(imageSize.width / 2, imageSize.height / 2);

    // 현재 확대/축소 비율을 고려하여 탭한 지점의 원본 이미지 좌표를 계산
    final Offset originalPosition =
        (imagePosition - imageCenter) / scale + imageCenter;

    String tappedStation = '';

    stationCoordinates.forEach((key, value) {
      if ((originalPosition - value).distance < 3) {
        tappedStation = key;
        _tappedStationKey = tappedStation;
        print('You tapped on station $key at: $value');
      }
    });

    if (tappedStation.isNotEmpty) {
      print('Tapped station key: $tappedStation');
      // 여기에 특정 터치된 역의 키 값을 반환하는 기능 추가 가능
      widget.onTapStation(tappedStation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _onTapUp,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: 2.5,
        maxScale: 2.5,
        child: Image.asset(
          "assets/images/노선도.png",
          width: 500,
          height: 560,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
