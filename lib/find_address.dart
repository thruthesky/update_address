import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

typedef Address = ({
  String admCd,
  String bdKdcd,
  String bdMgtSn,
  String bdNm,
  String buldMnnm,
  String buldSlno,
  String currentPage,
  String currentPerPage,
  String detBdNmList,
  String emdNm,
  String emdNo,
  String engAddr,
  String errorCode,
  String errorMessage,
  String hemdNm,
  String jibunAddr,
  String liNm,
  String lnbrMnnm,
  String lnbrSlno,
  String mtYn,
  String rn,
  String rnMgtSn,
  String roadAddr,
  String roadAddrPart1,
  String roadAddrPart2,
  String relJibun,
  String sggNm,
  String siNm,
  String hstryYn,
  String totalCount,
  String udrtYn,
  String zipNo,
});

Future<Map<String, dynamic>?> findAddress(
  BuildContext context, {
  required String kakaoApiKey,
  required String dataApiKey,
  ThemeData? themeData,
}) async {
  // Add your function code here!

  final Address? addr = await showDialog(
    context: context,
    builder: (context) => Theme(
      data: themeData ?? Theme.of(context),
      child: AlertDialog(
        content: SearchAddress(
          dataApiKey: dataApiKey,
        ),
      ),
    ),
  );

  if (addr == null) return null;

  final latLon = await getLatLon(kakaoApiKey, addr.roadAddr);

  return {
    'roadAddr': addr.roadAddr,
    'siNm': addr.siNm,
    'sggNm': addr.sggNm,
    'siNmSggNm': '${addr.siNm} ${addr.sggNm}',
    'lat': latLon?.lat ?? 0,
    'lng': latLon?.lng ?? 0,
  };
}

Future<({double lat, double lng})?> getLatLon(String kakaoApiKey, String addr) async {
  String apiUrl = "https://dapi.kakao.com/v2/local/search/address.json?query=$addr";
  final http.Response res = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "KakaoAK $kakaoApiKey"},
  );

  final Map<String, dynamic> result = json.decode(res.body);

  if (result['documents'].length == 0) return null;

  return (
    lat: double.parse(result['documents'][0]['y']),
    lng: double.parse(result['documents'][0]['x']),
  );
}

class SearchAddress extends StatefulWidget {
  const SearchAddress({
    super.key,
    required this.dataApiKey,
  });

  final String dataApiKey;

  @override
  State<SearchAddress> createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  final search = TextEditingController(text: '');
  List<Address> address = [];
  parseAddress(Map<String, dynamic> re) {
    List<Address> address = [];

    final totalCount = int.parse(re['results']['common']['totalCount'].toString());
    for (int i = 0; i < totalCount; i++) {
      // the maximum you can get from a call is 100.
      if (i >= 100) break;
      final common = re['results']['common'];
      final juso = re['results']['juso'][i];

      address.add((
        admCd: juso['admCd'] ?? '',
        bdKdcd: juso['bdKdcd'] ?? '',
        bdMgtSn: juso['bdMgtSn'] ?? '',
        bdNm: juso['bdNm'] ?? '',
        buldMnnm: juso['buldMnnm'] ?? '',
        buldSlno: juso['buldSlno'] ?? '',
        currentPage: common['currentPage'] ?? '',
        currentPerPage: common['currentPerPage'] ?? '',
        detBdNmList: juso['detBdNmList'] ?? '',
        emdNm: juso['emdNm'] ?? '',
        emdNo: juso['emdNo'] ?? '',
        engAddr: juso['engAddr'] ?? '',
        errorCode: common['errorCode'] ?? '',
        errorMessage: common['errorMessage'] ?? '',
        hemdNm: juso['hemdNm'] ?? '',
        jibunAddr: juso['jibunAddr'] ?? '',
        liNm: juso['liNm'] ?? '',
        lnbrMnnm: juso['lnbrMnnm'] ?? '',
        lnbrSlno: juso['lnbrSlno'] ?? '',
        mtYn: juso['mtYn'] ?? '',
        rn: juso['rn'] ?? '',
        rnMgtSn: juso['rnMgtSn'] ?? '',
        roadAddr: juso['roadAddr'] ?? '',
        roadAddrPart1: juso['roadAddrPart1'] ?? '',
        roadAddrPart2: juso['roadAddrPart2'] ?? '',
        relJibun: juso['relJibun'] ?? '',
        sggNm: juso['sggNm'] ?? '',
        siNm: juso['siNm'] ?? '',
        hstryYn: juso['hstryYn'] ?? '',
        totalCount: common['totalCount'] ?? '',
        udrtYn: juso['udrtYn'] ?? '',
        zipNo: juso['zipNo'] ?? '',
      ));
    }

    return address;
  }

  double get width =>
      MediaQuery.of(context).size.width * 0.8 > 300 ? 300 : MediaQuery.of(context).size.width * 0.8;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('주소 찾기', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('찾고자 하는 주소의 일부분을 입력하세요.\n예) 김해시 대성아파트'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: search,
                    decoration: const InputDecoration(
                      hintText: '주소 입력',
                    ),
                    onSubmitted: searchAddress,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: searchAddress, child: const Text("검색")),
              ],
            ),
            const SizedBox(height: 16),
            if (address.length >= 100) ...[
              Text(
                '앗, 검색 결과가 너무 많습니다. 좀 더 자세히 입력해주세요. 예를 들면, "김해시" 보다는 "김해시 대성아파트"와 같이 더 상세히 입력해보세요.',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              const SizedBox(height: 16),
            ],
            if (address.isNotEmpty)
              ...address
                  .map(
                    (e) => InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.roadAddr.trim(), style: Theme.of(context).textTheme.titleMedium),
                          Text(
                            e.jibunAddr.trim(),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            '[선택]',
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                        ],
                      ),
                      onTap: () async {
                        Navigator.pop(context, e);
                      },
                    ),
                  )
                  .toList()
                  .fold<List<Widget>>(
                [],
                (previousValue, element) => previousValue
                  ..add(element)
                  ..add(
                    const Divider(
                      height: 24,
                    ),
                  ),
              )..removeLast(),
          ],
        ),
      ),
    );
  }

  searchAddress([String? value]) async {
    String queryUrl =
        "https://business.juso.go.kr/addrlink/addrLinkApi.do?currentPage=1&countPerPage=200&keyword=${search.text}&confmKey=${widget.dataApiKey}&hstryYn=Y&resultType=json";
    final http.Response res = await http.get(
      Uri.parse(queryUrl),
    );

    final Map<String, dynamic> result = json.decode(res.body);
    address = parseAddress(result);
    setState(() {});
  }
}
