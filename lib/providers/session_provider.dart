// lib/providers/session_provider.dart
import 'package:flutter/material.dart';

class SessionProvider with ChangeNotifier {
  int? userId;
  int? campId;

  void setSession({required int user, required int camp}) {
    userId = user;
    campId = camp;
    notifyListeners();
  }

  void clearSession() {
    userId = null;
    campId = null;
    notifyListeners();
  }
}
