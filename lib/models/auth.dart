import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _userId;
  String? _token;
  DateTime? _expiryDate;

  bool get isToken {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  // authentication...
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAY9GeTeVHdhOlbUhfsSTlmLFII_SJG3As';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final extractedBody = json.decode(response.body);
      if (extractedBody['error'] != null) {
        throw HttpException(extractedBody['error']['message']);
      }
      _userId = extractedBody['localId'];
      _token = extractedBody['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(extractedBody['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
    // print(json.decode(response.body));
  }

  // sending a request...
  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  // sendig a request for signing in....
  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
