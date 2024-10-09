import 'package:flutter/material.dart';

class DayButton extends StatelessWidget {
  final String txt;
  const DayButton({
    super.key, required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: TextButton(
          onPressed: (){},
          style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              shape: WidgetStatePropertyAll(CircleBorder()),
              side: WidgetStatePropertyAll(BorderSide(color: Colors.black,width: 1))
          ),
          child: Text('M',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600))),
    );
  }
}