import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedWordModel(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class SelectedWordModel extends ChangeNotifier {
  String _selectedWord = '';

  String get selectedWord => _selectedWord;

  void setSelectedWord(String word) {
    _selectedWord = word;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Team"),
          bottom: const TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(
                text: "Employee",
              ),
              Tab(
                text: "Performance",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Placeholder(),
            PerformancePage(),
          ],
        ),
      ),
    );
  }
}

class PerformancePage extends StatefulWidget {
  const PerformancePage({Key? key}) : super(key: key);

  @override
  State<PerformancePage> createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    // Sample data for the bar graph
    final List<int> barValues =
        List.generate(5, (index) => _random.nextInt(10));

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardWidget(
                  title: 'Card 1',
                  icon: Icons.star,
                  number: _random.nextInt(101),
                ),
                CardWidget(
                  title: 'Card 2',
                  icon: Icons.favorite,
                  number: _random.nextInt(101),
                ),
                CardWidget(
                  title: 'Card 3',
                  icon: Icons.thumb_up,
                  number: _random.nextInt(101),
                ),
                CardWidget(
                  title: 'Card 4',
                  icon: Icons.thumb_down,
                  number: _random.nextInt(101),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: EmployeesList(),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: BarGraph(barValues: barValues),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Text('Generated Words'),
          controlAffinity: ListTileControlAffinity.leading,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: WordList(),
            ),
          ],
        ),
      ],
    );
  }
}

class WordList extends StatelessWidget {
  List<String> generateRandomWords(int count) {
    return List.generate(count, (index) => generateRandomWord());
  }

  String generateRandomWord() {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    return String.fromCharCodes(
      List.generate(
          5, (index) => letters.codeUnitAt(Random().nextInt(letters.length))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedWordModel>(
      builder: (context, model, child) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            String word = generateRandomWord();
            return InkWell(
              onTap: () {
                context.read<SelectedWordModel>().setSelectedWord(word);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: word == model.selectedWord ? Colors.blue : null,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class BarGraph extends StatelessWidget {
  final List<int> barValues;

  BarGraph({required this.barValues});

  @override
  Widget build(BuildContext context) {
    final selectedWordModel = Provider.of<SelectedWordModel>(context);

    // Convert the selected word to an index for selecting barValues
    int selectedIndex =
        barValues.indexOf(selectedWordModel.selectedWord.length);

    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: barValues[0].toDouble(), color: Colors.blue),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  toY: barValues[1].toDouble(), color: Colors.green),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                  toY: barValues[2].toDouble(), color: Colors.orange),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(toY: barValues[3].toDouble(), color: Colors.red),
            ],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(
                  toY: barValues[4].toDouble(), color: Colors.purple),
            ],
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final int number;

  const CardWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.blue,
                ),
                SizedBox(width: 8.0),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              number.toString(),
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
