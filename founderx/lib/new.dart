import 'package:flutter/material.dart';
import 'package:founderx/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}
List<String> list = <String>['1', '2', '3'];
String placeholder = '1. \n2. \n3. ';

class _NewPostState extends State<NewPost> {
  Session? s = supabase.auth.currentSession;
  String dropdownValue = list.first;
  final fieldText = TextEditingController(text: placeholder);
  Map oldNote = {};

  void oldData() async {
    await supabase.from('founderx_notes').select().eq('day_id', dropdownValue)
    .eq('user_id', s!.user.id)
    .then((value) => {
      if (value.length == 0) {
        setState(() {
          oldNote['note'] = placeholder;
          fieldText.text = placeholder;
          oldNote['id'] = null;
        })
      } else {
        setState(() {
          oldNote['note'] = value[0]['note'];
          fieldText.text = oldNote['note'];
          oldNote['id'] = value[0]['id'];
        })
      }
    });
  }
  @override
  void initState() {
    oldData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('New Note'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownMenu<String>(
                width: 200.0,
                initialSelection: list.first,
                onSelected: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                  oldData();
                },
                dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: 'Day $value');
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                maxLines: 3, //or null
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: fieldText,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (oldNote['id'] == null) {
            await supabase.from('founderx_notes').insert({
              'user_id': s!.user.id,
              'day_id': dropdownValue,
              'note': fieldText.text,
            });
          } else {
            await supabase.from('founderx_notes').upsert({
              'id': oldNote['id'],
              'user_id': s!.user.id,
              'day_id': dropdownValue,
              'note': fieldText.text,
            });
          }
          fieldText.clear();
          Future(()=> Navigator.pop(context));
          Future(() => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyHomePage())));
        },
        child: const Icon(Icons.send),
      )
    );
  }
}