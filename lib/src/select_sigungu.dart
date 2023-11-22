import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

typedef AddressClass = ({
  String code,
  String name,
});

class SelectSiGunGu extends StatefulWidget {
  const SelectSiGunGu({
    super.key,
    required this.onSelected,
    this.isRow = true,
    this.spacing = 16,
  }) : isColumn = false;

  const SelectSiGunGu.column({
    super.key,
    required this.onSelected,
    this.isColumn = true,
    this.spacing = 16,
  }) : isRow = false;

  final bool isRow;
  final bool isColumn;
  final double spacing;

  final Function(String? name) onSelected;

  @override
  State<SelectSiGunGu> createState() => _SelectSiGunGuState();
}

class _SelectSiGunGuState extends State<SelectSiGunGu> {
  String selectedSiDo = '';
  String selectedSiGunGu = '';
  List<AddressClass> siDo = [];
  List<AddressClass> siGunGu = [];

  List<DropdownMenuItem<String>> get siDoMenuEntries => siDo
      .map((e) => DropdownMenuItem(
            value: e.code,
            child: Text(e.name),
          ))
      .toList();
  List<DropdownMenuItem<String>> get siGunguMenuEntries => siGunGu
      .map(
        (e) => DropdownMenuItem(
          value: e.code,
          child: Text(e.name),
        ),
      )
      .toList();

  final boxDecorator = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  );

  @override
  void initState() {
    super.initState();

    final Map<String, dynamic> result = json.decode(
        '{"regcodes":[{"code": "", "name": "시/도 선택"}, {"code":"1100000000","name":"서울특별시"},{"code":"2600000000","name":"부산광역시"},{"code":"2700000000","name":"대구광역시"},{"code":"2800000000","name":"인천광역시"},{"code":"2900000000","name":"광주광역시"},{"code":"3000000000","name":"대전광역시"},{"code":"3100000000","name":"울산광역시"},{"code":"4100000000","name":"경기도"},{"code":"4300000000","name":"충청북도"},{"code":"4400000000","name":"충청남도"},{"code":"4500000000","name":"전라북도"},{"code":"4600000000","name":"전라남도"},{"code":"4700000000","name":"경상북도"},{"code":"4800000000","name":"경상남도"},{"code":"5000000000","name":"제주특별자치도"},{"code":"5100000000","name":"강원특별자치도"}]}');
    for (var element in (result['regcodes'] as List)) {
      siDo.add((
        code: element['code'],
        name: element['name'],
      ));
    }

    // scheduleMicrotask(() async {
    // final http.Response res = await http.get(
    //   Uri.parse(
    //       "https://grpc-proxy-server-mkvo6j4wsq-du.a.run.app/v1/regcodes?regcode_pattern=*00000000"),
    // );
    /*       final Map<String, dynamic> result = json.decode(res.body);
      for (var element in (result['regcodes'] as List)) {
        siDo.add((
          code: element['code'],
          name: const Utf8Decoder().convert(element['name'].codeUnits),
        ));
      } */
    // setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRow) {
      return Row(
        children: [
          Expanded(
            child: InputDecorator(
              decoration: boxDecorator,
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedSiDo,
                items: siDoMenuEntries,
                onChanged: onSelectSiDo,
                underline: const SizedBox.shrink(),
              ),
            ),
          ),
          if (siGunGu.isNotEmpty) ...[
            SizedBox(width: widget.spacing),
            Expanded(
              child: InputDecorator(
                decoration: boxDecorator,
                child: DropdownButton<String>(
                  key: ValueKey(selectedSiDo),
                  isExpanded: true,
                  value: selectedSiGunGu,
                  items: siGunguMenuEntries,
                  onChanged: onSelectSiGunGu,
                  underline: const SizedBox.shrink(),
                ),
              ),
            ),
          ]
        ],
      );
    } else if (widget.isColumn) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: boxDecorator,
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedSiDo,
              items: siDoMenuEntries,
              onChanged: onSelectSiDo,
              underline: const SizedBox.shrink(),
            ),
          ),
          if (siGunGu.isNotEmpty) ...[
            SizedBox(height: widget.spacing),
            InputDecorator(
              decoration: boxDecorator,
              child: DropdownButton<String>(
                isExpanded: true,
                key: ValueKey(selectedSiDo),
                value: selectedSiGunGu,
                items: siGunguMenuEntries,
                onChanged: onSelectSiGunGu,
                underline: const SizedBox.shrink(),
              ),
            ),
          ]
        ],
      );
    } else {
      return Container();
    }
  }

  onSelectSiDo(String? value) async {
    selectedSiDo = value ?? '';
    selectedSiGunGu = "";
    final http.Response res = await http.get(
      Uri.parse(
          "https://grpc-proxy-server-mkvo6j4wsq-du.a.run.app/v1/regcodes?regcode_pattern=${value!.substring(0, 2)}*00000"),
    );

    final Map<String, dynamic> result = json.decode(res.body);
    siGunGu.clear();
    for (var element in (result['regcodes'] as List)) {
      siGunGu.add((
        code: element['code'],
        name: const Utf8Decoder().convert(element['name'].codeUnits),
      ));
    }

    siGunGu.insert(
      0,
      (
        code: '',
        name: '시/군/구 선택',
      ),
    );
    setState(() {});
  }

  onSelectSiGunGu(String? value) {
    selectedSiGunGu = value ?? '';
    setState(() {});
    widget.onSelected(siGunGu.firstWhere((e) => e.code == value).name);
  }
}
