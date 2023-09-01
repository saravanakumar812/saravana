import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sign_in/Screens/DashBoard.dart';
// import 'package:sign_in/Screens/login.dart';
// import 'package:provider/provider.dart';
// import 'package:sign_in/Providers/user_provider.dart';
import 'package:sign_in/utility/shared_pre.dart';

import 'domain/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Example',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
  }

  Status get registeredInStatus => _registeredInStatus;

  set registeredInStatus(Status value) {
    _registeredInStatus = value;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      "json": {
        'username': username,
        'password': password,
      }
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse('https://clubits-hrms-demo.azurewebsites.net/trpc/user.signIn'),
      body: json.encode(loginData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
        'X-ApiKey': 'ZGlzIzEyMw=='
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      print(responseData);

      var userData = responseData['Content'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      // _loggedInStatus = Status.NotLoggedIn;
      // notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;
  }

  static onError(error) {
    print('the error is ${error.detail}');
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}

@override
// Widget build(BuildContext context) {
//   AuthProvider auth = Provider.of<AuthProvider>(context);
//   final formKey = GlobalKey<FormState>();
//   doLogin() {
//     final form = formKey.currentState;

//     if (form!.validate()) {
//       form.save();

//       final Future<Map<String, dynamic>> respose =
//           auth.login(_userName, _password);

//       respose.then((response) {
//         if (response['status']) {
//           User user = response['user'];

//           Provider.of<UserProvider>(context, listen: false).setUser(user);

//           Navigator.pushReplacementNamed(context, '/dashboard');
//         } else {
//           Flushbar(
//             title: "Failed Login",
//             message: response['message']['message'].toString(),
//             duration: Duration(seconds: 3),
//           ).show(context);
//         }
//       });
//     } else {
//       Flushbar(
//         title: 'Invalid form',
//         message: 'Please complete the form properly',
//         duration: Duration(seconds: 10),
//       ).show(context);
//     }
//   }
// }

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Future<Map<String, dynamic>> _login() async {
  //   final String username = _usernameController.text;
  //   final String password = _passwordController.text;
  //   Map<String, dynamic> users;

  //   final Map<String, dynamic> data = {
  //     "json": {
  //       'username': username,
  //       'password': password,
  //     }
  //   };

  //   final Uri url = Uri.parse(
  //       'https://clubits-hrms-demo.azurewebsites.net/trpc/user.signIn');

  //   final response = await http.post(
  //     url,
  //     body: json.encode(data),
  //     headers: {'Content-Type': 'application/json'},
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> responseBody = json.decode(response.body);

  //     print("login successfully");
  //     users = responseBody["result"]["data"]["json"];
  //     print("Data : " + users.toString());
  //   } else {
  //     throw Exception('Failed.');
  //   }
  //   return data;
  // }

  Future<Map<String, dynamic>> login1() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    Map<String, dynamic> users;

    final Map<String, dynamic> data = {
      "json": {
        'username': username,
        'password': password,
      }
    };
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      final Uri url = Uri.parse(
          'https://clubits-hrms-demo.azurewebsites.net/trpc/user.signIn');

      final response = await http.post(
        url,
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashBoard()));
        final Map<String, dynamic> responseBody = json.decode(response.body);

        print("login successfully");
        users = responseBody["result"]["data"]["json"];
        print("Data : " + users.toString());
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid datas")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Black  field not allowed")));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: login1,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
