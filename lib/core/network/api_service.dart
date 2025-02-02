import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService{
 static Future<dynamic> get(String url) async{
    try{
      var response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        var responseBody= response.body;
        var responseJson = json.decode(responseBody);
        return responseJson;
      }else{
        throw Exception('Failed to load data!');
      }
    }catch(e){
      print(e);
    }
  }
}