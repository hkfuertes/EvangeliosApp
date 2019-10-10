class Comment {
  final RegExp title1 = RegExp('^#');
  final RegExp title2 = RegExp('^##');
  final DateTime date;
  final String comment;

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
}
