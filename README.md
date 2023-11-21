# 주소 찾기 자동 완성


본 패키지는 팝업 창을 띄워 주소를 찾고, 주소 정보와 함께 위/경도 좌표를 리턴합니다.

보통 집이나 사무실 주소를 입력 할 때, 지역/지번/도로 등의 정보를 잘못 기입하는 경우가 많고 또 주소 기반 검색을 할 때 정확한 주소가 DB 에 저장되어야 한다는 원칙이 선행되어야 하기 때문에 주소 찾기(주소 자동 완성) 기능을 행안부 API 로 만들었습니다.

찾은 주소를 바탕으로 위/경도를 카카오톡 API 로 가져오고, (구글 맵에서 열기 샘플)

주소를 바탕으로 정보를 쉽게 찾을 수 있도록, 시/도 -> 시/군/구 방식으로 클래스별 정보를 가져오는 주소 API 를 사용합니다.

DB 에는 전체 주소와 함께, "시/군", "시/군/구", "시/도 시/군/구", "위/경도", "우편번호" 등을 저장해 놓으면 되겠습니다.



## 사용법


플러터에서 아래와 같이 사용하면 됩니다.

```dart
ElevatedButton(
  onPressed: () async {
    await findAddress(
      context,
      kakaoApiKey: "....Kakaotalk API Key....",
      dataApiKey: "....Data.go.kr API Key....",
    );
    print(re);
  },
  child: const Text(
    '주소 찾기',
  ),
),
```

플러터플로에서 아래와 같이 커스텀 액션을 만들면 됩니다. 아래의 예제는 사용자가 주소를 선택하면 지정된 문서에 바로 업데이트를 하는 예제입니다.

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
    kakaoApiKey: "....Kakaotalk API Key....",
    dataApiKey: "....Data.go.kr API Key....",
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


디자인 변경은 아래와 같이 하면 됩니다.

```dart
ElevatedButton(
  onPressed: () async {
    re = await findAddress(
      context,
      kakaoApiKey: "7c567f8e9e57ffa08531df5aa9efebb5",
      dataApiKey: "U01TX0FVVEgyMDIzMTExODE5MjMzMDExNDI4ODc=",
      themeData: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: Theme.of(context).textTheme.copyWith(
              titleMedium: const TextStyle(color: Colors.red),
              labelMedium: const TextStyle(color: Colors.blue),
            ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        useMaterial3: true,
      ),
    );
    print(re);
  },
  child: const Text(
    '주소 찾기',
  ),
)
```