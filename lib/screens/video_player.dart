import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/video.dart';

class VideoPlayer extends StatelessWidget {
  const VideoPlayer({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();

    final youtubeController = YoutubePlayerController(
        initialVideoId: video.id,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          isLive: false,
          forceHD: true,
          enableCaption: true,
          loop: false,
        ));

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player portraitUp after exiting fullscreen
        // this overrides th behaviour
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: youtubeController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.white70,
        ),
        aspectRatio: 16 / 9,
        topActions: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              youtubeController.metadata.title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, size: 25),
          ),
        ],
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 25,
            child: Image.asset("images/youtube-logo-with-name.png"),
          ),
          elevation: 0,
          actions: [
            StreamBuilder<Map<String, Video>>(
              stream: bloc.outFav,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return IconButton(
                    icon: Icon(snapshot.data!.containsKey(video.id)
                        ? Icons.star
                        : Icons.star_border),
                    iconSize: 30,
                    onPressed: () {
                      bloc.toggleFavorite(video);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    video.title,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 26,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        video.channel,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.thumb_up_alt_outlined,
                            size: 16,
                          ),
                        ),
                        const Text("2,1 mil"),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.thumb_down_alt_outlined,
                            size: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share,
                            size: 16,
                          ),
                        ),
                        const Text("Compartilhar"),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.download_outlined,
                            size: 16,
                          ),
                        ),
                        const Text("Download"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
