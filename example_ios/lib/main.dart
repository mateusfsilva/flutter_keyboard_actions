import 'package:flutter/cupertino.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: Color(0xff444da1),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage() : super();

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Keyboard Actions Sample")
      ),
      child: FormKeyboardActions(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Color(0xffeaeae8),
        nextFocus: true,
        actions: [
          KeyboardAction(
            focusNode: _nodeText1
          ),
          KeyboardAction(
            focusNode: _nodeText2,
            closeWidget: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(CupertinoIcons.clear_thick),
            )
          ),
          KeyboardAction(
            focusNode: _nodeText3,
            onTapAction: () {
              CupertinoAlertDialog(
                content: Text("Custom Action"),
                actions: <Widget>[
                  CupertinoButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.of(context).pop()
                  )
                ]
              );
            }
          ),
          KeyboardAction(
            focusNode: _nodeText4,
            displayCloseWidget: false,
          ),
          KeyboardAction(
            focusNode: _nodeText5,
            closeWidget: Padding(
              padding: EdgeInsets.all(5.0),
              child: Text("CLOSE")
            ),
          ),
        ],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0
                    ),
                    child: CupertinoTextField(
                      keyboardType: TextInputType.number,
                      focusNode: _nodeText1,
                      placeholder: "Input Number"
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0
                    ),
                    child: CupertinoTextField(
                      keyboardType: TextInputType.text,
                      focusNode: _nodeText2,
                      placeholder: "Input Text with Custom Close Widget"
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0
                    ),
                    child: CupertinoTextField(
                      keyboardType: TextInputType.number,
                      focusNode: _nodeText3,
                      placeholder: "Input Number with Custom Action"
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0
                    ),
                    child: CupertinoTextField(
                      keyboardType: TextInputType.text,
                      focusNode: _nodeText4,
                      placeholder: "Input Text without Close Widget"
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0
                    ),
                    child: CupertinoTextField(
                      keyboardType: TextInputType.number,
                      focusNode: _nodeText5,
                      placeholder: "Input Number with Custom Close Widget"
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}
