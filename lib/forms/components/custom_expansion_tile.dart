import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> tiles;
  const CustomExpansionTile(
      {super.key, required this.title, required this.tiles});

  @override
  State<CustomExpansionTile> createState() => _ExpansionTileExampleState();
}

class _ExpansionTileExampleState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return /* Column(
      children: <Widget>[ */
        ExpansionTile(
          title: Text(widget.title),
          childrenPadding: const EdgeInsets.only(left: 20),
          trailing: Icon(_isExpanded
              ? Icons.arrow_drop_down_circle
              : Icons.arrow_drop_down),
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          //subtitle: Text('Trailing expansion arrow icon'),
          children: widget.tiles,
        )
        /* const ExpansionTile(
          title: Text('ExpansionTile 3'),
          subtitle: Text('Leading expansion arrow icon'),
          controlAffinity: ListTileControlAffinity.leading,
          children: <Widget>[
            ListTile(title: Text('This is tile number 3')),
          ],
        ), */
     /*  ],
    ) */;
  }
}
