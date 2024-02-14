import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "For Mina :)",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var synonyms = ['valentine', 'mcmuffin', 'love bug', 'tootsie roll', 'amor', 'bae', 'juliet', 'sweetie pie', 'angel', 'dream girl', 'corazon', 'darling', 'dearest', 'honeybun', 'admirer', 'cocoa puff', 'aphrodite', 'reeses cup', 'cara mia', 'missus', 'queen', 'inamorata', 'paramour', 'sweet pea', "taylor swift"];
  var current = 'valentine';
  var ind = 0;
  void getNext() {
    ind = ind + 1;
    if (ind == synonyms.length){
      ind = 0;
    }
    current = synonyms[ind];
    notifyListeners();
  }
  var favorites = <String>[];
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    ind = ind + 1;
    if (ind == synonyms.length){
      ind = 0;
    }
    current = synonyms[ind];
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 700,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class GeneratorPage extends StatefulWidget {
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 4));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Mina, will you be my..."),
          SizedBox(height: 10),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality
                    .explosive,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                  _controllerCenter.play();
                },
                icon: Icon(icon),
                label: Text('Yes'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Hell nah'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair),
          ),
      ],
    );
  }

}



class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final String pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,    // ← And also this.
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.toLowerCase(), style: style,),
      ),
    );
  }
}

