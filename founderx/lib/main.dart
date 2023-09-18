import 'package:flutter/material.dart';
import 'package:founderx/new.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
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
      debugShowCheckedModeBanner: false,
      title: 'FounderX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Session? s = supabase.auth.currentSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('FounderX Daily Summary'),
        actions: [
          IconButton(
            onPressed: () async {
              if (s == null) {
                await supabase.auth.signInWithOAuth(Provider.google);
              } else {
                await supabase.auth.signOut();
              }
            },
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: const NoteList(),
      floatingActionButton: s == null ? null : FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewPost())),
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await supabase.auth.signInWithOAuth(Provider.google);
          Future(() => {
            if (supabase.auth.currentSession != null) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyHomePage()))
            }
          });
        },
        child: const Text('Sign in with Google'),
      ),
    );
  }
}

class NoteList extends StatefulWidget {
  const NoteList({
    super.key,
  });

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  Map dayMap = {};
  Map profiles = {};

  void fetchNotes() async {
    await supabase.from('founderx_notes').select('*, day_id(id, description))')
    .order('day_id', ascending: false)
    .order('created_at', ascending: false)
    .then((value) => {
      setState(() {
        value.forEach((element) {
          var key = element['day_id']['id'];
          if (dayMap[key] == null) {
            dayMap[key] = [element];
          } else {
            dayMap[key].add(element);
          }
        });
      })
    });
    await supabase.from('founderx_profiles').select('*').then((value) => {
      setState(() {
        value.forEach((element) {
          profiles[element['id']] = element['email'];
        });
      })
    });
  }
  @override
  void initState() {
    fetchNotes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dayMap.length,
      itemBuilder: (context, index) {
        var dayTitle = dayMap[index+1][0]['day_id']['description'];
        if (profiles.isEmpty) return const Center(child: CircularProgressIndicator());
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(dayTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ...dayMap[index+1].map<Widget>((e) => Card(
                child: ListTile(
                  title: Text(profiles[e['user_id']], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(e['note'], style: Theme.of(context).textTheme.titleSmall),
                ),
              )).toList(),
            ],
          ),
        );
      },
    );
  }
}
