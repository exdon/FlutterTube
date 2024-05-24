import 'dart:convert';

import 'package:fluttertube/models/video.dart';
import 'package:http/http.dart' as http;


const API_KEY = "AIzaSyDTzLslfDRfnpcpLkd-ueqN7CmpOUtX7rc";

class Api {

  late String _search;
  late String _nextToken;

  // Busca no YouTube
  Future<List<Video>> search(String search) async {
    _search = search;

    //Requisição http
    http.Response response = await http.get(
        Uri.parse("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10")
    );

    return decode(response);
  }

  // Carrega mais vídeos
  Future<List<Video>> nextVideos() async {
    //Requisição http
    http.Response response = await http.get(
        Uri.parse("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken")
    );

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    // Sucesso
    if(response.statusCode == 200) {
      var decoded = json.decode(response.body);

      // armazenando o pageToken
      _nextToken = decoded["nextPageToken"];

      // Transformando JSON em uma lista de vídeos
      List<Video> videos = decoded["items"].map<Video>((video) {
        return Video.fromJson(video);
      }).toList();

      return videos;
    } else {
      throw Exception("Failed to load videos");
    }
  }
}