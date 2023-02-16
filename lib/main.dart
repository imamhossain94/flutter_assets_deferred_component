import 'package:flutter/material.dart';
import 'package:flutter_deferred/images.dart';
import 'library/juz1.dart' deferred as juz1;
import 'library/juz2.dart' deferred as juz2;

// If you accidentally remove this imports then uncomment this two lines
// import 'library/juz1.dart' deferred as juz1;
// import 'library/juz2.dart' deferred as juz2;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deferred Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Deferred Demo'),
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
  int _juz = 1;

  void _changeJuz() {
    setState(() {
      _juz = _juz == 1 ? 2 : 1;
    });
  }

  Future<List<ImageProvider>> _loadImages(int juzNumber) async {
    switch (juzNumber) {
      case 1:
        await juz1.loadLibrary();
        return await Images.load(1);
      case 2:
        await juz2.loadLibrary();
        return await Images.load(2);
      default:
        return await juz1.loadLibrary();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: FutureBuilder(
            future: _loadImages(_juz),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) =>
                        Image(image: snapshot.data![index]),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                onPressed: _changeJuz,
                child: const Icon(Icons.navigate_before),
              ),
              Text(
                'Juz: $_juz',
                style: Theme.of(context).textTheme.headline4,
              ),
              FloatingActionButton(
                onPressed: _changeJuz,
                child: const Icon(Icons.navigate_next),
              )
            ],
          ),
        ));
  }
}
