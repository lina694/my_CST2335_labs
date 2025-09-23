import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  double _counter = 0.0;

  void setNewValue(double value)
  {
    setState(() {
      _counter = value;
    });
  }
  void _incrementCounter() {
    setState(() {
      if(_counter < 99.0)

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

          title: Text("ABCDE"),
          actions: [
            OutlinedButton(onPressed: () { }, child:Text("Button 1")),
            OutlinedButton(onPressed: (){ }, child: Text("Button 2"))]

      ),
      drawer:Drawer(
          child:Text("Hi there")),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: () {}, child: Text('Button 1')),
            ElevatedButton(onPressed: () {}, child: Text('Button 2')),
            ElevatedButton(onPressed: () {}, child: Text('Button 3')),
            ElevatedButton(onPressed: () {}, child: Text('Button 4')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
