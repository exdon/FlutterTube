import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/video.dart';

class FavoriteBloc implements BlocBase {
  late Map<String, Video> _favorites = {};

  FavoriteBloc() {
    // Retornando a lista de favoritos no SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      // Verifica se já existe uma lista de favoritos salva
      if(prefs.getKeys().contains("favorites")) {
        // salvando lista de favoritos
        _favorites = json.decode(prefs.getString("favorites")!).map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();

        // Salvando favoritos no Stream
        _favController.add(_favorites);
      }
    });
  }

  final StreamController<Map<String, Video>> _favController =
      BehaviorSubject<Map<String, Video>>.seeded({});

  //Getter para recuperar os vídeos adicionados no Stream
  Stream<Map<String, Video>> get outFav => _favController.stream;

  // Função que irá adicionar/remover vídeos dos favoritos
  void toggleFavorite(Video video) {
    // Verifica se o vídeo já está na lista de favoritos
    if(_favorites.containsKey(video.id)) {
      // remove o vídeo dos favoritos
      _favorites.remove(video.id);
    } else {
      // adiciona aos favoritos
      _favorites[video.id] = video;
    }

    // Adicionando os videos dos favoritos no StremController
    _favController.sink.add(_favorites);

    // Salvando a lista de favoritos no SharedPreferences
    _saveFav();
  }

  // Função que salva a lista de favoritos no SharedPreferences
  void _saveFav() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", json.encode(_favorites));
    });
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }
}
