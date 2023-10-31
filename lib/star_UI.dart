import 'package:flutter/material.dart';

class StarUI extends StatefulWidget {
  const StarUI({super.key});

  @override
  State<StarUI> createState() => _StarUIState();
}

class _StarUIState extends State<StarUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 379.5,
      height: 640.0,
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                hintText: 'star',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
