import 'package:flutter/material.dart';

// class KeepAlivePage extends StatefulWidget {
//   KeepAlivePage({
//     Key key,
//     @required this.child,
//   }) : super(key: key);

//   final Widget child;

//   @override
//   _KeepAlivePageState createState() => _KeepAlivePageState();
// }
class KeepAlivePage extends StatefulWidget {
  const KeepAlivePage({
    Key? key, // `key` peut être nul
    this.child, // `child` peut être nul
  }) : super(key: key);

  final Widget? child; // `child` peut être nul

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}


class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.child ?? Container();
  }

  @override
  bool get wantKeepAlive => true;
}
