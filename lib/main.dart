import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.black,
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
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = prefs.getString('draft') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Drafter"),
      ),
      body: Center(
        child: TextField(
          controller: controller,
          maxLines: 50,
          minLines: 1,
          onChanged: (value) async {
            await prefs.setString('draft', controller.text);
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String text = controller.text.toString();
          Clipboard.setData(ClipboardData(text: text));
          controller.text='';
          await prefs.setString('drafter','');

        },
        child: const Icon(Icons.copy_all_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
