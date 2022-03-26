import 'package:intl/intl.dart';

class Comment {
  static final DateFormat dateFormatter = DateFormat("yyy.MM.dd");
  final DateTime date;
  String comment;

  Comment(this.date, this.comment);

  String getTitle() {
    var line = comment.split("\n")[0];
    if(line.startsWith("# ") || line.startsWith("## ")){
      return line.replaceAll("# ", "").replaceAll("## ", "");
    }else{
      line = getStrippedComment().split("\n")[0];
      return line+"...";
    }
  }

  String getStrippedComment() {
    return comment
        .replaceAll("**", "")
        .replaceAll("_", "")
        .replaceAll("# ", "")
        .replaceAll("## ", "");
  }

  Map<String, String> toMapForDb() {
    return {'date':Comment.dateFormatter.format(date), 'comment': comment};
  }

  static Comment fromDb(Map<String, dynamic> first) {
    return Comment(Comment.dateFormatter.parse(first['date']), first['comment']);
  }
}
