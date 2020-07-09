import 'package:flutter/material.dart';
import 'package:flutter_skype/utils/universal_variables.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: UniversalVariables.fadeGradient,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        Icons.edit,
        color: Colors.grey,
        size: 25,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}