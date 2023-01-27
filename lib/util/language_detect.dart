enum Languages {
  persian,
  english,
  myanmar,
  arabic,
  chinese,
  japanese,
  korean,
  other
}

class JackLanguageDetect {
  static final _persian = RegExp(r'[\u0600-\u06FF]');
  static final _english = RegExp(r'[a-zA-Z]');
  static final _myanmar = RegExp(r'[\u1000-\u1021]');
  static final _arabic = RegExp(r'[\u0750-\u077F]');
  static final _chinese = RegExp(r'[\u4E00-\u9FFF]');
  static final _japanese = RegExp(r'[\u3040-\u309F]');
  static final _korean = RegExp(r'[\uAC00-\uD7AF]');

  static Languages detect({required String str}) {
    if (_persian.hasMatch(str)) {
      return Languages.persian;
    } else if (_english.hasMatch(str)) {
      return Languages.english;
    } else if (_arabic.hasMatch(str)) {
      return Languages.arabic;
    } else if (_chinese.hasMatch(str)) {
      return Languages.chinese;
    } else if (_japanese.hasMatch(str)) {
      return Languages.japanese;
    } else if (_korean.hasMatch(str)) {
      return Languages.korean;
    } else {
      return Languages.other;
    }
  }

  static bool detectMyanmar({required String str}) {
    if (_myanmar.hasMatch(str)) {
      return true;
    } else {
      return false;
    }
  }
}
