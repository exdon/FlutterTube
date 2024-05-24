import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/widgets/video_tile.dart';

import '../models/video.dart';
import 'favorites.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 25,
          child: Image.asset("images/youtube-logo-with-name.png"),
        ),
        elevation: 0,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Retornando a qtd de vídeos que tem nos favoritos
                  return Text("${snapshot.data?.length}");
                } else {
                  return Container();
                }
              },
            ),
          ),
          IconButton(
            onPressed: () {
              // Abre tela de favoritos
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Favorites(),
                ),
              );
            },
            icon: const Icon(Icons.star),
          ),
          IconButton(
            onPressed: () async {
              // Pegando o valor digitado no campo de busca
              String? result =
                  await showSearch(context: context, delegate: DataSearch());

              // Enviando o dado digitado para o BLoC
              if (result != null) {
                BlocProvider.getBloc<VideosBloc>().inSearch.add(result);
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: BlocProvider.getBloc<VideosBloc>().outVideos,
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  // Retornará apenas a qtd de vídeo que existir
                  return VideoTile(video: snapshot.data[index]);
                } else if (index > 1) {
                  // Para retornar os próximos 10 vídeos
                  BlocProvider.getBloc<VideosBloc>().inSearch.add(null);
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: snapshot.data.length + 1, //qtd de itens
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
