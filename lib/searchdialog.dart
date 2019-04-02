import 'package:flutter/material.dart';
import 'package:flutter_itunes/actions.dart';
import 'package:flutter_itunes/appstate.dart';
import 'package:flutter_redux/flutter_redux.dart';

typedef OnSearchCallback = Function(String searchText);

class SearchDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, OnSearchCallback>(
      converter: (store) {
        return (searchText) => store.dispatch(getSearchResult);
      },
      builder: (_, searchCallback) {
        print("BLAAA");
        return _SearchDialogWidget(searchCallback);
      }
    );
  }
}

class _SearchDialogWidget extends StatefulWidget {
  final OnSearchCallback _callback;

  _SearchDialogWidget(this._callback);

  @override
  State<StatefulWidget> createState() => _SearchDialogWidgetState(_callback);
}

class _SearchDialogWidgetState extends State<_SearchDialogWidget> {
  String _searchText;
  final OnSearchCallback _callback;

  _SearchDialogWidgetState(this._callback);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: new Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'e.g. Madonna'
              ),
              onChanged: _handleTextChanged,
            ),
          )
        ],
      ),
      actions: [
        FlatButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        FlatButton(
          child: const Text('Search'),
          onPressed: () {
            Navigator.pop(context);
            _callback(_searchText);
          },
        )
      ],
    );
  }

  _handleTextChanged(String newSearchText) {
    setState(() {
      _searchText = newSearchText;
    });
  }
}