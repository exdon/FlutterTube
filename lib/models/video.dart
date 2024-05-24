class Video {
  final String id;
  final String title;
  final String thumb;
  final String channel;

  Video(
      {
        required this.id,
        required this.title,
        required this.thumb,
        required this.channel
      }
    );

  // Transforma JSON em um objeto
  factory Video.fromJson(Map<String, dynamic> json) {
    if(json.containsKey("id")) {
      // Busca na API
      return Video(
        id: json["id"]["videoId"],
        title: json["snippet"]["title"],
        thumb: json["snippet"]["thumbnails"]["high"]["url"],
        channel: json["snippet"]["channelTitle"],
      );
    } else {
      return Video(
        id: json["videoId"],
        title: json["title"],
        thumb: json["thumb"],
        channel: json["channel"]
      );
    }
  }

  // Transforma um Objeto em JSON
  Map<String, dynamic> toJson() {
    return {
      "videoId": id,
      "title": title,
      "thumb": thumb,
      "channel": channel
    };
  }

}
