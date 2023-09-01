import 'package:flutter/cupertino.dart';

import '../domain/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
      email: '',
      name: '',
      phone: '',
      renewalToken: '',
      token: '',
      type: '',
      userId: 2);

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
