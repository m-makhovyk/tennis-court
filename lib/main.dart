import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'player_model.dart';

class MacOSScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: MacOSScrollBehavior(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: dummyPlayers.length,
              itemBuilder: (context, index) {
                return PlayerRow(player: dummyPlayers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerRow extends StatelessWidget {
  final Player player;

  const PlayerRow({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        player.rank.toString(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      title: Text(player.name),
      subtitle: Text('Points: ${player.points}'),
      trailing: Text(player.flag, style: const TextStyle(fontSize: 24)),
    );
  }
}
