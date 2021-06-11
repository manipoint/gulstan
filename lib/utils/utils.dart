
  import 'package:flutter/material.dart';

bottomLoader() {
    Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 35.0,
        height: 35,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
        ),
      ),
    );
  }