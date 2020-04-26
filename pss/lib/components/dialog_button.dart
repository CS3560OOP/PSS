import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  const DialogButton({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(this.label),
      onPressed: this.onPressed,
    );
  }
}
