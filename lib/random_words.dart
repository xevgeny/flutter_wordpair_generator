import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _selectedColor = Colors.red[300];

  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // returns Devider or ListTile
      itemBuilder: (context, item) {
        if (item.isOdd) return Divider();
        final index = item ~/ 2;
        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _savedWordPairs.contains(pair);
    final icon = _savedWordPairs.contains(pair)
        ? Icon(Icons.favorite, color: _selectedColor)
        : Icon(Icons.favorite_border);
    return ListTile(
      title: Text(
        pair.join('-'),
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: icon,
      onTap: () {
        setState(() {
          alreadySaved
              ? _savedWordPairs.remove(pair)
              : _savedWordPairs.add(pair);
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair) {
          return ListTile(
            title: Text(
              pair.join('-'),
              style: TextStyle(fontSize: 18.0),
            ),
          );
        });
        final List<Widget> divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();
        return Scaffold(
          appBar: AppBar(title: Text('Saved')),
          body: ListView(children: divided),
        );
      },
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPair Generator'),
      ),
      body: _buildList(),
      floatingActionButton: new FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.favorite),
        backgroundColor: _selectedColor,
        onPressed: _pushSaved,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
