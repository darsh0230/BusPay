import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  String? uid;
  void updateData(String uid) {
    this.uid = uid;
    notifyListeners();
  }
}
