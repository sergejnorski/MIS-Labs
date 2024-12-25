class Joke {
  final String type;
  final String setup;
  final String punchline;
  bool isFavorite;

  Joke({
    required this.type,
    required this.setup,
    required this.punchline,
    this.isFavorite = false,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      type: json['type'],
      setup: json['setup'],
      punchline: json['punchline'],
    );
  }
}
