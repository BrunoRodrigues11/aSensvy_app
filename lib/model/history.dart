class Historico {
  String? sId;
  String? file;
  String? name;
  int? score;
  String? user;
  String? date;
  int? iV;

  Historico({
    this.sId,
    this.file,
    this.name,
    this.score,
    this.user,
    this.date,
    this.iV,
  });

  Historico.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    file = json['file'];
    name = json['name'];
    score = json['score'];
    user = json['user'];
    date = json['date'];
    iV = json['__v'];
  }
}
