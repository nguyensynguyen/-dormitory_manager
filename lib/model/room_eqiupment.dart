class RoomEquipment {
  int id;
  String roomEquipmentName;
  String status;
  int roomId;

  RoomEquipment(
      {this.roomId,
        this.id,
        this.roomEquipmentName,
        this.status,
        });

  factory RoomEquipment.fromJson(Map<String, dynamic> json) => RoomEquipment(
    id: json['id'],
    roomEquipmentName: json['room_equipment_name'],
    status: json['status'],
    roomId: json['room_id'],
  );
}
