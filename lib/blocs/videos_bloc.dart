import 'dart:async';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/api.dart';

import '../models/video.dart';

class VideosBloc implements BlocBase {
  late Api api;

  late List<Video> videos;

  // Stream
  final StreamController<List<Video>> _videosController =
      StreamController<List<Video>>();

  //Getter para recuperar os vídeos adicionados no Stream
  Stream get outVideos => _videosController.stream;

  // Para receber o dado digitado na busca de vídeos
  final StreamController<String?> _searchController = StreamController<String?>();

  //Getter para adicionar o dado digitado na busca no Stream
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();

    // Pegando dado do Stream e enviando para a API
    _searchController.stream.listen(_search);
  }

  // Função que será chamada toda vez que _searchController receber um dado
  void _search(String? search) async {
    // Verifica se algum valor de busca foi passado
    if(search != null) {
      // Lista vazia para evitar erro de busca no fim da lista
      _videosController.sink.add([]);

      // solicitando dados da api
      videos = await api.search(search);
    } else {
      // adicionando a lista os próximos 10 vídeos
      videos += await api.nextVideos();
    }

    // Adicionando os videos retornados da API para o StremController
    _videosController.sink.add(videos);
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    // Fechando conexão com o StreamController
    _videosController.close();
    _searchController.close();
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
