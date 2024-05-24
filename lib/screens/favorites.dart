import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/screens/video_player.dart';

import '../blocs/favorite_bloc.dart';
import '../models/video.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoritos"),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, Video>>(
        stream: bloc.outFav,
        initialData: const {},
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.data!.values.map(
              (video) {
                return InkWell(
                  onTap: () {
                    // Chamando a página para abrir vídeo
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VideoPlayer(video: video),
                      ),
                    );
                  },
                  onLongPress: () {
                    //Removerá vídeo dos favoritos
                    bloc.toggleFavorite(video);
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: Image.network(video.thumb),
                      ),
                      Expanded(
                          child: Text(
                        video.title,
                        maxLines: 2,
                      )),
                    ],
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
