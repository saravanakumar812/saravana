String validateUsername(String value, String userName) {
  late String _msg;
  RegExp regex = new RegExp('([a-zA-Z])');
  if (value.isEmpty) {
    _msg = "Your username is required";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid username";
  }
  return _msg;
}
