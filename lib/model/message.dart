class Message {
  int id;
  String title;
  String content;
  String status;
  int roomId;
  int managerId;
  int userId;

  Message(
      {this.status,
      this.id,
      this.roomId,
      this.managerId,
      this.userId,
      this.content,
      this.title});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        status: json['status'],
        roomId: json['room_id'],
        managerId: json['manager_id'],
        userId: json['user_id'],
        content: json['content'],
        title: json['title'],
      );
}
