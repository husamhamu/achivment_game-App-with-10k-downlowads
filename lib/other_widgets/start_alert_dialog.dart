import 'package:achivment_game/models/StartingTimeStorage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartAlertDialog extends StatefulWidget {
  final Function gameStarted;

  StartAlertDialog({this.gameStarted});

  @override
  _StartAlertDialogState createState() => _StartAlertDialogState();
}

class _StartAlertDialogState extends State<StartAlertDialog> {
  TextEditingController _textEditingController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    String validator(String value) {
      if (value.contains('-') ||
          value.contains(',') ||
          value.contains(' ') ||
          value.isEmpty) {
        return 'only numbers between 4 and 12';
      } else if (int.tryParse(value) != null) {
        int i = int.parse(value);
        if (i < 4 || i > 12) {
          return 'only numbers between 4 and 12';
        } else {
          return null;
        }
      } else {
        return null;
      }
    }

    return AlertDialog(
      content: Container(
        width: width,
        height: height - (height * 0.9),
        child: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            controller: _textEditingController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              icon: const Icon(Icons.view_week),
              labelText: 'Number of the weeks:',
            ),
            validator: validator,
            onChanged: (value) {
              this._formKey.currentState.save();
              this._formKey.currentState.validate();
              int i = 0;
              if (int.tryParse(value) == null) {
                _textEditingController.clear();
              } else {
                i = int.parse(value);
                if (i > 12) {
                  _textEditingController.clear();
                }
              }
            },
          ),
        ),
      ),
      elevation: 10,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _textEditingController.clear();
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        FlatButton(
          onPressed: () {
            String value = validator(_textEditingController.text) == null
                ? _textEditingController.text
                : validator(_textEditingController.text);
            if (int.tryParse(value) != null) {
              int weekNum = int.parse(_textEditingController.text);
              if (weekNum > 4 || weekNum < 12) {
                print('weekNum $weekNum');
                Provider.of<StartingTimeStorage>(context, listen: false)
                    .writeStartingTime(DateTime.now(), weekNum);
                Provider.of<StartingTimeStorage>(context, listen: false)
                    .readStartingTime();
                Navigator.pop(context);
                _textEditingController.clear();
                widget.gameStarted();
              }
            } else {
              print('hii');
            }
          },
          child: const Text('Start'),
        ),
      ],
    );
  }
}
