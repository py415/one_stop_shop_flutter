import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  Timer _authTimer;

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

      _autoLogout();
      notifyListeners();

      // Save authentication token, user id, and expiry date for auto login.
      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );

      preferences.setString('userData', userData);
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

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();

    // Check if there is any user data preferences saved before.
    if (!preferences.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(preferences.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    // Check if we have already reached token expiry date.
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();

    return true;
  }

  // Log out currently logged in user.
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  // Automatically log out user when timer is up.
  void _autoLogout() {
    // Cancel existing timer.
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timetoExpiry = _expiryDate.difference(DateTime.now()).inSeconds;

    // Set timer for time left before token expires.Automatically log out user when timer is up.
    _authTimer = Timer(
      Duration(seconds: timetoExpiry),
      logout,
    );
  }
}
