import 'package:flutter/material.dart';

class PromotionalBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.green[100],
      child: Center(
        child: Text(
          'Promotional Banner',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
