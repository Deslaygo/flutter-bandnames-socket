class Band {
  String id;
  String name;
  int votes;

  Band({required this.id, required this.name, required this.votes});

  Band.fromMap(Map<String, dynamic> map)
      : id = map['id'].toString(),
        name = map['name'].toString(),
        votes = map['votes'] == null ? 0 : int.parse(map['votes'].toString());
}
