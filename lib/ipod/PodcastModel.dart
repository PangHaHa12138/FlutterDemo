class PodcastModel {
  String? status;
  List<Episodes>? episodes;
  int? count;
  String? max;
  String? description;

  PodcastModel(
      {this.status, this.episodes, this.count, this.max, this.description});

  PodcastModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['episodes'] != null) {
      episodes = <Episodes>[];
      json['episodes'].forEach((v) {
        episodes!.add(Episodes.fromJson(v));
      });
    }
    count = json['count'];
    max = json['max'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (episodes != null) {
      data['episodes'] = episodes!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['max'] = max;
    data['description'] = description;
    return data;
  }
}

class Episodes {
  int? id;
  String? title;
  String? link;
  String? description;
  String? guid;
  int? datePublished;
  String? datePublishedPretty;
  int? dateCrawled;
  String? enclosureUrl;
  String? enclosureType;
  int? enclosureLength;
  int? explicit;
  int? episode;
  String? episodeType;
  int? season;
  String? image;
  int? feedItunesId;
  String? feedImage;
  int? feedId;
  String? feedTitle;
  String? feedLanguage;
  Categories? categories;
  String? chaptersUrl;

  Episodes(
      {this.id,
      this.title,
      this.link,
      this.description,
      this.guid,
      this.datePublished,
      this.datePublishedPretty,
      this.dateCrawled,
      this.enclosureUrl,
      this.enclosureType,
      this.enclosureLength,
      this.explicit,
      this.episode,
      this.episodeType,
      this.season,
      this.image,
      this.feedItunesId,
      this.feedImage,
      this.feedId,
      this.feedTitle,
      this.feedLanguage,
      this.categories,
      this.chaptersUrl});

  Episodes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    link = json['link'];
    description = json['description'];
    guid = json['guid'];
    datePublished = json['datePublished'];
    datePublishedPretty = json['datePublishedPretty'];
    dateCrawled = json['dateCrawled'];
    enclosureUrl = json['enclosureUrl'];
    enclosureType = json['enclosureType'];
    enclosureLength = json['enclosureLength'];
    explicit = json['explicit'];
    episode = json['episode'];
    episodeType = json['episodeType'];
    season = json['season'];
    image = json['image'];
    feedItunesId = json['feedItunesId'];
    feedImage = json['feedImage'];
    feedId = json['feedId'];
    feedTitle = json['feedTitle'];
    feedLanguage = json['feedLanguage'];
    categories = json['categories'] != null
        ? Categories.fromJson(json['categories'])
        : null;
    chaptersUrl = json['chaptersUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['link'] = link;
    data['description'] = description;
    data['guid'] = guid;
    data['datePublished'] = datePublished;
    data['datePublishedPretty'] = datePublishedPretty;
    data['dateCrawled'] = dateCrawled;
    data['enclosureUrl'] = enclosureUrl;
    data['enclosureType'] = enclosureType;
    data['enclosureLength'] = enclosureLength;
    data['explicit'] = explicit;
    data['episode'] = episode;
    data['episodeType'] = episodeType;
    data['season'] = season;
    data['image'] = image;
    data['feedItunesId'] = feedItunesId;
    data['feedImage'] = feedImage;
    data['feedId'] = feedId;
    data['feedTitle'] = feedTitle;
    data['feedLanguage'] = feedLanguage;
    if (categories != null) {
      data['categories'] = categories!.toJson();
    }
    data['chaptersUrl'] = chaptersUrl;
    return data;
  }
}

class Categories {
  String? s20;
  String? s25;

  Categories({this.s20, this.s25});

  Categories.fromJson(Map<String, dynamic> json) {
    s20 = json['20'];
    s25 = json['25'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['20'] = s20;
    data['25'] = s25;
    return data;
  }
}
