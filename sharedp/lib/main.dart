import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  List<int> _storedIntegers = [];

  @override
  void initState() {
    super.initState();
    _loadStoredIntegers();
  }

  // Load stored integers from shared preferences
  Future<void> _loadStoredIntegers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedIntegers = prefs
              .getStringList('storedIntegers')
              ?.map((e) => int.parse(e))
              .toList() ??
          [];
    });
  }

  // Save the entered integer to shared preferences
  Future<void> _saveInteger(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedIntegers.add(value);
      prefs.setStringList(
          'storedIntegers', _storedIntegers.map((e) => e.toString()).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Preferences Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Stored Integers:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _storedIntegers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_storedIntegers[index].toString()),
                  );
                },
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter an integer'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                int value = int.parse(_controller.text);
                _saveInteger(value);
                _controller.clear();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
