import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _kBarSize = 45.0;

enum KeyboardActionsPlatform { ANDROID, IOS, ALL }

class KeyboardAction {
  ///This is the Focus object to know if the textfield has or lost the focus
  final FocusNode focusNode;

  ///Optional callback to know if the button for this specific textfield was tapped
  final VoidCallback onTapAction;

  ///Optional widget to display to the right of the bar
  final Widget closeWidget;

  ///false if you don't want to display a closeWidget
  final bool displayCloseWidget;

  /// close widget label to show if don't pass any
  final String closeLabel;

  KeyboardAction({
    @required this.focusNode,
    this.onTapAction,
    this.closeWidget,
    this.displayCloseWidget = true,
    this.closeLabel = 'Done',
  });
}

class FormKeyboardActions extends StatefulWidget {
  /// Key used on close button
  static const Key closeButtonKey = Key('closeButtonKey');

  /// You can pass any widget, ideally it should content a textfield
  final Widget child;

  /// Keyboard Action for specific platform
  /// KeyboardActionsPlatform : ANDROID , IOS , ALL
  final KeyboardActionsPlatform keyboardActionsPlatform;

  ///true if you want to display arrows to move through your inputs
  final bool nextFocus;

  ///KeyboardAction for each textfield you want to have actions
  final List<KeyboardAction> actions;

  ///Color for the background of the Custom keyboard buttons
  final Color keyboardBarColor;

  FormKeyboardActions({
    this.child,
    this.keyboardActionsPlatform = KeyboardActionsPlatform.ALL,
    this.nextFocus = true,
    this.actions,
    this.keyboardBarColor,
  }) : assert(child != null);

  @override
  _FormKeyboardActionsState createState() => _FormKeyboardActionsState();
}

class _FormKeyboardActionsState extends State<FormKeyboardActions>
    with WidgetsBindingObserver {
  Map<int, KeyboardAction> _map = Map();
  bool _isKeyboardVisible = false;
  KeyboardAction _currentAction;
  int _currentIndex = 0;

  _addAction(int index, KeyboardAction action) {
    _map[index] = action;
  }

  _clearAllFocusNode() {
    _map = Map();
  }

  _clearFocus() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<Null> _focusNodeListener() async {
    bool hasFocusFound = false;

    _map.keys.forEach((key) {
      final currentAction = _map[key];

      if (currentAction.focusNode != null && currentAction.focusNode.hasFocus) {
        hasFocusFound = true;
        _currentAction = currentAction;
        _currentIndex = key;

        return;
      }
    });

    _shouldRefresh(hasFocusFound);
  }

  _shouldGoToNextFocus(KeyboardAction action, int nextIndex) {
    if (action.focusNode != null) {
      _currentAction = action;
      _currentIndex = nextIndex;

      FocusScope.of(context).requestFocus(_currentAction.focusNode);
      _shouldRefresh(true);
    }
  }

  _onTapUp() {
    final nextIndex = _currentIndex - 1;

    if (nextIndex >= 0) {
      final currentAction = _map[nextIndex];
      _shouldGoToNextFocus(currentAction, nextIndex);
    }
  }

  _onTapDown() {
    final nextIndex = _currentIndex + 1;

    if (nextIndex < _map.length) {
      final currentAction = _map[nextIndex];
      _shouldGoToNextFocus(currentAction, nextIndex);
    }
  }

  _shouldRefresh(bool newValue) {
    setState(() {
      _isKeyboardVisible = newValue;
    });
  }

  _startListeningFocus() {
    _map.values
        .forEach((action) => action.focusNode.addListener(_focusNodeListener));
  }

  _dismissListeningFocus() {
    _map.values.forEach(
        (action) => action.focusNode.removeListener(_focusNodeListener));
  }

  Color _getColor() {
    if (widget.keyboardBarColor != null) {
      return widget.keyboardBarColor;
    }

    if (Platform.isIOS) {
      return CupertinoColors.lightBackgroundGray;
    }

    return Colors.grey[200];
  }

  bool isAvailable() =>
      widget.keyboardActionsPlatform == KeyboardActionsPlatform.ALL ||
      (widget.keyboardActionsPlatform == KeyboardActionsPlatform.IOS &&
          defaultTargetPlatform == TargetPlatform.iOS) ||
      (widget.keyboardActionsPlatform == KeyboardActionsPlatform.ANDROID &&
          defaultTargetPlatform == TargetPlatform.android);

  IconData _getCUpertinoIcon(int code) {
    /// The icon font used for Cupertino icons.
    const String iconFont = 'CupertinoIcons';

    /// The dependent package providing the Cupertino icons font.
    const String iconFontPackage = 'cupertino_icons';

    return IconData(
      code,
      fontFamily: iconFont,
      fontPackage: iconFontPackage,
    );
  }

  Widget _getPreviousButtom() {
    Icon icon;

    if (widget.nextFocus) {
      if (Platform.isIOS) {
        icon = Icon(
          _getCUpertinoIcon(0xf3d8),
          color: CupertinoColors.activeBlue,
        );

        return CupertinoButton(
          child: icon,
          onPressed: _onTapUp,
        );
      } else {
        icon = const Icon(Icons.keyboard_arrow_up);

        return IconButton(
          icon: icon,
          onPressed: _onTapUp,
        );
      }
    }

    return const SizedBox();
  }

  Widget _getNextButtom() {
    Icon icon;

    if (widget.nextFocus) {
      if (Platform.isIOS) {
        icon = Icon(
          _getCUpertinoIcon(0xf3d0),
          color: CupertinoColors.activeBlue,
        );

        return CupertinoButton(
          child: icon,
          onPressed: _onTapDown,
        );
      } else {
        icon = const Icon(Icons.keyboard_arrow_down);

        return IconButton(
          icon: icon,
          onPressed: _onTapDown,
        );
      }
    }

    return const SizedBox();
  }

  Widget _getCloseButtom() {
    if (_currentAction?.closeWidget != null) {
      return _currentAction?.closeWidget;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 12.0,
      ),
      child: Text(
        _currentAction.closeLabel,
        style: TextStyle(
          color: Platform.isIOS ? CupertinoColors.activeBlue : Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _closeButtomTapped() {
    if (_currentAction?.onTapAction != null) {
      _currentAction.onTapAction();
    }

    _clearFocus();
  }

  Widget _getCloseAction() {
    if (_currentAction?.displayCloseWidget != null &&
        _currentAction.displayCloseWidget) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          key: FormKeyboardActions.closeButtonKey,
          onTap: _closeButtomTapped,
          child: _getCloseButtom(),
        ),
      );
    }

    return const SizedBox();
  }

  Widget _getBar() {
    if (isAvailable()) {
      return Positioned(
        bottom: 0.0,
        child: AnimatedCrossFade(
          duration: Duration(milliseconds: 180),
          crossFadeState: _isKeyboardVisible
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Container(
            height: _kBarSize,
            color: _getColor(),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                _getPreviousButtom(),
                _getNextButtom(),
                Spacer(),
                _getCloseAction()
              ],
            ),
          ),
          secondChild: Container(
            height: 0.0,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      );
    } else {
      return const SizedBox(height: 0.0);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (state == AppLifecycleState.paused) {
        FocusScope.of(context).requestFocus(FocusNode());

        setState(() {
          _isKeyboardVisible = false;
        });
      }
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _dismissListeningFocus();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.actions.isNotEmpty) {
      _clearAllFocusNode();

      for (int i = 0; i < widget.actions.length; i++) {
        _addAction(i, widget.actions[i]);
      }

      _dismissListeningFocus();
      _startListeningFocus();
    }

    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: _isKeyboardVisible && isAvailable() ? _kBarSize : 0.0,
          ),
          child: widget.child,
        ),
        _getBar()
      ],
    );
  }
}
