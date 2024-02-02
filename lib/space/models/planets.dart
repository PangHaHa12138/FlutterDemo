class PlanetsModel {
  int? id;
  String? name;
  String? description;
  String? thumbnail;
  double? size;
  String? distanceFromSun;
  List<String>? images;

  PlanetsModel(
      {this.id,
      this.name,
      this.description,
      this.thumbnail,
      this.size,
      this.distanceFromSun,
      this.images});

  PlanetsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    size = json['size'];
    distanceFromSun = json['distanceFromSun'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['thumbnail'] = thumbnail;
    data['size'] = size;
    data['distanceFromSun'] = distanceFromSun;
    data['images'] = images;
    return data;
  }
}
