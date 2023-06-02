enum LoanCategory {
  screens,
  boardGames,
  iZettles,
  coffeePots,
  tents,
  other;

  @override
  String toString() {
    // ignore: unnecessary_this
    final trimmed = this.name.split('.').last;
    final titleCased = trimmed
        .trim()
        .split(' ')
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');

    return titleCased;
  }
}
