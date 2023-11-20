# 주소 찾기 자동 완성


본 패키지는 팝업 창을 띄워 주소를 찾고, 주소 정보와 함께 위/경도 좌표를 리턴합니다.



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