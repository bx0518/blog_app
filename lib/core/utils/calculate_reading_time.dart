int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;

  // speed = average reading word count per minutes
  final readingTime = wordCount / 225;

  return readingTime.ceil();
}
