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
    '101': const Offset(17, 276),
    '102': const Offset(17, 301),
    '103': const Offset(17, 328),
    '104': const Offset(17, 355),
    '105': const Offset(17, 383),
    '106': const Offset(30, 402),
    '107': const Offset(60, 402),
    '108': const Offset(82, 403),
    '109': const Offset(104, 403),
    '110': const Offset(134, 403),
    '111': const Offset(163, 403),
    '112': const Offset(193, 402),
    '113': const Offset(228, 402),
    '114': const Offset(241, 380),
    '115': const Offset(241, 355),
    '116': const Offset(241, 320),
    '117': const Offset(241, 300),
    '118': const Offset(237, 270),
    '119': const Offset(193, 261),
    '120': const Offset(162, 263),
    '121': const Offset(134, 262),
    '122': const Offset(104, 263),
    '123': const Offset(59, 263),
    //2호선
    '201': const Offset(17, 240),
    '202': const Offset(17, 217),
    '203': const Offset(17, 196),
    '204': const Offset(17, 173),
    '205': const Offset(17, 152),
    '206': const Offset(38, 152),
    '207': const Offset(59, 152),
    '208': const Offset(82, 152),
    '209': const Offset(104, 152),
    '210': const Offset(133, 151),
    '211': const Offset(194, 151),
    '212': const Offset(221, 151),
    '213': const Offset(254, 152),
    '214': const Offset(282, 153),
    '215': const Offset(308, 152),
    '216': const Offset(334, 152),
    '217': const Offset(379, 152),
    //3호선
    '301': const Offset(59, 173),
    '302': const Offset(59, 196),
    '303': const Offset(59, 218),
    '304': const Offset(59, 241),
    '305': const Offset(59, 301),
    '306': const Offset(59, 329),
    '307': const Offset(59, 356),
    '308': const Offset(59, 384),
    //4호선
    '401': const Offset(38, 357),
    '402': const Offset(81, 357),
    '403': const Offset(104, 357),
    '404': const Offset(133, 357),
    '405': const Offset(163, 357),
    '406': const Offset(193, 357),
    '407': const Offset(216, 357),
    '408': const Offset(261, 357),
    '409': const Offset(283, 357),
    '410': const Offset(309, 357),
    '411': const Offset(333, 357),
    '412': const Offset(334, 321),
    '413': const Offset(334, 302),
    '414': const Offset(334, 269),
    '415': const Offset(334, 239),
    '416': const Offset(334, 218),
    '417': const Offset(334, 179),
    //5호선
    '501': const Offset(103, 173),
    '502': const Offset(104, 196),
    '503': const Offset(104, 218),
    '504': const Offset(104, 239),
    '505': const Offset(104, 301),
    '506': const Offset(104, 328),
    '507': const Offset(104, 383),
    //6호선
    '601': const Offset(134, 219),
    '602': const Offset(134, 240),
    '603': const Offset(133, 301),
    '604': const Offset(163, 320),
    '605': const Offset(192, 322),
    '606': const Offset(216, 321),
    '607': const Offset(260, 320),
    '608': const Offset(282, 320),
    '609': const Offset(309, 320),
    '610': const Offset(364, 321),
    '611': const Offset(378, 301),
    '612': const Offset(378, 270),
    '613': const Offset(378, 240),
    '614': const Offset(378, 218),
    '615': const Offset(378, 197),
    '616': const Offset(354, 179),
    '617': const Offset(308, 179),
    '618': const Offset(282, 179),
    '619': const Offset(254, 179),
    '620': const Offset(221, 180),
    '621': const Offset(194, 180),
    '622': const Offset(163, 180),
    //7호선
    '701': const Offset(163, 218),
    '702': const Offset(193, 218),
    '703': const Offset(220, 218),
    '704': const Offset(253, 218),
    '705': const Offset(282, 218),
    '706': const Offset(308, 218),
    '707': const Offset(356, 218),
    //8호선
    '801': const Offset(258, 404),
    '802': const Offset(280, 404),
    '803': const Offset(282, 381),
    '804': const Offset(282, 300),
    '805': const Offset(282, 269),
    '806': const Offset(282, 240),
    //9호선
    '901': const Offset(192, 380),
    '902': const Offset(192, 301),
    '903': const Offset(192, 239),
    '904': const Offset(192, 197),
  };

  void _onTapUp(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition =
        renderBox.globalToLocal(details.globalPosition);
    final double currentScale = _controller.value.getMaxScaleOnAxis();

    print("Coordinates of tap: ${localPosition.dx}, ${localPosition.dy}");

    // 행렬에서 이동 변환 값 가져오기
    final Offset translation = Offset(
      _controller.value.getTranslation().x,
      _controller.value.getTranslation().y,
    );

    // 이미지의 원점을 기준으로 탭 위치의 원본 이미지 상의 좌표 계산
    final Offset originalImageCoordinates =
        (localPosition - translation) / currentScale;

    print(
        "Original image coordinates of tap: ${originalImageCoordinates.dx}, ${originalImageCoordinates.dy}");
    // 이제 transformedPosition을 사용하여 가장 가까운 역을 찾습니다.
    String tappedStation = '';
    double closestDistance = 10;

    stationCoordinates.forEach((key, value) {
      // 확대/축소된 이미지 상의 좌표와 역의 좌표 사이의 거리를 계산합니다.
      double distance = (originalImageCoordinates - value).distance;
      if (distance < closestDistance) {
        closestDistance = distance;
        tappedStation = key;
      }
    });

    if (tappedStation.isNotEmpty) {
      setState(() {
        _tappedStationKey = tappedStation;
      });
      print('You tapped on station $tappedStation');
      // Callback 함수를 호출하여 선택된 역의 정보를 부모 위젯에 전달합니다.
      widget.onTapStation(tappedStation);
    }

    //print("Coordinates of tap: ${localPosition.dx}, ${localPosition.dy}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _onTapUp,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: 1,
        maxScale: 5,
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
