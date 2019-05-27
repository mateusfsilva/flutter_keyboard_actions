import 'package:flutter/cupertino.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) =>
      KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: CupertinoColors.lightBackgroundGray,
        nextFocus: true,
        actions: [
          KeyboardAction(
            focusNode: _nodeText1,
          ),
          KeyboardAction(
            focusNode: _nodeText2,
            closeWidget: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(CupertinoIcons.clear_thick),
            ),
          ),
          KeyboardAction(
            focusNode: _nodeText3,
            onTapAction: () {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      content: Text("Custom Action"),
                      actions: <Widget>[
                        CupertinoButton(
                          child: Text("OK"),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    );
                  });
            },
          ),
          KeyboardAction(
            focusNode: _nodeText4,
            displayCloseWidget: false,
          ),
          KeyboardAction(
            focusNode: _nodeText5,
            closeWidget: Padding(
              padding: EdgeInsets.all(5.0),
              child: Text("CLOSE"),
            ),
          ),
        ],
      );

  @override
  void initState() {
    // Configure keyboard actions
    FormKeyboardActions.setKeyboardActions(context, _buildConfig(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Container(
            height: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CupertinoTextField(
                  keyboardType: TextInputType.number,
                  focusNode: _nodeText1,
                  placeholder: "Input Number",
                ),
                CupertinoTextField(
                  keyboardType: TextInputType.text,
                  focusNode: _nodeText2,
                  placeholder: "Input Text with Custom Close Widget",
                ),
                CupertinoTextField(
                  keyboardType: TextInputType.number,
                  focusNode: _nodeText3,
                  placeholder: "Input Number with Custom Action",
                ),
                CupertinoTextField(
                  keyboardType: TextInputType.text,
                  focusNode: _nodeText4,
                  placeholder: "Input Text without Close Widget",
                ),
                CupertinoTextField(
                  keyboardType: TextInputType.number,
                  focusNode: _nodeText5,
                  placeholder: "Input Number with Custom Close Widget",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
