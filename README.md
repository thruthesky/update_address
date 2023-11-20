# 주소 찾기 자동 완성


본 패키지는 팝업 창을 띄워 주소를 찾고, 주소 정보와 함께 위/경도 좌표를 리턴합니다.



## 사용법

플러터플로에서 아래와 같이 커스텀 액션을 만들면 됩니다.

```dart
// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:find_address/find_address.dart' as addr;

Future updateAddress(
  BuildContext context,
  DocumentReference houseDocumentReference,
) async {
  // Add your function code here!
  final re = await addr.findAddress(
    context,
    "....Kakaotalk API Key....",
    "....Data.go.kr API Key....",
  );

  if (re == null) return;

  print(re);

  await houseDocumentReference.update({
    'roadAddr': re['roadAddr'],
    'siNm': re['siNm'],
    'sggNm': re['sggNm'],
    'siNmSggNm': '${re['siNm']} ${re['sggNm']}',
    'latLng': GeoPoint(re['lat'] ?? 0, re['lng'] ?? 0),
  });

  return;
}
```