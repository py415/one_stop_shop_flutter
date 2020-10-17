import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../constants.dart';

// Blueprint for user authentication.
class Auth with ChangeNotifier {
  // Token used for authentication purposes.
  String _token;
  // Time when user authentication token is expired.
  DateTime _expiryDate;
  // ID of user.
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  String get userId => _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = fetchAuthUrl(urlSegment);

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  // Registration authentication.
  Future<void> register(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  // Login authentication.
  Future<void> login(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
