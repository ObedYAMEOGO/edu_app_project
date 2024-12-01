extension StringExt on String {
  String get obscureEmail {
    // split the email into username and domain
    final index = indexOf('@');
    var username = substring(0, index);
    final domain = substring(index + 1);

    // Obscure the username and display only the first and last characters
    username = '${username[0]}****${username[username.length - 1]}';
    return '$username@$domain';
  }

  bool get isYouTubeVideo {
    final youtubeRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$',
    );
    return youtubeRegex.hasMatch(this);
  }

  String get capitalize {
    if (trim().isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get titleCase {
    if (trim().isEmpty) return this;
    return split(' ').map<String>((e) => e.capitalize).toList().join(' ');
  }
}

