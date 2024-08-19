import 'package:gemini_app/screen/home/model/home_model.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class ApiHelper {
  static ApiHelper helper =ApiHelper._();
  ApiHelper._();


  Future<HomeModel?> getData(String question)
  async {
    String link="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyAWXuLfaTyATB8M7PEw07hc1lDGFH6pjPI";
    final body=jsonEncode({
      "contents": [{
        "parts":[{
          "text": question}]}]});
    var res=await http.post(Uri.parse(link),headers: {"Content-Type":"application/json"},body: body);
    if(res.statusCode==200)
      {
        var json=jsonDecode(res.body);
        HomeModel homeModel=HomeModel.mapToModel(json);
        return homeModel;
      }
    return null;
  }
}
