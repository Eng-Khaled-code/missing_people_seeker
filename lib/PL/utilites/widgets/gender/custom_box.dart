import 'package:flutter/material.dart';

class CustomBox extends StatelessWidget {
  final List<Widget>? items;

  CustomBox({@required this.items});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Container(
            height: MediaQuery.of(context).size.height * .2,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background ==
                        Color(0xff90caf9)
                    ? Colors.white
                    : Colors.black45,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                  )
                ],
                borderRadius: BorderRadius.circular(5)),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: items!),
            )));
  }
}
