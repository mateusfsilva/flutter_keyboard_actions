import 'package:example_cupertino/content.dart';
import 'package:flutter/cupertino.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

// Application entry-point
void main() => runApp(MyApp()); // Toggle this to test in a dialog

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  _openWidget(
    BuildContext context,
    Widget widget,
  ) =>
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => widget,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
        child: Builder(
          builder: (myContext) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CupertinoButton(
                        child: Text("Full Screen form"),
                        onPressed: () => _openWidget(
                              myContext,
                              ScaffoldTest(),
                            ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CupertinoButton(
                        child: Text("Dialog form"),
                        onPressed: () => _openWidget(
                              myContext,
                              DialogTest(),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}

/// Displays our [TextField]s in a [Scaffold] with a [FormKeyboardActions].
class ScaffoldTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        resizeToAvoidBottomInset: true,
        navigationBar: CupertinoNavigationBar(
          middle: Text("Keyboard Actions Sample"),
        ),
        child: FormKeyboardActions(
          child: Content(),
        ),
      );
}

/// Displays our [FormKeyboardActions] nested in a [AlertDialog].
class DialogTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        resizeToAvoidBottomInset: true,
        navigationBar: CupertinoNavigationBar(
          middle: Text("Keyboard Actions Sample"),
        ),
        child: Builder(
          builder: (context) {
            return Center(
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                child: Text('Launch dialog'),
                onPressed: () => _launchInDialog(context),
              ),
            );
          },
        ),
      );

  _launchInDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Dialog test'),
          content: FormKeyboardActions(
            autoScroll: true,
            child: Content(),
          ),
          actions: [
            CupertinoButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
