import 'package:flutter/material.dart';
import 'package:founderx/new.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const url = 'https://qfnafrunpgjcijgetlkw.supabase.co';
const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmbmFmcnVucGdqY2lqZ2V0bGt3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzg1MzIyOTksImV4cCI6MTk5NDEwODI5OX0.RGVWfJPA7SkiJjjKiyyAQbDkIfD08YMZ8AVxJzQ3f5w';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    authFlowType: AuthFlowType.pkce,
    url: url,
    anonKey: anonKey,
  );
  runApp(const MyApp());
} 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FounderX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FounderX Daily Summary'),
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

  void _incrementCounter() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewPost()));
  }

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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '0',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
