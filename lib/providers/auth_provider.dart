import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  String _name = "";
  String _email = "";

  bool get isLoggedIn => _isLoggedIn;
  String get name => _name;
  String get email => _email;

  // Mock user avatar (could be a URL or asset path in a real app)
  // For now, we'll just use a generic icon in the UI, but this state is key.
  // If you wanted a specific image asset:
  // String get userAvatar => "assets/images/user_avatar.png";

  void login() {
    _isLoggedIn = true;
    _name = "Coastal User";
    _email = "user@blueguide.com";
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _name = "";
    _email = "";
    notifyListeners();
  }
}
