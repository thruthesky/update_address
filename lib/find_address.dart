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
  BuildContext context,
  String kakaoApiKey,
  String dataApiKey,
) async {
  // Add your function code here!

  final Address? addr = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('주소 찾기'),
      content: SearchAddress(
        dataApiKey: dataApiKey,
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('찾고자 하는 주소의 일부분을 입력하세요.\n예) 김해시 대성아파트'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: search,
                  decoration: const InputDecoration(
                    hintText: 'Address',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: searchAddress,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: searchAddress, child: const Text("검색")),
            ],
          ),
          ...address.map(
            (e) => ListTile(
              title: Text(e.roadAddr),
              subtitle: Text(e.jibunAddr),
              onTap: () async {
                Navigator.pop(context, e);
              },
            ),
          ),
        ],
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
