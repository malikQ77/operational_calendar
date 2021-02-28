import 'dart:convert';

import 'package:http/http.dart' as http;

class CallApi{
  final String _url = 'http://127.0.0.1:8001/';

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }
  getData(apiUrl) async {
    var fullUrl = _url + apiUrl ;
    return await http.get(
        fullUrl,
        headers: _setHeaders()
    );
  }
  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
  };

}