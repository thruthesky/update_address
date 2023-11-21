import 'package:find_address/find_address.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? re;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              color: Colors.blue.shade100,
              child: SelectSiGunGu(
                onSelected: (value) => print(value),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              color: Colors.orange.shade100,
              child: SelectSiGunGu.column(
                onSelected: (value) => print(value),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                re = await findAddress(
                  context,
                  kakaoApiKey: "7c567f8e9e57ffa08531df5aa9efebb5",
                  dataApiKey: "U01TX0FVVEgyMDIzMTExODE5MjMzMDExNDI4ODc=",
                  themeData: Theme.of(context).copyWith(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.purple.shade300),
                    textTheme: Theme.of(context).textTheme.copyWith(
                          titleMedium: const TextStyle(color: Colors.black),
                          labelMedium: const TextStyle(color: Colors.blue),
                        ),
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    useMaterial3: true,
                  ),
                );
                print(re);
                setState(() {});
              },
              child: const Text(
                '주소 찾기',
              ),
            ),
            Text(
              re.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
